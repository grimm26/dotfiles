#!/usr/bin/env bash
#
#set -x

# Make ~/.local/bin our official user bin dir
if [[ ! -d ${HOME}/.local/bin ]]; then
  mkdir -p ~/.local/bin
fi
if [[ ! -h ${HOME}/bin ]]; then
  cp -n ${HOME}/bin/* ${HOME}/.local/bin
  mv ${HOME}/bin ${HOME}/bin-old
  ln -s ${HOME}/.local/bin ${HOME}/bin
fi

SCRIPT_HOME=$PWD
# OS Type specific stuff first
case $(uname) in
  Linux)
    # Need these fonts for starship
    for pkg in fonts-firacode curl libcurl4-openssl-dev keychain bat jq tmux python3 python3-pip source-highlight golang-go; do
      dpkg -s $pkg &>/dev/null || \
        sudo apt-get install -y $pkg
    done
    echo "pre-commit"
    command -v pre-commit >/dev/null 2>&1 || pip3 install pre-commit
    cd /tmp
    # cheat
    echo "cheat"
    curl -sL https://github.com/cheat/cheat/releases/latest/download/cheat-linux-amd64.gz -O && \
      gunzip /tmp/cheat-linux-amd64.gz && mv /tmp/cheat-linux-amd64 ~/bin/cheat
    # ripgrep
    echo "ripgrep"
    curl -sL $(curl -s https://api.github.com/repos/BurntSushi/ripgrep/releases/latest |jq -r '.assets[].browser_download_url' | grep amd64.deb) -o /tmp/ripgrep-latest.amd64.deb && \
      sudo dpkg --install --skip-same-version /tmp/ripgrep-latest.amd64.deb
    # hub
    echo "hub"
    curl -sL $(curl -s https://api.github.com/repos/github/hub/releases/latest |jq -r '.assets[].browser_download_url' | grep linux-amd64) -o /tmp/hub-linux-amd64-latest.tgz && \
      tar xzf /tmp/hub-linux-amd64-latest.tgz && \
      rm /tmp/hub-linux-amd64-latest.tgz && \
      cd hub-linux-amd64-* && \
      sudo ./install ;cd /tmp
    # chruby
    echo "chruby"
    curl -sL https://github.com/postmodern/chruby/archive/v0.3.9.tar.gz -o chruby-0.3.9.tar.gz && \
      tar -xzf chruby-0.3.9.tar.gz && \
      cd chruby-0.3.9/ && \
      sudo make install ; cd /tmp
    # ruby-install
    echo "ruby-install"
    curl -sL https://github.com/postmodern/ruby-install/archive/v0.7.0.tar.gz -o ruby-install-0.7.0.tar.gz && \
      tar -xzf ruby-install-0.7.0.tar.gz && \
      cd ruby-install-0.7.0/ && \
      sudo make install ; cd /tmp
    # direnv
    echo "direnv"
    curl -sfL https://direnv.net/install.sh | bash 2>/dev/null
    # awscli
    echo "awscli"
    curl "https://awscli.amazonaws.com/awscli-exe-linux-x86_64.zip" -o "awscliv2.zip" && \
      [[ -d aws ]] && rm -rf aws && unzip -q awscliv2.zip && \
      if [[ -d /usr/local/aws-cli/v2 ]]; then
        sudo ./aws/install --update
      else
        sudo ./aws/install
      fi
      cd /tmp
    # shfmt
    GO111MODULE=on go get mvdan.cc/sh/v3/cmd/shfmt
    # bat-extras
    rm -rf bat-extras
    git clone https://github.com/eth-p/bat-extras.git && \
      cd bat-extras && \
      ./build.sh --no-verify && \
      cp bin/* ~/.local/bin
    cd /tmp
    ;;
  Darwin)
    if command -v brew &>/dev/null ; then
      echo "homebrew already installed"
    else
      echo "Installing homebrew"
      /usr/bin/ruby -e "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/master/install)"
    fi
    brew tap homebrew/cask-fonts
    brew cask list font-fira-code &>/dev/null || brew cask install font-fira-code
    # Base stuff we need.
    NEEDED_PACKAGES=(
      keychain
      go
      shfmt
      bat
      ripgrep
      eth-p/software/bat-extras
      hub
      git
      chruby
      ruby-install
      direnv
    )
    for pkg in ${NEEDED_PACKAGES[*]}; do
      brew list $pkg &>/dev/null || \
        brew install $pkg
    done
    curl -L https://github.com/cheat/cheat/releases/latest/download/cheat-darwin-amd64.gz -o /tmp/cheat-darwin-amd64.gz && \
      gunzip /tmp/cheat-darwin-amd64.gz && mv /tmp/cheat-darwin-amd64 ~/bin/cheat
    ;;
  *)
    echo "Unknown OS type"
    exit
    ;;
esac


cd $SCRIPT_HOME
chmod 755 ~/bin/cheat

curl -sfL git.io/antibody | sudo sh -s - -b /usr/local/bin
curl -fsSL https://starship.rs/install.sh | sudo bash -s - -y
sudo chown root: /usr/local/bin/starship

for z in .z* .config/*;do
  if ! diff -q $z ~/${z} &>/dev/null; then
    cp ~/${z} ~/${z}.prev
  fi
  cp $z ~
done
