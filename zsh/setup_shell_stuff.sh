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
  fzf
  antibody
)
for pkg in ${NEEDED_PACKAGES[*]}; do
  which $pkg &>/dev/null || \
    brew install $pkg
done

for z in .z* .config/*;do
  if ! diff -q $z ~/${z} &>/dev/null; then
    cp ~/${z} ~/${z}.prev
  fi
  cp $z ~
done
