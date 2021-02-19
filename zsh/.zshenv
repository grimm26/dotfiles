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
export TFSWITCH_BIN=${HOME}/.local/bin/terraform
alias tfsw="tfswitch --bin $TFSWITCH_BIN"
tf11 () {
  ln -fs ~/bin/terragrunt_18 ~/bin/terragrunt
  tfsw 0.11.14
}
tf12 () {
  ln -fs ~/bin/terragrunt_latest ~/bin/terragrunt
  tfsw --latest-stable 0.12
}
tf13 () {
  ln -fs ~/bin/terragrunt_latest ~/bin/terragrunt
  tfsw --latest-stable 0.13
}
tf14 () {
  ln -fs ~/bin/terragrunt_latest ~/bin/terragrunt
  tfsw --latest-stable 0.14
}
alias tfver=terraform version | awk '{print $2}'
go13 () {
  tf13
  tf 0.13upgrade -yes
  audit-terraform-modules -r
  atlantis_yaml_mod.rb --tfver $(terraform version | awk '{print $2}')
}
go14 () {
  tf14
  audit-terraform-modules -r
  atlantis_yaml_mod.rb --tfver $(terraform version | awk '{print $2}')
}
alias tgi="terragrunt init -upgrade -reconfigure"
alias tgu="terragrunt 0.12upgrade -yes;chompeof *.tf;uniq main.tf > main.tfu;mv main.tfu main.tf;sed -i tmp '/^\s*$/d' versions.tf;rm versions.tftmp"
alias tfu="terraform 0.12upgrade -yes;chompeof *.tf"
export AWS_DEFAULT_REGION=us-east-2
