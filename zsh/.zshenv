if [[ -r ~/.zshenv.local ]]; then
  source ~/.zshenv.local
fi
fpath+=( /usr/local/opt/curl/share/zsh/site-functions /usr/local/share/zsh/site-functions )
typeset -U fpath
export LESS="-EFRX"
export CHEF_ENV_PATH="$HOME/git/chef/environments"
export LC_COLLATE=C
export EDITOR=vim
alias kit=kitchen
alias tf=terraform
alias tg=terragrunt
alias tglog="TF_LOG=TRACE TF_LOG_PATH=./tflog.out terragrunt"
path+=(~/.tfenv/bin)
tf11 () {
  ln -fs ~/bin/terragrunt_18 ~/bin/terragrunt
  tfenv use 'latest:^0.11'
}
tf12 () {
  ln -fs ~/bin/terragrunt_latest ~/bin/terragrunt
  tfenv use 'latest:^0.12'
}
tf13 () {
  ln -fs ~/bin/terragrunt_latest ~/bin/terragrunt
  tfenv use 'latest:^0.13'
}
alias tgi="terragrunt init -upgrade -reconfigure"
alias tgu="terragrunt 0.12upgrade -yes;chompeof *.tf;uniq main.tf > main.tfu;mv main.tfu main.tf;sed -i tmp '/^\s*$/d' versions.tf;rm versions.tftmp"
alias tfu="terraform 0.12upgrade -yes;chompeof *.tf"
export AWS_DEFAULT_REGION=us-east-2
