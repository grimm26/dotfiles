#zmodload zsh/zprof

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
[ -f ~/.git_functions ] && source ~/.git_functions

load-tfswitch() {
  local tfswitchrc_path=".tfswitchrc"

  if [ -f "$tfswitchrc_path" ]; then
    tfsw
  fi
  if [[ -f ./atlantis.yaml ]]; then
    autoload is-at-least
    tf_version=$(grep terraform_version ./atlantis.yaml | awk '{print $2}' | tr -d 'v')
    if [[ ! -z "$tf_version" ]]; then
      tfsw $tf_version
      if whence -p tgsw &>/dev/null; then
        if is-at-least 0.13.0 $tf_version; then
          tgsw $TG_LATEST_VERSION
        elif is-at-least 0.12.0 $tf_version; then
          tgsw 0.24.4
        elif is-at-least 0.11.0 $tf_version; then
          tgsw 0.18.7
        fi
      fi
    fi
  fi
}
autoload -Uz add-zsh-hook
add-zsh-hook chpwd load-tfswitch
load-tfswitch
