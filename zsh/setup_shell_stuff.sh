#!/usr/bin/env zsh
#
#set -x

kernel=$(uname -s | tr "[:upper:]" "[:lower:]")
case "$(uname -m)" in
  x86_64)
    machine=amd64
    ;;
  *)
    die "Machine $(uname -m) not supported by the installer. Sorry\n"
    ;;
esac

# Make ~/.local/bin our official user bin dir
home_bin=~/.local/bin
if [[ ! -d $home_bin ]]; then
  mkdir -p $home_bin
fi
if [[ -d ${HOME}/bin && ! -h ${HOME}/bin ]]; then
  cp -n ${HOME}/bin/* ${HOME}/.local/bin
  mv ${HOME}/bin ${HOME}/bin-old
  ln -s $home_bin ${HOME}/bin
fi

INITIAL_PWD=$PWD
# OS Type specific stuff first
case $(uname) in
  Linux)
    SCRIPT_HOME=$(readlink -f ${0%/*})
    cd /tmp
    # Latest git
    if ! grep -q git-core /etc/apt/sources.list.d/*.list; then
      sudo add-apt-repository -y -u ppa:git-core/ppa
    fi
    for pkg in fonts-firacode curl git libcurl4-openssl-dev keychain jq tmux python3 python3-pip source-highlight; do
      dpkg -s $pkg &>/dev/null || \
        sudo apt-get install -y $pkg
    done
    # golang 1.14.3
    if [[ "go version go1.14.3 linux/amd64" != $(go version 2>/dev/null) ]]; then
      echo "Downloading and installing go 1.14.3"
      curl -sO https://dl.google.com/go/go1.14.3.${kernel}-${machine}.tar.gz && \
        sudo rm -rf /usr/local/go 2>/dev/null && \
        sudo tar -C /usr/local -xzf go1.14.3.${kernel}-${machine}.tar.gz
      rm go1.14.3.${kernel}-${machine}.tar.gz
      export PATH=${PATH}:/usr/local/go/bin
    fi
    echo "pre-commit"
    command -v pre-commit >/dev/null 2>&1 || pip3 install pre-commit
    cd /tmp
    # bat
    echo "bat"
    curl -sL $(curl -s https://api.github.com/repos/sharkdp/bat/releases/latest |jq -r '.assets[].browser_download_url' | grep -E 'bat_.*_amd64.deb')   -o /tmp/bat-latest.amd64.deb && \
      sudo dpkg --install --skip-same-version /tmp/bat-latest.amd64.deb
    # ripgrep
    echo "ripgrep"
    curl -sL $(curl -s https://api.github.com/repos/BurntSushi/ripgrep/releases/latest |jq -r '.assets[].browser_download_url' | grep amd64.deb) -o /tmp/ripgrep-latest.amd64.deb && \
      sudo dpkg --install --skip-same-version /tmp/ripgrep-latest.amd64.deb
    # hub
    echo "hub"
    curl -sL $(curl -s https://api.github.com/repos/github/hub/releases/latest |jq -r '.assets[].browser_download_url' | grep ${kernel}-${machine}) -o /tmp/hub-${kernel}-${machine}-latest.tgz && \
      tar xzf /tmp/hub-${kernel}-${machine}-latest.tgz && \
      rm /tmp/hub-${kernel}-${machine}-latest.tgz && \
      cd hub-${kernel}-${machine}-* && \
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
    direnv_download_url=$(curl -s https://api.github.com/repos/direnv/direnv/releases/latest |jq -r '.assets[].browser_download_url' | grep "direnv.$kernel.$machine")
    if whence direnv &> /dev/null; then
      direnv_latest_version=$(cut -d/ -f8 <<< $direnv_download_url)
      direnv_installed_version=$(direnv --version)
      if [[ "$direnv_latest_version" != "v${direnv_installed_version}" ]]; then
        curl -sL $direnv_download_url -o $home_bin/direnv && chmod 755 $home_bin/direnv ; cd /tmp
      fi
    else
      curl -sL $direnv_download_url -o $home_bin/direnv && chmod 755 $home_bin/direnv ; cd /tmp
    fi
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
      coreutils
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
      jq
    )
    for pkg in ${NEEDED_PACKAGES[*]}; do
      brew list $pkg &>/dev/null || \
        brew install $pkg
    done
    SCRIPT_HOME=$(greadlink -f ${0%/*})
    ;;
  *)
    echo "Unknown OS type"
    exit
    ;;
esac


# k9s
echo "k9s"
curl -sL $(curl -s https://api.github.com/repos/derailed/k9s/releases/latest |jq -r '.assets[].browser_download_url' | grep -i ${kernel}_$(uname -m)) -o /tmp/k9s-latest.tgz && \
  mkdir -p /tmp/k9s.$$ && \
  tar -C /tmp/k9s.$$ -xzf /tmp/k9s-latest.tgz && \
  rm /tmp/k9s-latest.tgz && \
  cp /tmp/k9s.$$/k9s ${home_bin} && \
  chmod 755 ${home_bin}/k9s; cd /tmp

# cheat
echo "cheat"
cd /tmp
curl -sL https://github.com/cheat/cheat/releases/latest/download/cheat-${kernel}-${machine}.gz -O && \
  gunzip -c /tmp/cheat-${kernel}-${machine}.gz > ${home_bin}/cheat
chmod 755 ~/bin/cheat

curl -sfL git.io/antibody | sudo sh -s - -b /usr/local/bin
curl -fsSL https://starship.rs/install.sh | sudo bash -s - -y
sudo chown root: /usr/local/bin/starship

cd $SCRIPT_HOME
for z in .z* .config/*;do
  if ! diff -q $z ~/${z} &>/dev/null; then
    cp ~/${z} ~/${z}.prev
  fi
  cp $z ~
done
cd $INITIAL_PWD
