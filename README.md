# Homedir management using yadm
This is for managing my dotfiles (and more) with [yadm](https://yadm.io).
This is only tested working on MacOS Monterrey (12.3) and Ubuntu Jammy (22.04). It should also work on Ubuntu Focal and MacOS 11.

The main tools that I use this to manage:
- [zsh](https://zsh.sourceforge.io/)
    - dotfiles and plugins loaded with antibody
    - script to install stuff and dotfiles.
- [git](https://git-scm.com/)
    - custom scripts and gitconfig
- [kitty](https://sw.kovidgoyal.net/kitty/)
    - A modern, multi platform terminal emulator
- [Neovim](https://neovim.io/)
    - neovim is the primary editor, but should work for vim8, too. I am only developing the neovim configs now.
    - vimrc and neovim init with plugins.
    - My vimrc is fairly commented and hopefully understandable.  There is commented out stuff from old settings that I don't use anymore or that are covered by plugins that I now use.
    - optional script to install/update vim8 plugins instead of vim-plug if you like.

# yadm vs stow.
I was previously using some scripts and [GNU stow](https://www.gnu.org/software/stow/) to install the dotfiles from this repo. The old setup using stow is in the [legacy branch](https://github.com/grimm26/dotfiles/tree/legacy). It was kinda janky, so I decided to move to using yadm.

# How to install
**You must first install yadm**. I do this by cloning [the repo](https://github.com/TheLocehiliosan/yadm) to `~/.yadm-project` and then `ln -s ../../.yadm-project/yadm ~/.local/bin/yadm`. This is what my setup assumes, but you can install yadm however you like.

There is a [bootstrap script](https://github.com/grimm26/dotfiles/blob/main/.config/yadm/bootstrap) that installs packages that I use.

## First time
When running this the first time, you may have files in place of the ones that this package comes with. yadm will ask you if you want to overwrite them.
