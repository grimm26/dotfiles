#export LSCOLORS="ehfxcxdxbxegedabagacad"
eval "$(hub alias -s)"

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
        terragrunt_18 "$@"| landscape
        ;;
      *)
        terragrunt_18 "$@"
    esac
  else
    terragrunt_18 "$@"
  fi
}
# Homebrew
alias binfo='brew info'
alias bs='brew search'

#Git
alias gnb='git nb'
alias grtag='git rtag'
alias ghpr='git pull-request'

if [[ -d /usr/libexec/java_home ]]; then
  export JAVA_HOME=$(/usr/libexec/java_home)
fi
# completion system
autoload -Uz compinit; compinit

## oh-my-zsh lib/directories.zsh
alias -g ...='../..'
alias -g ....='../../..'
alias -g .....='../../../..'
alias -g ......='../../../../..'

alias -- -='cd -'
alias 1='cd -'
alias 2='cd -2'
alias 3='cd -3'
alias 4='cd -4'
alias 5='cd -5'
alias 6='cd -6'
alias 7='cd -7'
alias 8='cd -8'
alias 9='cd -9'

alias md='mkdir -p'
alias rd=rmdir

function d () {
  if [[ -n $1 ]]; then
    dirs "$@"
  else
    dirs -v | head -10
  fi
}
compdef _dirs d

# List directory contents
alias lsa='ls -lah'
alias l='ls -lah'
alias ll='ls -lh'
alias la='ls -lAh'
##

## oh-my-zsh lib/grep.zsh
__GREP_CACHE_FILE="$ZSH_CACHE_DIR"/grep-alias

# See if there's a cache file modified in the last day
__GREP_ALIAS_CACHES=("$__GREP_CACHE_FILE"(Nm-1))
if [[ -n "$__GREP_ALIAS_CACHES" ]]; then
    source "$__GREP_CACHE_FILE"
else
    grep-flags-available() {
        command grep "$@" "" &>/dev/null <<< ""
    }

    # Ignore these folders (if the necessary grep flags are available)
    EXC_FOLDERS="{.bzr,CVS,.git,.hg,.svn,.idea,.tox}"

    # Check for --exclude-dir, otherwise check for --exclude. If --exclude
    # isn't available, --color won't be either (they were released at the same
    # time (v2.5): https://git.savannah.gnu.org/cgit/grep.git/tree/NEWS?id=1236f007
    if grep-flags-available --color=auto --exclude-dir=.cvs; then
        GREP_OPTIONS="--color=auto --exclude-dir=$EXC_FOLDERS"
    elif grep-flags-available --color=auto --exclude=.cvs; then
        GREP_OPTIONS="--color=auto --exclude=$EXC_FOLDERS"
    fi

    if [[ -n "$GREP_OPTIONS" ]]; then
        # export grep, egrep and fgrep settings
        alias grep="grep $GREP_OPTIONS"
        alias egrep="egrep $GREP_OPTIONS"
        alias fgrep="fgrep $GREP_OPTIONS"

        # write to cache file if cache directory is writable
        if [[ -w "$ZSH_CACHE_DIR" ]]; then
            alias -L grep egrep fgrep >| "$__GREP_CACHE_FILE"
        fi
    fi

    # Clean up
    unset GREP_OPTIONS EXC_FOLDERS
    unfunction grep-flags-available
fi

unset __GREP_CACHE_FILE __GREP_ALIAS_CACHES
##

[[ -x =keychain ]] && eval $(keychain --agents ssh --inherit any --eval ~/.ssh/**/*id_*sa)
#[[ -x =keychain ]] && eval $(keychain --agents ssh --inherit any --eval --confhost)

setopt HIST_IGNORE_SPACE
export LC_COLLATE=C
if [[ $OSTYPE == darwin* ]]; then
  alias ldd="otool -L"
fi
alias cim=vim
export EDITOR=vim
#export PAGER=vimpager
#export MANPAGER=vimmanpager
export PAGER=less
export MANPAGER=less
whence batman &>/dev/null && alias man=batman
whence batgrep &>/dev/null && alias rg=batgrep
alias chompeof="perl -pi -e 'chomp if eof && /^$/'"

alias perldoc="PAGER=less perldoc"
whence when &>/dev/null && when
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
[ -f /usr/local/etc/profile.d/autojump.sh ] && . /usr/local/etc/profile.d/autojump.sh

alias viaws="vim -O ~/.aws/config ~/.aws/credentials"
#source ~/.spaceshiprc
[ -f /Users/mkeisler/Library/Preferences/org.dystroy.broot/launcher/bash/br ] && \
  source /Users/mkeisler/Library/Preferences/org.dystroy.broot/launcher/bash/br
setopt prompt_subst
setopt TRANSIENT_RPROMPT
if [[ -r ~/.zsh_plugins.sh ]]; then
  echo "Statically loading ~/.zsh_plugins.sh"
  # Regen with `antibody bundle < ~/.zsh_plugins.txt > ~/.zsh_plugins.sh`
  source ~/.zsh_plugins.sh && echo "Done."
elif whence antibody &>/dev/null; then
  echo "Dynamically sourcing plugins with antibody"
  source <(antibody init)
  # Base plugins
  echo -n "... base plugins"
  antibody bundle < ~/.zsh_plugins.txt
  # Ubuntu plugins
  if [[ $OSTYPE == linux-gnu ]]; then
    if [[ $(uname -v) =~ "Ubuntu" ]]; then
      echo -n " ... Ubuntu plugins"
      antibody bundle < ~/.zsh_plugins_ubuntu.txt
    fi
  fi
  echo "\nDone."
elif [[ -r ~/.zplugrc ]]; then
  echo "Loading zsh plugins with zplug"
  source ~/.zplugrc && echo "Done."
fi
chruby ruby

whence starship &>/dev/null && \
  eval "$(starship init zsh)"
whence direnv &>/dev/null && \
  eval "$(direnv hook zsh)"
