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
typeset -U path
export PATH

# ignore ~/.ssh/known_hosts entries
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
if command -v nvim &>/dev/null; then
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
