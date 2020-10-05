#!/usr/bin/env bash

# First, I'm gonne be a dick and force you to live in this decade.
# We need at least bash 4, dude
[[ $(cut -d. -f1 <<< $BASH_VERSION) < 4 ]] && { echo >&2 "Sorry, this setup requires at least bash 4.  Srsly."; exit 1; }

# We need git
command -v git >/dev/null 2>&1 || { echo >&2 "git is required to clone vim plugins from github."; exit 1; }

VIM_MAJOR_VERSION=$(vim --version | head -1 | cut -d ' ' -f 5 | cut -d. -f1)
[[ $VIM_MAJOR_VERSION < 8 ]] && { echo >&2 "Sorry, this setup requires vim 8.  Why your vim so old?"; exit 1; }

# OK, let's get to it.
BASE_CWD=$(pwd)
# Make the dirs
mkdir -pv ~/.vim/pack/plugins/opt
mkdir -pv ~/.vim/pack/plugins/start
mkdir -pv ~/.vim/pack/themes/opt

# Clone or update solarized8 theme
if [[ -d ~/.vim/pack/themes/opt/solarized8 ]]; then
  echo "Updating solarized8 theme via git pull"
  cd ~/.vim/pack/themes/opt/solarized8 && git pull --no-rebase
  cd $BASE_CWD
  echo ""
else
  echo "Installing solarized8 theme"
  git clone https://github.com/lifepillar/vim-solarized8 ~/.vim/pack/themes/opt/solarized8
  echo ""
fi

# Here is the list of plugins
declare -A plugins
plugins['vim-commentary']='git://github.com/tpope/vim-commentary.git'
plugins['nerdtree']='git://github.com/preservim/nerdtree.git'
plugins['vim-surround']='git://github.com/tpope/vim-surround.git'
plugins['syntastic']='git://github.com/vim-syntastic/syntastic.git'
plugins['vim-airline']='git://github.com/vim-airline/vim-airline'
plugins['vim-airline-themes']='git://github.com/vim-airline/vim-airline-themes.git'
plugins['vim-colors-solarized']='git://github.com/altercation/vim-colors-solarized.git'
plugins['vim-dirdiff']='git://github.com/will133/vim-dirdiff.git'
plugins['vim-endwise']='git://github.com/tpope/vim-endwise.git'
plugins['vim-fugitive']='git://github.com/tpope/vim-fugitive.git'
plugins['vim-go']='git://github.com/fatih/vim-go.git'
plugins['vim-json']='git://github.com/elzr/vim-json.git'
plugins['vim-lastplace']='git://github.com/dietsche/vim-lastplace.git'
plugins['vim-terraform']='git://github.com/hashivim/vim-terraform.git'
plugins['vim-tmux']='git://github.com/tmux-plugins/vim-tmux.git'
plugins['vim-gitgutter']='git://github.com/airblade/vim-gitgutter.git'
plugins['vim-terminus']='git://github.com/wincent/terminus.git'

clone_or_update_plugin(){
  name=$1
  origin_url=$2
  if [[ -d ~/.vim/pack/plugins/start/${name} ]]; then
    echo "Updating $name plugin via git pull"
    cd ~/.vim/pack/plugins/start/${name}
    current_origin_url=$(git config --get remote.origin.url)
    if [[ $current_origin_url != $origin_url ]]; then
      # github repo URL must have changed along the way.
      echo "Updating origin of $name from $current_origin_url to $origin_url"
      git remote set-url origin $origin_url
    fi
    git pull --no-rebase
    # Update helptags (docs)
    [[ -d ./doc ]] && vim -u NONE -c "helptags doc" -c q
    cd $BASE_CWD
    echo ""
  else
    echo "Installing $name plugin"
    git clone $origin_url ~/.vim/pack/plugins/start/${name}
    # Update helptags (docs)
    [[ -d ~/.vim/pack/plugins/start/${name}/doc ]] && vim -u NONE -c "helptags ~/.vim/pack/plugins/start/${name}/doc" -c q
    echo ""
  fi
}

# Clone or update the plugins
for plugin in "${!plugins[@]}"; do
  clone_or_update_plugin $plugin ${plugins[$plugin]}
done
