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
typeset -U PATH path
export PATH

# Without this terragrunt will try to use opentofu if possible.
# tenv is happy to provide it :)
export TERRAGRUNT_TFPATH=terraform
if (( ${+commands[tenv]} )); then
  # set the default constraint on what terraform version we allow.
  # https://github.com/tofuutils/tenv#project-binaries
  # export TFENV_TERRAFORM_DEFAULT_CONSTRAINT="<= 1.7.5"
  # Have tenv automatically install versions that aren't installed
  export TENV_AUTO_INSTALL=true
fi
# export TERRAGRUNT_LOG_DISABLE=1
# https://terragrunt.gruntwork.io/docs/reference/cli-options/#terragrunt-forward-tf-stdout
export TERRAGRUNT_FORWARD_TF_STDOUT=1
# https://terragrunt.gruntwork.io/docs/reference/cli-options/#terragrunt-disable-command-validation
export TERRAGRUNT_DISABLE_COMMAND_VALIDATION=1
# https://terragrunt.gruntwork.io/docs/features/provider-cache/
# export TERRAGRUNT_PROVIDER_CACHE=1
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
export TFSWITCH_BIN=${HOME}/.local/bin/terraform
alias tfsw="tfswitch --bin $TFSWITCH_BIN"

tg () {
  terragrunt "$@"
}

# For omz aws plugin
export SHOW_AWS_PROMPT=false

export GCAL="-q US_IL"
export lan_proxy="http://192.168.15.1:3128"
export wlan_proxy="http://192.168.16.1:3128"
if [[ -r ~/.zshenv.local ]]; then
  source ~/.zshenv.local
fi
