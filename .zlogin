# # Profiling setup
# # https://esham.io/2018/02/zsh-profiling
# zmodload zsh/datetime
# setopt PROMPT_SUBST
# PS4='+$EPOCHREALTIME %N:%i> '
#
# logfile=$(mktemp zlogin_profile.XXXXXXXX)
# echo "Logging to $logfile"
# exec 3>&2 2>$logfile
#
# setopt XTRACE

#zmodload zsh/zprof

# This seems to screw up the colors, so leave it out for now
#export BAT_THEME="Solarized (dark)"

# The output will show you if this terminal is truecolor or not. If it is, the color transitions will be smooth.
colorcheck() {
  awk 'BEGIN{
    s="/\\/\\/\\/\\/\\"; s=s s s s s s s s;
    for (colnum = 0; colnum<77; colnum++) {
        r = 255-(colnum*255/76);
        g = (colnum*510/76);
        b = (colnum*255/76);
        if (g>255) g = 510-g;
        printf "\033[48;2;%d;%d;%dm", r,g,b;
        printf "\033[38;2;%d;%d;%dm", 255-r,255-g,255-b;
        printf "%s\033[0m", substr(s,colnum+1,1);
    }
    printf "\n";
  }'
}

mkcd () {
  if [ -d "$1" ]; then
    cd $1
  else
    command mkdir -pv $1 && cd $1
  fi
}

tgp () { terragrunt plan -no-color|awk 'BEGIN{f="/tmp/plan.txt"}/^---/{o=!o};{print};{if(o&&!/^---/){print>f}}'; }
tgl () {
  if [ -x =landscape ]; then
    case "$1" in
      plan)
        terragrunt "$@"| landscape
        ;;
      *)
        terragrunt "$@"
    esac
  else
    terragrunt "$@"
  fi
}
# Homebrew
alias binfo='brew info'
alias bs='brew search'

#Git
alias gnb='git nb'
alias grtag='git rtag'
alias ghpr='gh pr create'
alias gbp='git prune-branches'

if [[ -d /usr/libexec/java_home ]]; then
  export JAVA_HOME=$(/usr/libexec/java_home)
fi
# completion system
autoload -Uz compinit; compinit
##

#SSH_AUTH_SOCK=/run/user/1000/keyring/ssh
KEYCHAIN_INHERIT="local-once"
if [[ -v SSH_AUTH_SOCK ]]; then
  KEYCHAIN_INHERIT="any"
elif [[ -v SSH_AGENT_PID ]]; then
  KEYCHAIN_INHERIT="local-once"
else
  if [[ -S /run/user/$(id -u)/keyring/ssh ]]; then
    export SSH_AUTH_SOCK=/run/user/$(id -u)/keyring/ssh
    KEYCHAIN_INHERIT="any"
  elif [[ $(pgrep -u $USER ssh-agent | head -1) -gt 0 ]]; then
    export SSH_AGENT_PID=$(pgrep -u $USER ssh-agent | head -1)
  fi
fi
# Just load the top keys. ~/.ssh/config should have AddKeysToAgent set to yes.
whence -p keychain &>/dev/null &&  [[ -n  ~/.ssh/id_*sa(#qN) ]] && eval $(keychain --agents ssh --inherit $KEYCHAIN_INHERIT --eval ~/.ssh/id_*sa)

setopt HIST_IGNORE_SPACE
export LC_COLLATE=C
if [[ $OSTYPE == darwin* ]]; then
  alias ldd="otool -L"
fi
#export PAGER=vimpager
#export MANPAGER=vimmanpager
export PAGER=less
export MANPAGER=less
whence -p batman &>/dev/null && alias man=batman
whence -p fdfind &>/dev/null && ! whence fd &>/dev/null && alias fd=fdfind

alias chompeof="perl -pi -e 'chomp if eof && /^$/'"

alias perldoc="PAGER=less perldoc"
# commenting when out cuz it is perl and it takes too long.
# whence when &>/dev/null && when
setopt vi
setopt inc_append_history
#rg () { =rg --pretty $* |less }
[ -f /usr/local/share/zsh-navigation-tools/zsh-navigation-tools.plugin.zsh ] \
  && source /usr/local/share/zsh-navigation-tools/zsh-navigation-tools.plugin.zsh

## print hex value of a number
hex() {
    emulate -L zsh
    if [[ -n "$1" ]]; then
        printf "%x\n" $1
    else
        print 'Usage: hex <number-to-convert>'
        return 1
    fi
}
# Need this to get golang aws-sdk to use assumed role
export AWS_SDK_LOAD_CONFIG=true
aws_session() {
  # Clear out existing AWS_* environment variables
  for envar in $(env | grep AWS |cut -d= -f1);do
    unset $envar
  done
  export AWS_SDK_LOAD_CONFIG=true
  BASE_ACCOUNT_PROFILE_NAME=base_account
  # list of roles we can assume
  production_admin_role=arn:aws:iam::643927032162:role/admin_role
  hipaa_admin_role=arn:aws:iam::391155261759:role/admin_role
  case "$1" in
    clear)
      for envar in $(env | grep AWS |cut -d= -f1);do
        unset $envar
      done
      return
      ;;
    production)
      aws --profile $BASE_ACCOUNT_PROFILE_NAME sts assume-role --role-arn $production_admin_role --role-session-name "$USER-admin@production" --duration-seconds 900 --query 'Credentials.[AccessKeyId, SecretAccessKey, SessionToken]' --output text| read AWS_ACCESS_KEY_ID AWS_SECRET_ACCESS_KEY AWS_SESSION_TOKEN ; export AWS_ACCESS_KEY_ID && export AWS_SECRET_ACCESS_KEY && export AWS_SESSION_TOKEN
      ;;
    hipaa)
      aws --profile $BASE_ACCOUNT_PROFILE_NAME sts assume-role --role-arn $hipaa_admin_role --role-session-name "$USER-admin@production" --duration-seconds 900 --query 'Credentials.[AccessKeyId, SecretAccessKey, SessionToken]' --output text| read AWS_ACCESS_KEY_ID AWS_SECRET_ACCESS_KEY AWS_SESSION_TOKEN ; export AWS_ACCESS_KEY_ID && export AWS_SECRET_ACCESS_KEY && export AWS_SESSION_TOKEN
      ;;
    *)
      echo "Unknown role"
      return
      ;;
  esac
  case "$2" in
    or)
      export AWS_DEFAULT_REGION=us-west-2
      export AWS_REGION=us-west-2
      ;;
    oh)
      export AWS_DEFAULT_REGION=us-east-2
      export AWS_REGION=us-east-2
      ;;
    va)
      export AWS_DEFAULT_REGION=us-east-1
      export AWS_REGION=us-east-1
      ;;
    cn|bj)
      export AWS_DEFAULT_REGION=cn-north-1
      export AWS_REGION=cn-north-1
      ;;
    ???*)
      export AWS_DEFAULT_REGION=${2}
      export AWS_REGION=${2}
      ;;
  esac
  # Show the env variables that we set
  env | grep AWS
}

aws_creds() {
  for envar in $(env | grep AWS |cut -d= -f1);do
    unset $envar
  done
  case "$1" in
    clear)
      for envar in $(env | grep AWS |cut -d= -f1);do
        unset $envar
      done
      return
      ;;
    *)
      if grep -qw $1 ~/.aws/config; then
        export AWS_PROFILE=$1
      else
        echo "Invalid profile name <<$1>>"
        return 1
      fi
      ;;
  esac
  case "$2" in
    or)
      export AWS_DEFAULT_REGION=us-west-2
      export AWS_REGION=us-west-2
      ;;
    oh)
      export AWS_DEFAULT_REGION=us-east-2
      export AWS_REGION=us-east-2
      ;;
    va)
      export AWS_DEFAULT_REGION=us-east-1
      export AWS_REGION=us-east-1
      ;;
    cn|bj)
      export AWS_DEFAULT_REGION=cn-north-1
      export AWS_REGION=cn-north-1
      ;;
    ???*)
      export AWS_DEFAULT_REGION=${2}
      export AWS_REGION=${2}
      ;;
  esac
  export AWS_SDK_LOAD_CONFIG=1
  env | grep AWS
}

# List all occurrences of programm in current PATH
plap() {
    emulate -L zsh
    if [[ $# = 0 ]] ; then
        echo "Usage:    $0 program"
        echo "Example:  $0 zsh"
        echo "Lists all occurrences of program in the current PATH."
    else
        ls -l ${^path}/*$1*(*N)
    fi
}

alias viaws="vim -O ~/.aws/config ~/.aws/credentials"
#source ~/.spaceshiprc
[ -f /Users/mkeisler/Library/Preferences/org.dystroy.broot/launcher/bash/br ] && \
  source /Users/mkeisler/Library/Preferences/org.dystroy.broot/launcher/bash/br
setopt prompt_subst
setopt TRANSIENT_RPROMPT
#
# create a cache file for what the latest version of terragrunt is.
# If the file is older than 24 hours, refresh it.
# The globbing is a little complicated here:
# - '#q' is an explicit glob qualifier that makes globbing work within zsh's [[ ]] construct.
# - 'N' makes the glob pattern evaluate to nothing when it doesn't match (rather than throw a globbing error)
# - '.' matches "regular files"
# - 'mh+24' matches files (or directories or whatever) that are older than 24 hours.
get_tg_latest_version () {
  local retrieved_latest="null"
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
tf1.1 () {
  tgsw $TG_LATEST_VERSION
  tfsw --latest-stable 1.1
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
tfup () {
  local tf_version=${1:-"1.1.9"}
  atlantis_yaml_mod.rb --tfver $tf_version
  audit-terraform-modules -r
  [[ -s locals.tf ]] && crush_tf_tags.pl
  if [[ -s  versions.tf ]]; then
    sed -i 's!terraform-providers/infoblox!infobloxopen/infoblox!g' versions.tf
    sed -i 's!required_version = \"~> 1.0.0\"!required_version = \"~> 1.1\"!' versions.tf
  fi
  tfsw $tf_version
}
export AWS_DEFAULT_REGION=us-east-2
## START fzf
if [[ -d /usr/local/opt/fzf ]]; then
  # homebrew OSX
  export FZF_BASE=/usr/local/opt/fzf
elif [[ -d ~/.fzf ]]; then
  # git install linux
   export FZF_BASE=${HOME}/.fzf
fi
if whence -p fdfind &>/dev/null; then
  export FD_BIN=fdfind
fi
if whence -p fd &>/dev/null; then
  export FD_BIN=fd
fi
export FZF_DEFAULT_COMMAND="$FD_BIN --type f --hidden --exclude .git --exclude .terraform"
export FZF_DEFAULT_OPTS='--height 40% --layout=reverse --border'
export FZF_TMUX=1
export FZF_TMUX_OPTS='-p'
# Use ,, as the trigger sequence instead of the default **
export FZF_COMPLETION_TRIGGER=',,'
# Use fd (https://github.com/sharkdp/fd) instead of the default find
# command for listing path candidates.
# - The first argument to the function ($1) is the base path to start traversal
# - See the source code (completion.{bash,zsh}) for the details.
# Override _fzf_compgen_{path,dir} to use fd and ignore .terraform
_fzf_compgen_path() {
  echo "$1"
  command $FD_BIN --hidden --follow --exclude ".git" --exclude ".terraform" . "$1"
}
_fzf_compgen_dir() {
  command $FD_BIN --type d --hidden --follow --exclude ".git" --exclude ".terraform" . "$1"
}
## END fzf

# TMUX
export ZSH_TMUX_FIXTERM=false
export ZSH_TMUX_AUTOQUIT=false

# Load up plugins (mostly ohmyzsh through antibody. We want this here so it always loads.
if whence antibody &>/dev/null; then
  # Alias to save a static antibody file
  alias antistatic="$(whence -p antibody) bundle < ~/.zsh_plugins.txt > ~/.zsh_plugins.sh"
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
    antibody bundle < ~/.zsh_plugins.txt
  fi
  alias af=alias-finder
elif [[ -r ~/.zplugrc ]]; then
  source ~/.zplugrc
fi
## START post antibody/zplug overrides
alias gum='gcm && grup --prune && gmum'
alias gom='gcm && grup --prune && gmom'
# The ohmyzsh alias for this locks up
alias gtl='git tag --sort=-v:refname -n -l "${1}*"'
unalias gcl
gcl() {
  readonly repo=${1}
  local repo_only=${repo##*.com?}

  if [[ $repo =~ (github.com|git.enova.com) ]]; then
    gh repo clone $repo
  elif [[ ${#repo//[^\/]} < 2 ]]; then
    if [[ $repo =~ : ]]; then
      git clone $repo
    else
      gh repo clone $repo
    fi
  fi
  cd "$(basename ${repo%%.git})"
}
whence -p lsd &>/dev/null && alias ls=lsd
## END post antibody/zplug overrides

export ZSH_AUTOSUGGEST_HIGHLIGHT_STYLE="fg=10"
export ZSH_AUTOSUGGEST_STRATEGY=(history completion)

# fzf interactive select awscli profile
awsp ()
{
    local valid_profiles=$(grep  '^\[profile' ~/.aws/config | tr -d "[]" |awk '{print $2}' | sort);
    local valid_commands=$(print "**CLEAR**");
    local current_profile;
    local clear_preview_text='********************\n\nThis will unset AWS_PROFILE environment variable\nfrom your working environment.\n\n********************';
    if [[ -z $AWS_PROFILE ]]; then
        current_profile="AWS_PROFILE is currently not set";
    else
        current_profile="AWS_PROFILE == ${AWS_PROFILE}";
    fi;
    local SELECTED=$(print "${valid_profiles} ${valid_commands}" | fzf -1 --tac -q "${1:-""}" --prompt "${current_profile}> " --preview "([[ {} == '**CLEAR**' ]] && print \"${clear_preview_text}\") || AWS_PROFILE={} aws configure list --profile={}");
    if [[ "${SELECTED}" == "**CLEAR**" ]]; then
      asp
    else
      if ( print ${valid_profiles} | grep -q "^${SELECTED}$" ); then
        print "Setting awscli profile to ${SELECTED}"
        asp ${SELECTED}
      else
        print "Profile doesn't exist."
        print "Valid choices are:\n\n$(echo ${valid_profiles})"
      fi
    fi
}

# fd - cd to selected directory
fcd() {
  local dir
  dir=$(find ${1:-.} -path '*/\.*' -prune \
                  -o -type d -print 2> /dev/null | fzf +m) &&
  cd "$dir"
}
# cdf - cd into the directory of the selected file
cdf() {
   local file
   local dir
   file=$(fzf +m -q "$1") && dir=$(dirname "$file") && cd "$dir"
}
# using ugrep combined with preview
# select file to open in vim
# find-in-file - usage: fif <searchTerm>
fif() {
  if [ ! "$#" -gt 0 ]; then echo "Need a string to search for!"; return 1; fi
  ug --hidden --binary-files=without-match --exclude-dir=.terraform --exclude-dir=.git --files-with-matches --no-messages "$1" | fzf --bind "enter:execute(nvim {})+abort" --preview "highlight -O ansi -l {} 2> /dev/null | ug --color=always --colors=cx=0:mt=y --ignore-case --pretty --context=10 '$1' {}"
}

# load kubectl completions if/when I need them cuz this take a long time to load and I hardly run kubectl.
kubetl_comp() {
  echo "Loading kubectl completions."
  whence -p kubectl &>/dev/null && \
    source <(kubectl completion zsh)
}
echo "Loading starship prompt."
whence -p starship &>/dev/null && \
  eval "$(starship init zsh)"
echo "Loading direnv."
whence -p direnv &>/dev/null && \
  eval "$(direnv hook zsh)"

# ## End profiling
# unsetopt XTRACE
# exec 2>&3 3>&-
