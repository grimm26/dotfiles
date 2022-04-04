# dotfiles
My dotfiles for various things. This is only tested working on OSX and Ubuntu Focal (20.04).

- zsh
    - dotfiles and plugins loaded with antibody
    - script to install stuff and dotfiles.
- git
    - custom scripts and gitconfig
- tmux
    - tmux.conf with tpm plugins
- vim
    - neovim is the primary editor, but should work for vim8, too
    - vimrc and neovim init with vim-plug setup.
    - My vimrc is fairly commented and hopefully understandable.  There is commented out stuff from old settings that I don't use anymore or that are covered by plugins that I now use.
    - script to install/update plugins

# How to install
I use [GNU stow](https://www.gnu.org/software/stow/) with some scripting around it to manage dotfiles from this repo.
## First time
When running this the first time, you may have files in place of the ones that this package comes with. In that case, you should run `clear_dotfiles` first. This will move your files out of the way of what will be linked into place.
## Set it all up
Run these scripts:
- `install_packages`
    - Installs packages that are required by the dotfiles here and/or are just packages that I want to have.
- `setup_vim_plugins`
    - Moves old vim pack dirs out of the way.
- `setup_neovim`
    - install ruby and python shim packages.
- `link_dotfiles`
    - This uses stow to link the dotfiles into place.
