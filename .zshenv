if [[ $XDG_SESSION_TYPE == wayland ]]; then
  export MOZ_ENABLE_WAYLAND=1
  export QT_QPA_PLATFORM=wayland
fi
skip_global_compinit=1
export GOPATH=~/go
path+=(${GOPATH}/bin)
path=('/usr/local/bin' '/usr/local/sbin' $path)
if [[ -d /usr/local/go/bin ]]; then
  path+=('/usr/local/go/bin')
fi
if [[ -d /usr/local/nodejs/bin ]]; then
  path+=('/usr/local/nodejs/bin')
fi
if [[ -d /usr/local/opt/gnu-getopt/bin ]]; then
  path=('/usr/local/opt/gnu-getopt/bin' $path)
fi
if [[ -d /usr/local/opt/curl/bin ]]; then
  path=('/usr/local/opt/curl/bin' $path)
fi
if [[ -d ${HOME}/.cargo/bin ]]; then
  path=("${HOME}/.cargo/bin" $path)
fi
if [[ -d ${HOME}/.local/kitty.app/bin ]]; then
  path+=(${HOME}/.local/kitty.app/bin)
fi
export MY_BIN="$HOME/.local/bin"
path=("$MY_BIN" $path)
if [[ -d ${HOME}/.tenv/bin ]]; then
  path=("${HOME}/.tenv/bin" $path)
fi
# Probably unnecessary since this is in .profile
if [[ -d ${HOME}/.pyenv ]]; then
  if [[ ":$PATH:" == *":$PYENV_ROOT/bin:"* ]]; then
    :
  else
    export PYENV_ROOT="$HOME/.pyenv"
    path=("$PYENV_ROOT/bin" $path)
    [[ -d $PYENV_ROOT/bin ]] && path=("$PYENV_ROOT/bin" $path)
    eval "$(pyenv init -)"
  fi
fi
typeset -U PATH path
export PATH
(( ${+commands[mise]} )) && eval "$(mise activate zsh)"

if (( ${+commands[tenv]} )); then
  # Have tenv automatically install versions that aren't installed
  export TENV_AUTO_INSTALL=true
  # https://github.com/tofuutils/tenv/issues/305
  export TENV_DETACHED_PROXY=false
  export TFENV_TERRAFORM_DEFAULT_VERSION=1.9.8
fi
# https://terragrunt.gruntwork.io/docs/reference/cli-options/#terragrunt-forward-tf-stdout
export TG_LOG_FORMAT=bare
# https://terragrunt.gruntwork.io/docs/reference/cli-options/#terragrunt-disable-command-validation
export TG_DISABLE_COMMAND_VALIDATION=true
# https://terragrunt.gruntwork.io/docs/features/provider-cache/
# export TG_PROVIDER_CACHE=1
export TG_PROVIDER_CACHE_DIR="$HOME/.terraform.d/plugin-cache"
export TF_PLUGIN_CACHE_DIR="$HOME/.terraform.d/plugin-cache"
# Disable terraform checkpoint https://developer.hashicorp.com/terraform/cli/commands#upgrade-and-security-bulletin-checks
export CHECKPOINT_DISABLE=1

 #ignore ~/.ssh/known_hosts entries
alias insecssh='ssh -o "StrictHostKeyChecking=no" -o "UserKnownHostsFile=/dev/null" -o "PreferredAuthentications=password,keyboard-interactive"'

if [[ -d /usr/local/opt/curl/share/zsh/site-functions ]]; then
  fpath+=( /usr/local/opt/curl/share/zsh/site-functions )
elif [[ -d /usr/local/share/zsh/site-functions ]]; then
  fpath+=( /usr/local/share/zsh/site-functions )
fi
[[ -d ~/.zcompletions ]] && fpath+=~/.zcompletions
typeset -U fpath

export LESS="-EFRX"
export CHEF_ENV_PATH="$HOME/git/chef/environments"
export LC_COLLATE=C
if (( ${+commands[nvim]} )); then
  export EDITOR=nvim
else
  export EDITOR=vim
fi
alias kit=kitchen
alias tglog="TF_LOG=TRACE TF_LOG_PATH=./tflog.out terragrunt"

terraform () {
  local need_env=0
  if [[ -a terragrunt.hcl ]]; then
    for arg in "$@"; do
      case $arg in
        plan|apply|destroy|import|state|validate|taint|untaint)
          need_env=1
          ;;
      esac
    done
    if typeset -f tfenv >/dev/null && [[ $need_env == 1 ]]; then
      tfenv
      atlantis_kube_link
      source $ENOVA_ATLANTIS_VAR_CACHE
    fi
    TG_TF_PATH=terraform command terragrunt run -- "$@"
  else
    command terraform "$@"
  fi
}
tofu () {
  local need_env=0
  if [[ -a terragrunt.hcl ]]; then
    for arg in "$@"; do
      case $arg in
        plan|apply|destroy|import|state|validate|taint|untaint)
          need_env=1
          ;;
      esac
    done
    if typeset -f tfenv >/dev/null && [[ $need_env == 1 ]]; then
      tfenv
      atlantis_kube_link
      source $ENOVA_ATLANTIS_VAR_CACHE
    fi
    TG_TF_PATH=tofu command terragrunt run -- "$@"
  else
    command tofu "$@"
  fi
}

alias tg=terragrunt
terragrunt () {
  local need_env=0
  local has_tf_path=false
  local has_log_level=false
  local extra_args=()
  for arg in "$@"; do
    if [[ $arg == --tf-path* ]]; then
      local has_tf_path=true
    elif [[ $arg == init ]]; then
      need_env=1
    else
      case $arg in
	plan|apply|destroy|import|state|validate|taint|untaint)
	  need_env=1
	  ;;
      esac
    fi
  done
  if [[ -v TG_TF_PATH ]]; then
    local has_tf_path=true
  fi
  local rebuilt_args=()
  if [[ ${#extra_args} -gt 0 ]]; then
    for arg in "$@"; do
      if [[ $arg == -- ]]; then
        for extra in "${extra_args[@]}"; do
          rebuilt_args+=($extra)
        done
	      rebuilt_args+=("--")
      else
	      rebuilt_args+=("$arg")
      fi
    done
  else
    rebuilt_args=("$@")
  fi
  if typeset -f tfenv >/dev/null && [[ $need_env == 1 ]]; then
    tfenv
    atlantis_kube_link
    source $ENOVA_ATLANTIS_VAR_CACHE
  fi
  if [[ $has_tf_path == true ]]; then
    command terragrunt "${rebuilt_args[@]}"
  elif [[ -s atlantis.yaml ]]; then
    if grep -q 'terraform_distribution: opentofu' atlantis.yaml; then
      TG_TF_PATH=tofu command terragrunt "${rebuilt_args[@]}"
    else
      TG_TF_PATH=terraform command terragrunt "${rebuilt_args[@]}"
    fi
  else
    command terragrunt "${rebuilt_args[@]}"
  fi
}

whatsmyip () {
  curl -s https://checkip.amazonaws.com/
}

# For omz aws plugin
export SHOW_AWS_PROMPT=false

export GCAL="-q US_IL"
export lan_proxy="http://192.168.15.1:3128"
export wlan_proxy="http://192.168.16.1:3128"
if [[ -r ~/.zshenv.local ]]; then
  source ~/.zshenv.local
fi
