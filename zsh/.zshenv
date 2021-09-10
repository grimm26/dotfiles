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
alias tglog="TF_LOG=TRACE TF_LOG_PATH=./tflog.out terragrunt"
export TFSWITCH_BIN=${HOME}/.local/bin/terraform
alias tfsw="tfswitch --bin $TFSWITCH_BIN"
export TGSWITCH_BIN=${HOME}/.local/bin/terragrunt
alias tgsw="tgswitch --bin $TGSWITCH_BIN"

tg () {
  terragrunt "$@"
}

# create a cache file for what the latest version of terragrunt is.
# If the file is older than 24 hours, refresh it.
# The globbing is a little complicated here:
# - '#q' is an explicit glob qualifier that makes globbing work within zsh's [[ ]] construct.
# - 'N' makes the glob pattern evaluate to nothing when it doesn't match (rather than throw a globbing error)
# - '.' matches "regular files"
# - 'mh+24' matches files (or directories or whatever) that are older than 24 hours.
get_tg_latest_version () {
  if [[ -s ~/.terragrunt_latest_version ]]; then
    if [[ -n ~/.terragrunt_latest_version(#qN.mh+24) ]]; then
      retrieved_latest=$(curl -sLS  https://api.github.com/repos/gruntwork-io/terragrunt/releases/latest |jq -r '.tag_name' |tr -d 'v')
    fi
  else
    retrieved_latest=$(curl -sLS  https://api.github.com/repos/gruntwork-io/terragrunt/releases/latest |jq -r '.tag_name' |tr -d 'v')
  fi

  if [[ -v retrieved_latest && ${retrieved_latest} != "null" ]]; then
    echo ${retrieved_latest} > ~/.terragrunt_latest_version
  fi
  export TG_LATEST_VERSION=$(cat ~/.terragrunt_latest_version)
}

get_tg_latest_version

tf11 () {
  tgsw 0.18.7
  tfsw --latest-stable 0.11
}
tf12 () {
  tgsw 0.24.4
  tfsw --latest-stable 0.12
}
# terraform 0.13 and up should work with the latest terragrunt version - 2021-09-10
tf13 () {
  tgsw $TG_LATEST_VERSION
  tfsw --latest-stable 0.13
}
tf14 () {
  tgsw $TG_LATEST_VERSION
  tfsw --latest-stable 0.14
}
tf15 () {
  tgsw $TG_LATEST_VERSION
  tfsw --latest-stable 0.15
}
tf1.0 () {
  tgsw $TG_LATEST_VERSION
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
alias tgi="tg init -upgrade -reconfigure"
alias tgu="tf12 && terragrunt 0.12upgrade -yes;chompeof *.tf;uniq main.tf > main.tfu;mv main.tfu main.tf;sed -i tmp '/^\s*$/d' versions.tf;rm versions.tftmp"
alias tfu="tf12 && terraform 0.12upgrade -yes;chompeof *.tf"
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
