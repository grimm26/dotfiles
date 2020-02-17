#!/usr/bin/env zsh
#
#set -x

echo $PATH
# OS Type specific stuff first
case $(uname) in
  Linux)
    if whence -p brew ; then
      echo "homebrew already installed"
    else
      echo "Installing homebrew"
      sh -c "$(curl -fsSL https://raw.githubusercontent.com/Linuxbrew/install/master/install.sh)"
      eval $(/home/linuxbrew/.linuxbrew/bin/brew shellenv)
    fi
    # zplug will not work correctly without GNU awk.
    sudo apt install gawk
    ;;
  Darwin)
    if whence -p brew ; then
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
for pkg in $NEEDED_PACKAGES; do
  whence $pkg &>/dev/null || \
    brew install $pkg
done
