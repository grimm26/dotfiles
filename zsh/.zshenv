if [[ -r ~/.zshenv.local ]]; then
  source ~/.zshenv.local
fi
fpath+=( /usr/local/opt/curl/share/zsh/site-functions /usr/local/share/zsh/site-functions )
typeset -U fpath
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
tf11 () {
  ln -fs ~/bin/terragrunt_18 ~/bin/terragrunt
  ln -fs ~/bin/terraform_0.11.14 ~/bin/terraform
}
tf12 () {
  rm ~/bin/terragrunt
  rm ~/bin/terraform
}
alias tgi="terragrunt init -upgrade -reconfigure"
alias tgu="terragrunt 0.12upgrade -yes;chompeof *.tf;uniq main.tf > main.tfu;mv main.tfu main.tf;sed -i tmp '/^\s*$/d' versions.tf;rm versions.tftmp"
alias tfu="terraform 0.12upgrade -yes;chompeof *.tf"
