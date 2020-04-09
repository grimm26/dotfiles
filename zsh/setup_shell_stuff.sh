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
    sudo apt install -y gawk
    # Need these fints for starship
    sudo apt install -y fonts-firacode
    sudo apt install -y curl libcurl4-openssl-dev keychain bat jq
    curl -L https://github.com/cheat/cheat/releases/latest/download/cheat-linux-amd64.gz -o /tmp/cheat-linux-amd64.gz && \
      gunzip /tmp/cheat-linux-amd64.gz && mv /tmp/cheat-linux-amd64 ~/bin/cheat
    curl -sL $(curl -s https://api.github.com/repos/BurntSushi/ripgrep/releases/latest |jq -r '.assets[].browser_download_url' | grep amd64.deb) -o /tmp/ripgrep-latest.amd64.deb && \
      sudo dpkg -i /tmp/ripgrep-latest.amd64.deb
    ;;
  Darwin)
    if which brew &>/dev/null ; then
      echo "homebrew already installed"
    else
      echo "Installing homebrew"
      /usr/bin/ruby -e "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/master/install)"
    fi
    brew tap homebrew/cask-fonts
    brew cask install font-fira-code
    brew install keychain bat ripgrep
    curl -L https://github.com/cheat/cheat/releases/latest/download/cheat-darwin-amd64.gz -o /tmp/cheat-darwin-amd64.gz && \
      gunzip /tmp/cheat-darwin-amd64.gz && mv /tmp/cheat-darwin-amd64 ~/bin/cheat
    ;;
  *)
    echo "Unknown OS type"
    exit
    ;;
esac

# Base stuff we need.
NEEDED_PACKAGES=(
  hub
  direnv
  git
  chruby
  ruby-install
)
for pkg in ${NEEDED_PACKAGES[*]}; do
  which $pkg &>/dev/null || \
    brew install $pkg
done

curl -sfL git.io/antibody | sudo sh -s - -b /usr/local/bin
curl -fsSL https://starship.rs/install.sh | sudo bash -s - -y
sudo chown root: /usr/local/bin/starship

for z in .z* .config/*;do
  if ! diff -q $z ~/${z} &>/dev/null; then
    cp ~/${z} ~/${z}.prev
  fi
  cp $z ~
done
