#zmodload zsh/zprof
[ -x /home/linuxbrew/.linuxbrew/bin/brew ] && eval $(/home/linuxbrew/.linuxbrew/bin/brew shellenv)

# if [ -s $(brew --prefix)/opt/chruby/share/chruby/chruby.sh ]; then
#   source $(brew --prefix)/opt/chruby/share/chruby/chruby.sh
#   source $(brew --prefix)/opt/chruby/share/chruby/auto.sh
#   chruby ruby
# elif [ -s /usr/local/share/chruby/chruby.sh ]; then
#   . /usr/local/share/chruby/chruby.sh
#   . /usr/local/share/chruby/auto.sh
#   chruby ruby
# elif [ -s /usr/share/chruby/chruby.sh ]; then
#   . /usr/share/chruby/chruby.sh
#   . /usr/share/chruby/auto.sh
#   chruby ruby
# elif [ -s "$HOME/.rvm/scripts/rvm" ]; then
#   . "$HOME/.rvm/scripts/rvm" # Load RVM into a shell session *as a function*
# fi

# append history list to the history file; this is the default but we make sure
# because it's required for share_history.
setopt append_history

# import new commands from the history file also in other zsh-session
setopt share_history

# save each command's beginning timestamp and the duration to the history file
setopt extended_history

# If a new command line being added to the history list duplicates an older
# one, the older command is removed from the list
setopt histignorealldups

# remove command lines from the history list when the first character on the
# line is a space
setopt histignorespace
# if a command is issued that can't be executed as a normal command, and the
# command is the name of a directory, perform the cd command to that directory.
setopt auto_cd

# in order to use #, ~ and ^ for filename generation grep word
# *~(*.gz|*.bz|*.bz2|*.zip|*.Z) -> searches for word not in compressed files
# don't forget to quote '^', '~' and '#'!
setopt extended_glob

# display PID when suspending processes as well
setopt longlistjobs

export GOPATH=~/go
export GOBIN=$GOPATH/bin
path+=(${GOBIN})
path=('/usr/local/bin' '/usr/local/sbin' $path)
if [[ $OSTYPE == darwin* && -d ${HOME}/Library/Python/3.7/bin ]]; then
  path+=("${HOME}/Library/Python/3.7/bin")
fi
if [[ -d /usr/local/go/bin ]]; then
  path+=('/usr/local/go/bin')
fi
path=("$HOME/.local/bin" $path)
typeset -U path
export PATH
# report the status of backgrounds jobs immediately
setopt notify

# whenever a command completion is attempted, make sure the entire command path
# is hashed first.
setopt hash_list_all

# not just at the end
setopt completeinword
#
# Don't send SIGHUP to background processes when the shell exits.
setopt nohup

# make cd push the old directory onto the directory stack.
setopt auto_pushd

# avoid "beep"ing
setopt nobeep

# don't push the same dir twice.
setopt pushd_ignore_dups
setopt pushdminus

# * shouldn't match dotfiles. ever.
setopt noglobdots

# use zsh style word splitting
setopt noshwordsplit

# don't error out when unset parameters are used
setopt unset

for mod in parameter complist deltochar mathfunc ; do
    zmodload -i zsh/${mod} 2>/dev/null || print "Notice: no ${mod} available :("
done && builtin unset -v mod

# autoload zsh modules when they are referenced
zmodload -a  zsh/stat    zstat
zmodload -a  zsh/zpty    zpty
zmodload -ap zsh/mapfile mapfile

autoload -Uz zmv
autoload -Uz zed

setopt correct
#setopt correctall

# ignore ~/.ssh/known_hosts entries
alias insecssh='ssh -o "StrictHostKeyChecking=no" -o "UserKnownHostsFile=/dev/null" -o "PreferredAuthentications=password,keyboard-interactive"'

## global aliases (for those who like them) ##

#alias -g '...'='../..'
#alias -g '....'='../../..'
#alias -g BG='& exit'
alias -g C='|wc -l'
alias -g G='|grep'
alias -g H='|head'
#alias -g Hl=' --help |& less -r'
#alias -g K='|keep'
alias -g L='|less -EFRX'
#alias -g LL='|& less -r'
#alias -g M='|most'
alias -g N='&>/dev/null'
#alias -g R='| tr A-z N-za-m'
alias -g SL='| sort | less'
alias -g S='| sort'
alias -g T='|tail'
#alias -g V='| vim -'
alias nout='netstat -nputw'
alias nin='netstat -ntl'

## use the vi navigation keys (hjkl) besides cursor keys in menu completion
bindkey -M menuselect 'h' vi-backward-char        # left
bindkey -M menuselect 'k' vi-up-line-or-history   # up
bindkey -M menuselect 'l' vi-forward-char         # right
bindkey -M menuselect 'j' vi-down-line-or-history # bottom

export DISABLE_AUTO_TITLE=true
#if [ -x =nvim ]; then
  #alias vim=nvim
#fi
[ -d /usr/local/opt/openjdk/bin ] && export PATH="/usr/local/opt/openjdk/bin:$PATH"

is_in_local_git() {
    local branch=${1}
    local existed_in_local=$(git branch --list ${branch})

    if [[ "${existed_in_local}x" != "x" ]]; then
        return 0
    else
        return 1
    fi
}
is_in_remote_git() {
    local remote=${1}
    local branch=${2}
    local existed_in_remote=$(git ls-remote --heads ${remote} ${branch})

    if [[ "${existed_in_remote}x" != "x" ]]; then
        return 0
    else
        return 1
    fi
}
get_default_branch()
{
  command -v jq &>/dev/null || (echo "You need to install jq" && return 1)
  if [ "${GITHUB_API_ENDPOINT}x" = "x" ]; then
    GITHUB_API_ENDPOINT="https://api.github.com"
  fi
  GIT_SSH_REGEX="^git@"
  GIT_RO_REGEX="^git:"
  HTTPS_REGEX="^https:"
  GITHUB_API_ENDPOINT=$(sed 's!/$!!' <<< $GITHUB_API_ENDPOINT)
  FULL_ORIGIN=$(git remote get-url origin)
  if [[ $FULL_ORIGIN =~ $GIT_SSH_REGEX ]]; then # git+ssh URL
    REPOSITORY=$(echo $FULL_ORIGIN |cut -d: -f2 |sed 's/\.git//')
    GITHUB_SITE=$(echo $FULL_ORIGIN | cut -d: -f1 |cut -d@ -f2)
  elif [[ $FULL_ORIGIN =~ $GIT_RO_REGEX ]]; then # git:// URL
    REPOSITORY=$(echo $FULL_ORIGIN |cut -d/ -f4,5 |sed 's/\.git//')
    GITHUB_SITE=$(echo $FULL_ORIGIN | cut -d: -f3)
  elif [[ $FULL_ORIGIN =~ $HTTPS_REGEX ]]; then # https:// URL
    REPOSITORY=$(echo $FULL_ORIGIN |cut -d/ -f4,5 |sed 's/\.git//')
    GITHUB_SITE=$(echo $FULL_ORIGIN | cut -d: -f3)
  else
    return 1
  fi
  DEFAULT_BRANCH=$(curl -s $([[ -n $GITHUB_TOKEN ]] && echo -n "-H \"Authorization: token $GITHUB_TOKEN\"") $GITHUB_API_ENDPOINT/repos/$REPOSITORY |jq -r '.default_branch')
}
get_repo_owner()
{
  GIT_SSH_REGEX="^git@"
  GIT_RO_REGEX="^git:"
  HTTPS_REGEX="^https:"
  GITHUB_API_ENDPOINT=$(sed 's!/$!!' <<< $GITHUB_API_ENDPOINT)
  FULL_ORIGIN=$(git remote get-url origin)
  if [[ $FULL_ORIGIN =~ $GIT_SSH_REGEX ]]; then # git+ssh URL
    REPOSITORY=$(echo $FULL_ORIGIN |cut -d: -f2 |sed 's/\.git//')
  elif [[ $FULL_ORIGIN =~ $GIT_RO_REGEX ]]; then # git:// URL
    REPOSITORY=$(echo $FULL_ORIGIN |cut -d/ -f4,5 |sed 's/\.git//')
  elif [[ $FULL_ORIGIN =~ $HTTPS_REGEX ]]; then # https:// URL
    REPOSITORY=$(echo $FULL_ORIGIN |cut -d/ -f4,5 |sed 's/\.git//')
  else
    return 1
  fi

  IFS='/' read GH_OWNER GH_REPO <<< "$REPOSITORY"
}
