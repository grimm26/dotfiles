# # Profiling setup
# # https://esham.io/2018/02/zsh-profiling
# zmodload zsh/datetime
# setopt PROMPT_SUBST
# PS4='+$EPOCHREALTIME %N:%i> '
#
# logfile=$(mktemp zshrc_profile.XXXXXXXX)
# echo "Logging to $logfile"
# exec 3>&2 2>$logfile
#
# setopt XTRACE

#zmodload zsh/zprof

BREW_PREFIX=/usr/local
if [ -s ${NREW_PREFIX}/opt/chruby/share/chruby/chruby.sh ]; then
  source ${BREW_PREFIX}/opt/chruby/share/chruby/chruby.sh
  #source ${BREW_PREFIX}/opt/chruby/share/chruby/auto.sh
  chruby ruby
elif [ -s /usr/local/share/chruby/chruby.sh ]; then
  . /usr/local/share/chruby/chruby.sh
  #. /usr/local/share/chruby/auto.sh
  chruby ruby
elif [ -s /usr/share/chruby/chruby.sh ]; then
  . /usr/share/chruby/chruby.sh
  #. /usr/share/chruby/auto.sh
  chruby ruby
fi

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

for mod in parameter complist deltochar mathfunc; do
  zmodload -i zsh/${mod} 2>/dev/null || print "Notice: no ${mod} available :("
done && builtin unset -v mod

# autoload zsh modules when they are referenced
zmodload -a zsh/stat zstat
zmodload -a zsh/zpty zpty
zmodload -ap zsh/mapfile mapfile

autoload -Uz zmv
autoload -Uz zed

setopt correct
#setopt correctall

## global aliases (for those who like them) ##

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
alias -g SU='| sort -u'
alias -g S='| sort'
alias -g T='|tail'

alias nout='netstat -nputw'
alias nin='netstat -ntl'

export GCAL="-q US_IL"
whence gcal &>/dev/null && alias cal=gcal

# Alias for yadm do it works more like git g alias
alias y=yadm
alias yp='yadm push'
alias yl='yadm pull'
alias yst='yadm status'
alias yca='yadm commit -a -v'
alias ya='yadm add'
alias yd='yadm diff'

# extra kubectl aliases
alias kcun='kubectl config unset current-context'

alias ks=kitty-session
# Use this to start up multiple windows in kitty and broadcast to them.
kpanes() {
  local now=$(date +'%s')
  local session_file="/tmp/kpanes-session.${now}"

  # generate session
  echo "layout grid" > $session_file
  for host in $@; do
    echo "launch --title $host kitty +kitten ssh $host" >> $session_file
  done
  echo "launch --allow-remote-control kitty +kitten broadcast" >> $session_file
  kitty --session $session_file
  rm $session_file
}
alias icat="kitty +kitten icat"
alias kssh="kitty +kitten ssh"

## use the vi navigation keys (hjkl) besides cursor keys in menu completion
bindkey -M menuselect 'h' vi-backward-char        # left
bindkey -M menuselect 'k' vi-up-line-or-history   # up
bindkey -M menuselect 'l' vi-forward-char         # right
bindkey -M menuselect 'j' vi-down-line-or-history # bottom

export DISABLE_AUTO_TITLE=true
if command -v nvim &>/dev/null; then
  alias vim=nvim
  alias vimdiff='nvim -d'
  export EDITOR=nvim
  export SYSTEMD_EDITOR=nvim
  alias -g V='| nvim -'
else
  alias -g V='| vim -'
  export EDITOR=vim
  export SYSTEMD_EDITOR=vim
fi
[ -d /usr/local/opt/openjdk/bin ] && export PATH="/usr/local/opt/openjdk/bin:$PATH"
[ -d /usr/local/opt/curl/bin ] && export PATH="/usr/local/opt/curl/bin:$PATH"
[ -f ~/.git_functions ] && source ~/.git_functions

load-tfswitch() {
  local tfswitchrc_path=".tfswitchrc"

  if [ -f "$tfswitchrc_path" ]; then
    tfsw
  fi
  if [[ -f ./atlantis.yaml ]]; then
    autoload is-at-least
    tf_version=$(grep terraform_version ./atlantis.yaml | awk '{print $2}' | tr -d 'v')
    if [[ -n $tf_version ]]; then
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
if [[ -d ${HOME}/.cargo/bin ]]; then
  path=("${HOME}/.cargo/bin" $path)
fi
path=("$MY_BIN" $path)
typeset -U path
export PATH

if (( $+commands[zoxide] )); then
  if [[ -s ~/.zoxide.init ]]; then
    source ~/.zoxide.init
  else
    eval "$(zoxide init --cmd cd zsh)"
  fi
fi
## End profiling
# unsetopt XTRACE
# exec 2>&3 3>&-
