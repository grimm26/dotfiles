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

for file in zshenv zlogin zshrc antigenrc; do
  if [[ -s ~/.${file} ]]; then
    echo "Saving ~/.${file} as ~/.${file}.save"
    mv ~/.${file} ~/.${file}.save
  fi
  cp ./${file} ~/.${file}
done
