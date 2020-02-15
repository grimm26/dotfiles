#!/usr/bin/env zsh
#
## This assumes Ubuntu.  Should be smarter.
#set -x

echo $PATH
if whence -p brew ; then
  echo $?
  echo "homebrew already installed"
else
  echo $?
  echo "Installing homebrew"
  sh -c "$(curl -fsSL https://raw.githubusercontent.com/Linuxbrew/install/master/install.sh)"
  eval $(/home/linuxbrew/.linuxbrew/bin/brew shellenv)
fi
brew install starship
brew install keychain
brew install hub
# zplug will not work correctly without GNU awk.
sudo apt install gawk
