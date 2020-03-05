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
export PAGER="less -EFRX"
export MANPAGER='less -EFRX'
alias chompeof="perl -pi -e 'chomp if eof && /^$/'"

alias perldoc="PAGER=less perldoc"
whence when &>/dev/null && when
setopt vi
setopt inc_append_history
rg () { =rg --pretty $* |less -EFRX }
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
[ -r ~/.zplugrc ] && echo "Loading zsh plugins" && source ~/.zplugrc && echo "Done."
chruby ruby

whence starship &>/dev/null && \
  eval "$(starship init zsh)"
whence direnv &>/dev/null && \
  eval "$(direnv hook zsh)"
