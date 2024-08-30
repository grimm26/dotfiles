# # Profiling setup
# # https://esham.io/2018/02/zsh-profiling
# zmodload zsh/datetime
# setopt PROMPT_SUBST
# PS4='+$EPOCHREALTIME %N:%i> '
# logfile=$(mktemp zshrc_profile.XXXXXXXX)
# echo "Logging to $logfile"
# exec 3>&2 2>$logfile
# setopt XTRACE

#zmodload zsh/zprof
# Disable ohmyzsh auto update checks.
zstyle ':omz:update' mode disabled
# Start configuration added by Zim install {{{
#
# User configuration sourced by interactive shells
#

# -----------------
# Zsh configuration
# -----------------

#
# History
#

# Remove older command from the history if a duplicate is to be added.
setopt HIST_IGNORE_ALL_DUPS

#
# Input/output
#

# Set editor default keymap to emacs (`-e`) or vi (`-v`)
bindkey -v

# Prompt for spelling correction of commands.
setopt CORRECT

# Customize spelling correction prompt.
#SPROMPT='zsh: correct %F{red}%R%f to %F{green}%r%f [nyae]? '

# Remove path separator from WORDCHARS.
WORDCHARS=${WORDCHARS//[\/]}

# -----------------
# Zim configuration
# -----------------

# Use degit instead of git as the default tool to install and update modules.
#zstyle ':zim:zmodule' use 'degit'

# --------------------
# Module configuration
# --------------------

#
# git
#

# Set a custom prefix for the generated aliases. The default prefix is 'G'.
zstyle ':zim:git' aliases-prefix 'g'

#
# input
#

# Append `../` to your input for each `.` you type after an initial `..`
zstyle ':zim:input' double-dot-expand yes

# caSE mATteRs!
zstyle ':zim:*' case-sensitivity sensitive
#
# completion cache
#
zstyle ':completion::complete:*' cache-path ~/.cache/zsh/zcompcache

# in order to use #, ~ and ^ for filename generation grep word
# *~(*.gz|*.bz|*.bz2|*.zip|*.Z) -> searches for word not in compressed files
# don't forget to quote '^', '~' and '#'!
setopt extended_glob
#
# ssh
#
if [[ -n ~/.ssh/id_*(#qN) ]]; then
  my_ssh_keys=( ~/.ssh/id_*~*.pub(:t) )
  zstyle ':zim:ssh' ids $my_ssh_keys
fi
#
# termtitle
#

# Set a custom terminal title format using prompt expansion escape sequences.
# See http://zsh.sourceforge.net/Doc/Release/Prompt-Expansion.html#Simple-Prompt-Escapes
# If none is provided, the default '%n@%m: %~' is used.
#zstyle ':zim:termtitle' format '%1~'

#
# zsh-autosuggestions
#

# Disable automatic widget re-binding on each precmd. This can be set when
# zsh-users/zsh-autosuggestions is the last module in your ~/.zimrc.
ZSH_AUTOSUGGEST_MANUAL_REBIND=1

# Customize the style that the suggestions are shown with.
# See https://github.com/zsh-users/zsh-autosuggestions/blob/master/README.md#suggestion-highlight-style
#ZSH_AUTOSUGGEST_HIGHLIGHT_STYLE='fg=242'

#
# zsh-syntax-highlighting
#

# Set what highlighters will be used.
# See https://github.com/zsh-users/zsh-syntax-highlighting/blob/master/docs/highlighters.md
ZSH_HIGHLIGHT_HIGHLIGHTERS=(main brackets)

# Customize the main highlighter styles.
# See https://github.com/zsh-users/zsh-syntax-highlighting/blob/master/docs/highlighters/main.md#how-to-tweak-it
#typeset -A ZSH_HIGHLIGHT_STYLES
#ZSH_HIGHLIGHT_STYLES[comment]='fg=242'

# ------------------
# Initialize modules
# ------------------

ZIM_HOME=${ZDOTDIR:-${HOME}}/.zim
# Download zimfw plugin manager if missing.
if [[ ! -e ${ZIM_HOME}/zimfw.zsh ]]; then
  if (( ${+commands[curl]} )); then
    curl -fsSL --create-dirs -o ${ZIM_HOME}/zimfw.zsh \
        https://github.com/zimfw/zimfw/releases/latest/download/zimfw.zsh
  else
    mkdir -p ${ZIM_HOME} && wget -nv -O ${ZIM_HOME}/zimfw.zsh \
        https://github.com/zimfw/zimfw/releases/latest/download/zimfw.zsh
  fi
fi
# Install missing modules, and update ${ZIM_HOME}/init.zsh if missing or outdated.
if [[ ! ${ZIM_HOME}/init.zsh -nt ${ZDOTDIR:-${HOME}}/.zimrc ]]; then
  source ${ZIM_HOME}/zimfw.zsh init -q
fi
# Initialize modules.
source ${ZIM_HOME}/init.zsh

# ------------------------------
# Post-init module configuration
# ------------------------------

#
# zsh-history-substring-search
#

zmodload -F zsh/terminfo +p:terminfo
# Bind ^[[A/^[[B manually so up/down works both before and after zle-line-init
for key ('^[[A' '^P' ${terminfo[kcuu1]}) bindkey ${key} history-substring-search-up
for key ('^[[B' '^N' ${terminfo[kcud1]}) bindkey ${key} history-substring-search-down
for key ('k') bindkey -M vicmd ${key} history-substring-search-up
for key ('j') bindkey -M vicmd ${key} history-substring-search-down
unset key
# }}} End configuration added by Zim install
mkdir -p ~/.zsh-cache
if (( $+commands[zoxide] )); then
  zoxide_init=~/.zsh-cache/zoxide.init
  if [[ ! -e $zoxide_init || $zoxide_init -ot ${commands[zoxide]} ]]; then
    zoxide init --cmd cd zsh >| $zoxide_init
  fi
  source $zoxide_init
fi
if (( $+commands[tenv] )); then
  tenv_init=~/.zsh-cache/tenv.init
  if [[ ! -e $tenv_init || $tenv_init -ot ${commands[tenv]} ]]; then
    tenv completion zsh >| $tenv_init
  fi
  source $tenv_init
fi


# Enable Powerlevel10k instant prompt. Should stay close to the top of ~/.zshrc.
# Initialization code that may require console input (password prompts, [y/n]
# confirmations, etc.) must go above this block; everything else may go below.
(( ${+commands[direnv]} )) && emulate zsh -c "$(direnv export zsh)"
if [[ -r "${XDG_CACHE_HOME:-$HOME/.cache}/p10k-instant-prompt-${(%):-%n}.zsh" ]]; then
  source "${XDG_CACHE_HOME:-$HOME/.cache}/p10k-instant-prompt-${(%):-%n}.zsh"
fi

# Set the completion matcher-list how I like.
# try as-is, then try within words, then try toggled case, then try within words again (with toggled case)
zstyle ':completion:*' matcher-list '' '+r:|?=**' 'm:{a-zA-Z}={A-Za-z}' '+r:|?=**'

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
setopt hist_ignore_all_dups

# remove command lines from the history list when the first character on the
# line is a space
setopt hist_ignore_space
# if a command is issued that can't be executed as a normal command, and the
# command is the name of a directory, perform the cd command to that directory.
setopt auto_cd

# display PID when suspending processes as well
setopt longlistjobs

# report the status of backgrounds jobs immediately
setopt notify

# whenever a command completion is attempted, make sure the entire command path
# is hashed first.
setopt hash_list_all

# not just at the end
setopt complete_in_word
#
# Don't send SIGHUP to background processes when the shell exits.
setopt nohup

# make cd push the old directory onto the directory stack.
setopt auto_pushd

# avoid "beep"ing
setopt nobeep

# don't push the same dir twice.
setopt pushd_ignore_dups
setopt pushd_minus

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

whence gcal &>/dev/null && alias cal=gcal

# Alias for yadm do it works more like git g alias
alias y=yadm
alias yp='yadm push'
alias yl='yadm pull'
alias yst='yadm status'
alias yca='yadm commit -a -v'
alias ycm='yadm checkout main'
alias yco='yadm checkout'
alias ym='yadm merge'
alias yc='yadm commit -v'
alias ya='yadm add'
alias yd='yadm diff'
alias yrs='yadm restore'
alias yb='yadm branch'
alias ybs='yadm bootstrap'

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
load-tenv() {
  if [[ -f ./atlantis.yaml ]]; then
    autoload is-at-least
    local atlantis_tf_version=$(grep terraform_version ./atlantis.yaml | awk '{print $2}')
    local local_tf_version="x"
    [[ -s .terraform-version ]] && local_tf_version=$(cat .terraform-version)
    if [[ -n $atlantis_tf_version && $local_tf_version != ${atlantis_tf_version/v} ]]; then
      #export TFENV_TERRAFORM_VERSION=$tf_version
      unset TFENV_TERRAFORM_VERSION
      tenv tf use ${atlantis_tf_version/v} --working-dir
      if whence -p tgsw &>/dev/null; then
        if is-at-least 0.13.0 $tf_version; then
          export TG_VERSION=latest
        elif is-at-least 0.12.0 $tf_version; then
          export TG_VERSION=0.24.4
        elif is-at-least 0.11.0 $tf_version; then
          export TG_VERSION=0.18.7
        fi
      fi
    fi
  else
    unset TFENV_TERRAFORM_VERSION
    unset TG_VERSION
  fi
}
autoload -Uz add-zsh-hook
add-zsh-hook chpwd load-tenv
load-tenv

# Directory navigation
alias -- -='cd -'
alias 1='cd -1'
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
    dirs -v | head -n 10
  fi
}
compdef _dirs d

if [[ -d ${HOME}/.pyenv ]]; then
  export PYENV_ROOT="$HOME/.pyenv"
  export PATH="$PYENV_ROOT/bin:$PATH"
  [[ -d $PYENV_ROOT/bin ]] && export PATH="$PYENV_ROOT/bin:$PATH"
  eval "$(pyenv init -)"
fi

# # Need bashcompinit for python argcomplete
# if command -v register-python-argcomplete &>/dev/null; then
#   autoload -U bashcompinit
#   bashcompinit
#
#   if command -v ansible &>/dev/null; then
#     eval $(register-python-argcomplete ansible)
#     eval $(register-python-argcomplete ansible-config)
#     eval $(register-python-argcomplete ansible-console)
#     eval $(register-python-argcomplete ansible-doc)
#     eval $(register-python-argcomplete ansible-galaxy)
#     eval $(register-python-argcomplete ansible-inventory)
#     eval $(register-python-argcomplete ansible-playbook)
#     eval $(register-python-argcomplete ansible-pull)
#     eval $(register-python-argcomplete ansible-vault)
#   fi
# fi

## zlogin
capsoff() {
  /usr/bin/setxkbmap -option caps:none
}

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
#Git
alias gnb='git nb'
alias grtag='git rtag'
alias ghpr='gh pr create'
alias approve='gh pr review --approve'
alias merge='gh pr merge'
alias gbp='git prune-branches'
alias gdc='git diff --compact-summary'
# Override git pager
alias gdl='git -c core.pager=less diff'
alias gdp='git -c core.pager=$PAGER diff'

if [[ -d /usr/libexec/java_home ]]; then
  export JAVA_HOME=$(/usr/libexec/java_home)
fi

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
#whence -p keychain &>/dev/null &&  [[ -n  ~/.ssh/id_*sa(#qN) ]] && eval $(keychain --agents ssh --inherit $KEYCHAIN_INHERIT --eval ~/.ssh/id_*sa)

setopt HIST_IGNORE_SPACE
export LC_COLLATE=C
if [[ $OSTYPE == darwin* ]]; then
  alias ldd="otool -L"
  # Homebrew
  alias binfo='brew info'
  alias bs='brew search'
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
setopt inc_append_history
#rg () { =rg --pretty $* |less }

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

# List all occurrences of program in current PATH
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
# get_tg_latest_version () {
#   local retrieved_latest="null"
#   if [[ -s ~/.terragrunt_latest_version ]]; then
#     if [[ -n ~/.terragrunt_latest_version(#qN.mh+24) ]]; then
#       retrieved_latest=$(curl -sLS  https://api.github.com/repos/gruntwork-io/terragrunt/releases/latest |jq -r '.tag_name' |tr -d 'v')
#     fi
#   else
#     retrieved_latest=$(curl -sLS  https://api.github.com/repos/gruntwork-io/terragrunt/releases/latest |jq -r '.tag_name' |tr -d 'v')
#   fi
#
#   if [[ -v retrieved_latest && ${retrieved_latest} != "null" ]]; then
#     echo ${retrieved_latest} >| ~/.terragrunt_latest_version
#   fi
#   export TG_LATEST_VERSION=$(cat ~/.terragrunt_latest_version)
# }
get_tg_latest_version () {
  local retrieved_latest="null"
  if (( ${+commands[tenv]} )); then
    if [[ -f ~/.tenv_tg_check ]]; then
      if [[ -n ~/.tenv_tg_check(#qN.mh+24) ]]; then
        print "Checking for latest terragrunt version"
        tenv tg install latest
        touch ~/.tenv_tg_check
      fi
    else
      print "Checking for latest terragrunt version"
      tenv tg install latest
      touch ~/.tenv_tg_check
    fi
  fi
}
get_tg_latest_version

tf11 () {
  if (( ${+commands[tenv]} )); then
    tenv use terragrunt "~> 0.18.7"
    tenv use terraform "~> 0.11.0"
  else
    tgsw 0.18.7
    tfsw --latest-stable 0.11.0
  fi
}
tf12 () {
  if (( ${+commands[tenv]} )); then
    tenv use terragrunt "~> 0.24.4"
    tenv use terraform "~> 0.12.0"
  else
    tgsw 0.24.4
    tfsw --latest-stable 0.12.0
  fi
}
# terraform 0.13 and up should work with the latest terragrunt version - 2021-09-10
tf13 () {
  if (( ${+commands[tenv]} )); then
    tenv use terragrunt latest
    tenv use terraform "~> 0.13.0"
  else
    tgsw $TG_LATEST_VERSION
    tfsw --latest-stable 0.13.0
  fi
}
tf14 () {
  if (( ${+commands[tenv]} )); then
    tenv use terragrunt latest
    tenv use terraform "~> 0.14.0"
  else
    tgsw $TG_LATEST_VERSION
    tfsw --latest-stable 0.14.0
  fi
}
tf15 () {
  if (( ${+commands[tenv]} )); then
    tenv use terragrunt latest
    tenv use terraform "~> 0.15.0"
  else
    tgsw $TG_LATEST_VERSION
    tfsw --latest-stable 0.15.0
  fi
}
tf1x () {
  if (( ${+commands[tenv]} )); then
    tenv use terragrunt latest
    tenv use terraform "~> 1.0"
  else
    tgsw $TG_LATEST_VERSION
    tfsw --latest-stable 1.0
  fi
}
alias tgi="tg init -upgrade -reconfigure"
alias tgu="tf12 && terragrunt 0.12upgrade -yes;chompeof *.tf;uniq main.tf > main.tfu;mv main.tfu main.tf;sed -i tmp '/^\s*$/d' versions.tf;rm versions.tftmp"
alias tfu="tf12 && terraform 0.12upgrade -yes;chompeof *.tf"
tfup () {
  local tf_version=${1:-"1.7.5"}
  awk -v tfver="v${tf_version}" '$1=="terraform_version:"{$2=tfver} 1' ./atlantis.yaml > ./atlantis.$$ && mv ./atlantis.$$ ./atlantis.yaml
  audit-terraform-modules -r
  [[ -s locals.tf ]] && (( ${+commands[crush_tf_tags.pl]} )) && crush_tf_tags.pl
  for tfile in *.tf; do
    sed -Ei 's/( source.+)\.git\?/\1?/' $tfile
  done

  if (( ${+commands[tenv]} )); then
    tenv tf use $tf_version --working-dir
    tenv tg use latest
  else
    tfsw $tf_version
  fi
}
## START fzf
eval "$(fzf --zsh)"
if whence -p fdfind &>/dev/null; then
  export FD_BIN=fdfind
fi
if whence -p fd &>/dev/null; then
  export FD_BIN=fd
fi
export FZF_DEFAULT_COMMAND="$FD_BIN --type file --hidden --exclude .git --exclude .terraform"
export FZF_DEFAULT_OPTS='--height 40% --layout=reverse --border'
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
if (( ${+commands[bat]} )); then
  export FZF_CTRL_T_OPTS="--preview 'command bat --color=always --line-range :500 {}' ${FZF_CTRL_T_OPTS}"
fi

if (( ${+FZF_DEFAULT_COMMAND} )) export FZF_CTRL_T_COMMAND=${FZF_DEFAULT_COMMAND}
export FZF_CTRL_R_OPTS="--preview 'echo {}' --preview-window down:3:hidden:wrap --bind '?:toggle-preview'"

## END fzf

alias gcl &>/dev/null && unalias gcl
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
  cd ./"$(basename ${repo%%.git})"
}
# github atlantis apply PR
apply() {
  gh pr comment $1 --body "atlantis apply"
}
# github atlantis plan PR
plan() {
  gh pr comment $1 --body "atlantis plan"
}

command -v lsd &>/dev/null && alias ls=lsd
## END post antibody/zplug overrides

# Set background for suggestions from https://github.com/zsh-users/zsh-autosuggestions
export ZSH_AUTOSUGGEST_HIGHLIGHT_STYLE="fg=10,bg=#303030"
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

### zlogin

# Put "local" stuff in here, sensitive for work or specific to this machine
if [[ -r ~/.zshrc.local ]]; then
  source ~/.zshrc.local
fi
if (( $+commands[direnv] )); then
  eval "$(direnv hook zsh)"
fi
#
# To customize prompt, run `p10k configure` or edit ~/.p10k.zsh.
[[ ! -f ~/.p10k.zsh ]] || source ~/.p10k.zsh
# # End profiling
# unsetopt XTRACE
# exec 2>&3 3>&-

