if [[ -r ~/.zshenv.local ]]; then
  source ~/.zshenv.local
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
alias tf=terraform
alias tg=terragrunt
alias tglog="TF_LOG=TRACE TF_LOG_PATH=./tflog.out terragrunt"
alias tf11="tfenv use 'latest:^0.11';ln -fs ~/bin/terragrunt_18 ~/bin/terragrunt"
alias tf12="tfenv use 'latest:^0.12';ln -fs ~/bin/terragrunt_latest ~/bin/terragrunt"
alias tgi="terragrunt init -upgrade -reconfigure"
alias tgu="terragrunt 0.12upgrade -yes;chompeof *.tf;uniq main.tf > main.tfu;mv main.tfu main.tf;sed -i tmp '/^\s*$/d' versions.tf;rm versions.tftmp"
alias tfu="terraform 0.12upgrade -yes;chompeof *.tf"
#  export ZSH_HIGHLIGHT_HIGHLIGHTERS_DIR=/usr/local/share/zsh-syntax-highlighting/highlighters
