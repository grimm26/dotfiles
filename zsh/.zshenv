if [[ -r ~/.zshenv.local ]]; then
  source ~/.zshenv.local
fi

[ -x /home/linuxbrew/.linuxbrew/bin/brew ] && eval $(/home/linuxbrew/.linuxbrew/bin/brew shellenv)
export GOPATH=~/go
path+=(${GOPATH}/bin)
path=('/usr/local/bin' '/usr/local/sbin' $path)
if [[ $OSTYPE == darwin* && -d ${HOME}/Library/Python/3.9/bin ]]; then
  path+=("${HOME}/Library/Python/3.9/bin")
fi
if [[ -d /usr/local/go/bin ]]; then
  path+=('/usr/local/go/bin')
fi
if [[ -d /usr/local/nodejs/bin ]]; then
  path+=('/usr/local/nodejs/bin')
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
  ln -fs ~/bin/terragrunt_18 $MY_BIN/terragrunt
  tfsw --latest-stable 0.11
}
tf12 () {
  ln -fs ~/bin/terragrunt_24.4 $MY_BIN/terragrunt
  tfsw --latest-stable 0.12
}
tf13 () {
  ln -fs ~/bin/terragrunt_latest $MY_BIN/terragrunt
  tfsw --latest-stable 0.13
}
tf14 () {
  ln -fs ~/bin/terragrunt_latest $MY_BIN/terragrunt
  tfsw --latest-stable 0.14
}
tf15 () {
  ln -fs ~/bin/terragrunt_latest $MY_BIN/terragrunt
  tfsw --latest-stable 0.15
}
tf1.0 () {
  ln -fs ~/bin/terragrunt_latest $MY_BIN/terragrunt
  tfsw --latest-stable 1.0
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
go15 () {
  tf15
  audit-terraform-modules -r
  atlantis_yaml_mod.rb --tfver $(terraform version | awk '{print $2}')
  tf fmt
}
alias tgi="terragrunt init -upgrade -reconfigure"
alias tgu="terragrunt 0.12upgrade -yes;chompeof *.tf;uniq main.tf > main.tfu;mv main.tfu main.tf;sed -i tmp '/^\s*$/d' versions.tf;rm versions.tftmp"
alias tfu="terraform 0.12upgrade -yes;chompeof *.tf"
export AWS_DEFAULT_REGION=us-east-2
# Load up plugins (mostly ohmyzsh through antibody. We want this here so it always loads.
if whence antibody &>/dev/null; then
  ANTIBODY_PLUGIN_FILES=(~/.zsh_plugins.txt)
  # Ubuntu plugins
  if [[ $OSTYPE == linux-gnu ]]; then
    if [[ $(uname -v) =~ "Ubuntu" ]]; then
      ANTIBODY_PLUGIN_FILES+=(~/.zsh_plugins_ubuntu.txt)
    fi
  fi
  # Alias to save a static antibody file
  alias antistatic="cat $ANTIBODY_PLUGIN_FILES | $(whence -p antibody) bundle > ~/.zsh_plugins.sh"
  if [[ -r ~/.zsh_plugins.sh ]]; then
    export DISABLE_AUTO_UPDATE="true"
    source $(antibody path ohmyzsh/ohmyzsh)/oh-my-zsh.sh
    unset DISABLE_AUTO_UPDATE
    source ~/.zsh_plugins.sh
  elif [[ -r ~/.zsh_plugins.txt ]]; then
    source <(antibody init)
    export DISABLE_AUTO_UPDATE="true"
    source $(antibody path ohmyzsh/ohmyzsh)/oh-my-zsh.sh
    unset DISABLE_AUTO_UPDATE
    for bundle in $ANTIBODY_PLUGIN_FILES; do
      antibody bundle < $bundle
    done
  fi
  alias af=alias-finder
elif [[ -r ~/.zplugrc ]]; then
  source ~/.zplugrc
fi
