#!/usr/bin/env bash
set -x

# First, I'm gonne be a dick and force you to live in this decade.
# We need at least bash 4, dude
[[ $(cut -d. -f1 <<< $BASH_VERSION) < 4 ]] && { echo >&2 "Sorry, this setup requires at least bash 4.  Srsly."; exit 1; }

# We need git
command -v git >/dev/null 2>&1 || { echo >&2 "git is required to clone vim plugins from github."; exit 1; }

command -v curl >/dev/null 2>&1 || { echo >&2 "curl is required to install dependencies."; exit 1; }

if command -v brew > /dev/null 2>&1; then
  # We have homebrew, just use it
  if [[ -e /usr/local/share/antigen/antigen.zsh ]]; then
    echo "Trying an upgrade of antigen with homebrew"
    brew upgrade antigen
  else
    echo "Installing antigen with homebrew"
    brew install antigen
  fi
else
  [[ -d /usr/local/share/antigen ]] || \
    mkdir -p /usr/local/share/antigen
  curl -L git.io/antigen > /usr/local/share/antigen/antigen.zsh
fi

if [[ ! -s ~/.antigenrc ]]; then
cat << EOF > ~/.antigenrc
antigen use oh-my-zsh
#
# Antigen Bundles
#
#
antigen bundle git
#antigen bundle tmuxinator
antigen bundle greymd/tmux-xpanes
antigen bundle zsh-users/zsh-syntax-highlighting
antigen bundle zsh-users/zsh-completions
# commenting zsh-navigation-tools cuz it is bullshit
#antigen bundle zsh-navigation-tools
antigen bundle command-not-found
antigen bundle vi-mode

# OS specific plugins
if [[ $(uname -s) == 'Darwin' ]]; then
    #antigen bundle brew
    #antigen bundle brew-cask
    antigen bundle gem
    antigen bundle osx
fi
antigen theme bureau

antigen apply
EOF

# Put into .zshrc
if [[ -r /usr/local/share/antigen/antigen.zsh ]]; then
  source /usr/local/share/antigen/antigen.zsh
  antigen init ~/.antigenrc
fi
