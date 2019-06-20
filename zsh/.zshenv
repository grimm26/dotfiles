if [[ -r ~/.enova.env ]]; then
  source ~/.enova.env
fi
if (( ! ${fpath[(I)/usr/local/share/zsh/site-functions]} )); then
  FPATH=/usr/local/share/zsh/site-functions:$FPATH
fi
export GOPATH=~/go
export GOBIN=$GOPATH/bin
path=(~/bin ${GOBIN} /usr/local/bin /bin /usr/bin /usr/sbin /usr/local/opt/go/libexec/bin)
typeset -U path
export CHEF_ENV_PATH="$HOME/git/chef/environments"
export LC_COLLATE=C
export EDITOR=vim
alias kit=kitchen
alias tg=terragrunt
alias tgi="terragrunt init -upgrade -reconfigure"
#  export ZSH_HIGHLIGHT_HIGHLIGHTERS_DIR=/usr/local/share/zsh-syntax-highlighting/highlighters
