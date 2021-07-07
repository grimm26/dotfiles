#!/usr/bin/env zsh
#
#set -x

while getopts 'M' OPT; do
  case $OPT in
    M) setup_MINIMAL=1
  esac
done

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
    source /etc/os-release
    if [[ $ID != "ubuntu" ]]; then
      echo "I only wrote this for ubuntu."
      exit 1
    fi
    SCRIPT_HOME=$(readlink -f ${0%/*})
    # Versions
    GOLANG_VERSION="1.16.5"
    NODEJS_VERSION="16.4.2"
    cd /tmp
    # Latest git
    if ! grep -q git-core /etc/apt/sources.list.d/*.list; then
      sudo add-apt-repository -y -u ppa:git-core/ppa
    fi
    for pkg in fonts-firacode curl git libcurl4-openssl-dev keychain jq tmux python3 python3-pip source-highlight; do
      dpkg -s $pkg &>/dev/null || \
        sudo apt-get install -y $pkg
    done
    if [[ ! -v setup_MINIMAL ]]; then
      # Latest github cli
      if ! grep -q cli.github /etc/apt/sources.list; then
        sudo apt-key adv --keyserver keyserver.ubuntu.com --recv-key C99B11DEB97541F0
        sudo apt-add-repository --update https://cli.github.com/packages
        sudo apt install gh
      fi
      # golang
      if [[ "go version go${GOLANG_VERSION} linux/amd64" != $(go version 2>/dev/null) ]]; then
        echo "Downloading and installing go ${GOLANG_VERSION}"
        curl -sLSO https://dl.google.com/go/go${GOLANG_VERSION}.${kernel}-${machine}.tar.gz && \
          sudo rm -rf /usr/local/go 2>/dev/null && \
          sudo tar -C /usr/local -xzf go${GOLANG_VERSION}.${kernel}-${machine}.tar.gz
        rm go${GOLANG_VERSION}.${kernel}-${machine}.tar.gz
        export PATH=${PATH}:/usr/local/go/bin
      fi
      # nodejs
      if [[ "v${NODEJS_VERSION}" != $(node --version 2>/dev/null) ]]; then
        echo "Downloading and installing nodejs $NODEJS_VERSION"
        if [[ -L /usr/local/nodejs ]]; then
          OLD_NODEJS=$(readlink /usr/local/nodejs)
        fi
        curl -sLSO https://nodejs.org/dist/v${NODEJS_VERSION}/node-v${NODEJS_VERSION}-linux-x64.tar.xz && \
          sudo tar -xJvf node-v${NODEJS_VERSION}-linux-x64.tar.xz -C /usr/local/ &&
          sudo ln -sf /usr/local/node-v${NODEJS_VERSION}-linux-x64 /usr/local/nodejs
        [[ -v OLD_NODEJS ]] && sudo rm -rf $OLD_NODEJS
      fi
      # jsonlint
      /usr/local/nodejs/bin/npm install jsonlint -g
      # Build ugrep
      echo "ugrep"
      UGREP_NEED_BUILD=0
      cd ~/git
      if [[ -d ./ugrep ]]; then
        cd ugrep
        git remote update
        local_ugrep_ref=$(git rev-parse @)
        remote_ugrep_ref=$(git rev-parse @{u})
        if [[ $local_ugrep_ref != $remote_ugrep_ref ]]; then
          git pull
          UGREP_NEED_BUILD=1
        fi
      else
        git clone git://github.com/Genivia/ugrep
        UGREP_NEED_BUILD=1
        for pkg in libpcre2-dev zlib1g-dev libbz2-dev liblzma-dev liblz4-dev; do
          dpkg -s $pkg &>/dev/null || \
            sudo apt-get install -y $pkg
        done
        cd ugrep
      fi
      if [[ $UGREP_NEED_BUILD != 0 ]]; then
        ./build.sh --quiet
        cp bin/ugrep $home_bin
        [[ -L $home_bin/ug ]] || cp /bin/ug $home_bin
      fi
      cd /tmp
      # git-delta
      echo "git-delta"
      if [[ $VERSION_ID -ge 19.10 ]]; then
        gdelta_pkg="git-delta"
      else
        gdelta_pkg="git-delta-musl"
      fi
      curl -sLS $(curl -s https://api.github.com/repos/dandavison/delta/releases/latest|jq -r '.assets[].browser_download_url' | grep -E "${gdelta_pkg}_.*_amd64\.deb") -o /tmp/git-delta-latest_amd64.deb && \
        sudo dpkg --install --skip-same-version /tmp/git-delta-latest_amd64.deb
      # bat
      echo "bat"
      curl -sLS $(curl -s https://api.github.com/repos/sharkdp/bat/releases/latest |jq -r '.assets[].browser_download_url' | grep -E 'bat_.*_amd64.deb') -o /tmp/bat-latest.amd64.deb && \
        sudo dpkg --install --skip-same-version /tmp/bat-latest.amd64.deb
      echo "dive"
      curl -sLS $(curl -s https://api.github.com/repos/wagoodman/dive/releases/latest |jq -r '.assets[].browser_download_url' | grep -E '*_amd64.deb') -o /tmp/dive-latest.amd64.deb && \
        sudo dpkg --install --skip-same-version /tmp/dive-latest.amd64.deb
      # chruby
      echo "chruby"
      curl -sLS https://github.com/postmodern/chruby/archive/v0.3.9.tar.gz -o chruby-0.3.9.tar.gz && \
        tar -xzf chruby-0.3.9.tar.gz && \
        cd chruby-0.3.9/ && \
        sudo make install ; cd /tmp
      # ruby-install
      echo "ruby-install"
      curl -sLS https://github.com/postmodern/ruby-install/archive/v0.8.2.tar.gz -o ruby-install-0.8.2.tar.gz && \
        tar -xzf ruby-install-0.8.2.tar.gz && \
        cd ruby-install-0.8.2/ && \
        sudo make install ; cd /tmp
      # direnv
      echo "direnv"
      direnv_download_url=$(curl -sLS https://api.github.com/repos/direnv/direnv/releases/latest |jq -r '.assets[].browser_download_url' | grep "direnv.$kernel.$machine")
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
      cd /tmp
      curl -sLS "https://awscli.amazonaws.com/awscli-exe-linux-x86_64.zip" -o "awscliv2.zip" && \
        rm -rf aws && unzip -q awscliv2.zip && \
        if [[ -d /usr/local/aws-cli/v2 ]]; then
          sudo ./aws/install --update
          # Prune old installs
          for version in /usr/local/aws-cli/v2/?*.?*.?*; do
            [[ $(readlink /usr/local/aws-cli/v2/current) == "$version" ]] || sudo rm -rf $version
          done
        else
          sudo ./aws/install
        fi
      /usr/local/bin/aws --version
      # shfmt
      GO111MODULE=on go get mvdan.cc/sh/v3/cmd/shfmt
      # bat-extras
      rm -rf bat-extras
      git clone https://github.com/eth-p/bat-extras.git && \
        cd bat-extras && \
        ./build.sh --no-verify && \
        cp bin/* $home_bin
      cd /tmp
      echo "kubectl"
      KUBECTL_STABLE=$(curl -sLS https://storage.googleapis.com/kubernetes-release/release/stable.txt)
      MY_KUBECTL_VERSION=$(kubectl version --client --short 2>/dev/null | awk '{print $3}')
      if [[ $KUBECTL_STABLE != $MY_KUBECTL_VERSION ]]; then
        curl -sLS https://storage.googleapis.com/kubernetes-release/release/$(curl -sLS https://storage.googleapis.com/kubernetes-release/release/stable.txt)/bin/linux/amd64/kubectl -o ${home_bin}/kubectl && \
          chmod 755 ${home_bin}/kubectl
      fi
    fi
    ;;
  Darwin)
    if command -v brew &>/dev/null ; then
      echo "homebrew already installed"
    else
      echo "Installing homebrew"
      /usr/bin/ruby -e "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/master/install)"
    fi
    brew tap homebrew/cask-fonts
    brew list font-fira-code --cask &>/dev/null || brew install font-fira-code --cask
    # Base stuff we need.
    NEEDED_PACKAGES=(
      keychain
      kubernetes-cli
      coreutils
      go
      shfmt
      bat
      ugrep
      eth-p/software/bat-extras
      git
      chruby
      ruby-install
      direnv
      jq
      jsonlint
      gh
    )
    for pkg in ${NEEDED_PACKAGES[*]}; do
      brew list $pkg &>/dev/null || \
        brew install $pkg
    done
    SCRIPT_HOME=$(greadlink -f ${0%/*})
    # dive
    curl -sLS $(curl -s https://api.github.com/repos/wagoodman/dive/releases/latest |jq -r '.assets[].browser_download_url' | grep -i ${kernel}_${machine}) -o /tmp/dive-latest.tgz && \
      mkdir -p /tmp/dive.$$ && \
      tar -C /tmp/dive.$$ -xzf /tmp/dive-latest.tgz  && \
      rm /tmp/dive-latest.tgz && \
      cp /tmp/dive.$$/dive ${home_bin} && \
      chmod 755 ${home_bin}/dive; cd /tmp
    ;;
  *)
    echo "Unknown OS type"
    exit
    ;;
esac

if [[ ! -v setup_MINIMAL ]]; then
  # tfswitch
  echo "tfswitch"
  curl -sLS https://raw.githubusercontent.com/warrensbox/terraform-switcher/release/install.sh | bash -s - -b ${home_bin}

  # k9s
  echo "k9s"
  curl -sLS $(curl -sLS https://api.github.com/repos/derailed/k9s/releases/latest |jq -r '.assets[].browser_download_url' | grep -i ${kernel}_$(uname -m)) -o /tmp/k9s-latest.tgz && \
    mkdir -p /tmp/k9s.$$ && \
    tar -C /tmp/k9s.$$ -xzf /tmp/k9s-latest.tgz && \
    rm /tmp/k9s-latest.tgz && \
    cp /tmp/k9s.$$/k9s ${home_bin} && \
    chmod 755 ${home_bin}/k9s; cd /tmp

  # cheat
  echo "cheat"
  cd /tmp
  curl -sLS https://github.com/cheat/cheat/releases/latest/download/cheat-${kernel}-${machine}.gz -O && \
    gunzip -c /tmp/cheat-${kernel}-${machine}.gz > ${home_bin}/cheat
  chmod 755 ${home_bin}/cheat
  ##
  echo "pre-commit"
  if command -v pre-commit >/dev/null 2>&1;then
    pip3 install --upgrade --user pre-commit
  else
    pip3 install --user pre-commit
  fi
  cd /tmp
fi

# antibody
echo "antibody"
curl -sfLS git.io/antibody | bash -s - -b ${home_bin}
# starship (prompt)
starship --version
curl -fsSL https://starship.rs/install.sh | bash -s - -y -b ${home_bin}
starship --version

cd $SCRIPT_HOME
for z in .z* .config/*;do
  if ! diff -q $z ~/${z} &>/dev/null; then
    cp ~/${z} ~/${z}.prev
  fi
  cp $z ~/${z}
done
cd $INITIAL_PWD
