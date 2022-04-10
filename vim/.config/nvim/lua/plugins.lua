-- This file can be loaded by calling `lua require('plugins')` from your init.vim

-- Only required if you have packer configured as `opt`
--vim.cmd [[packadd packer.nvim]]

return require('packer').startup(function(use)
  -- Packer can manage itself
  use 'wbthomason/packer.nvim'

  -- Simple plugins can be specified as strings
  use 'averms/black-nvim'
  use 'stsewd/isort.nvim'
  use 'ellisonleao/glow.nvim'
  use 'lewis6991/gitsigns.nvim'
  use {
  'nvim-telescope/telescope.nvim',
  requires = { {'nvim-lua/plenary.nvim'} }
  }
  use 'kamykn/popup-menu.nvim'
  use {
    'kyazdani42/nvim-tree.lua',
    requires = { {'kyazdani42/nvim-web-devicons'} }  -- for file icons
  }
  use {
  'ishan9299/nvim-solarized-lua',
  'vim-airline/vim-airline',
  'vim-airline/vim-airline-themes',
  'will133/vim-dirdiff',
  'tpope/vim-endwise',
  'tpope/vim-fugitive',
  'fatih/vim-go',
  'elzr/vim-json',
  'dietsche/vim-lastplace',
  'hashivim/vim-terraform',
  'tmux-plugins/vim-tmux',
  'wincent/terminus',
  'z0mbix/vim-shfmt',
  'prettier/vim-prettier',
  'kamykn/spelunker.vim',
}

  -- Post-install/update hook with neovim command
  use { 'nvim-telescope/telescope-fzf-native.nvim', run = 'make' }
  use { 'nvim-treesitter/nvim-treesitter', run = ':TSUpdate' }

  use { 'echasnovski/mini.nvim', branch = 'stable' }
end)
