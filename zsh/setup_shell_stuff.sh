#!/usr/bin/env bash
#
set -x

echo $PATH
# OS Type specific stuff first
case $(uname) in
  Linux)
    if which brew &>/dev/null ; then
      echo "homebrew already installed"
    else
      echo "Installing homebrew"
      exit
      sh -c "$(curl -fsSL https://raw.githubusercontent.com/Linuxbrew/install/master/install.sh)"
      eval $(/home/linuxbrew/.linuxbrew/bin/brew shellenv)
    fi
    # zplug will not work correctly without GNU awk.
    sudo apt install gawk
    ;;
  Darwin)
    if which brew &>/dev/null ; then
      echo "homebrew already installed"
    else
      echo "Installing homebrew"
      /usr/bin/ruby -e "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/master/install)"
    fi
    ;;
  *)
    echo "Unknown OS type"
    exit
    ;;
esac

# Base stuff we need.
NEEDED_PACKAGES=(
  starship
  keychain
  hub
  direnv
  git
  bat
)
for pkg in ${NEEDED_PACKAGES[*]}; do
  which $pkg &>/dev/null || \
    brew install $pkg
done

curl -sL --proto-redir -all,https https://raw.githubusercontent.com/zplug/installer/master/installer.zsh | zsh
