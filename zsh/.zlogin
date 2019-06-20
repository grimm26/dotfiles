if [ -s /usr/local/share/chruby/chruby.sh ]; then
  . /usr/local/share/chruby/chruby.sh
  . /usr/local/share/chruby/auto.sh
  chruby ruby
elif [ -s /usr/share/chruby/chruby.sh ]; then
  . /usr/share/chruby/chruby.sh
  . /usr/share/chruby/auto.sh
  chruby ruby
elif [ -s "$HOME/.rvm/scripts/rvm" ]; then
  . "$HOME/.rvm/scripts/rvm" # Load RVM into a shell session *as a function*
fi

#export LSCOLORS="ehfxcxdxbxegedabagacad"
#eval "$(hub alias -s)"
# do stupid shit to avoid hub pr command
git () {
  if [ "pr" = "$1" ]; then
    hub pull-request
  else
    hub "$@"
  fi
}
mcd () {
  if [ -d "$1" ]; then
    cd $1
  else
    mkdir -pv $1 && cd $1
  fi
}

tgl () {
  if [ -x =scenery ]; then
    case "$1" in
      plan)
        terragrunt "$@"| scenery
        ;;
      *)
        terragrunt "$@"
    esac
  elif [ -x =landscape ]; then
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
alias bubo='brew update && echo "\nOutdated pkgs:" && brew outdated && echo "\nOutdated cask pkgs:" && brew cask outdated'
alias brews='brew list -1'
alias bu='brew upgrade'
alias binfo='brew info'
alias bs='brew search'

export JAVA_HOME=$(/usr/libexec/java_home)
# completion system
zrcautoload compinit
#rm -f ~/.zcompdump
#COMPDUMPFILE=${COMPDUMPFILE:-${ZDOTDIR:-${HOME}}/.zcompdump}
#if zrcautoload compinit ; then
   #compinit -C -d ${COMPDUMPFILE} || print 'Notice: no compinit available :('
#else
   #print 'Notice: no compinit available :('
   #function compdef { }
#fi
#source /usr/local/bin/aws_zsh_completer.sh
#source /usr/local/share/zsh-syntax-highlighting/zsh-syntax-highlighting.zsh
path=(~/tmux-master/bin $path)
typeset -U path
[[ -x =keychain ]] && eval $(keychain --agents ssh --inherit any --eval ~/.ssh/**/*id_*sa)
#[[ -x =keychain ]] && eval $(keychain --agents ssh --inherit any --eval --confhost)

#[[ -s "$HOME/.rvm/scripts/rvm" ]] && source "$HOME/.rvm/scripts/rvm" # Load RVM into a shell session *as a function*

setopt HIST_IGNORE_SPACE
export LC_COLLATE=C
alias ag="ag --pager='less -EFRX'"
alias cim=vim
alias ldd="otool -L"
export EDITOR=vim
#export PAGER=vimpager
#export MANPAGER=vimmanpager
export PAGER='less -EFRX'
export MANPAGER='less -EFRX'

alias perldoc="PAGER=less perldoc"
[[ -x =when ]] && when
setopt vi
setopt inc_append_history
rg () { =rg --pretty $* |less -EFRX }
source /usr/local/share/zsh-navigation-tools/zsh-navigation-tools.plugin.zsh

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
aws_session() {
  # Clear out existing AWS_* environment variables
  for envar in $(env | grep AWS |cut -d= -f1);do
    unset $envar
  done
  BASE_ACCOUNT_PROFILE_NAME=base_account
  # list of roles we can assume
  production_admin_role=arn:aws:iam::643927032162:role/admin_role
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
