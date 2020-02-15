#!/usr/bin/env zsh
#
set -x

echo $PATH
if whence -p brew ; then
  echo $?
  echo "homebrew already installed"
else
  echo $?
  echo "Installing homebrew"
  exit
  sh -c "$(curl -fsSL https://raw.githubusercontent.com/Linuxbrew/install/master/install.sh)"
fi
