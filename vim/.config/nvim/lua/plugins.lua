-- This file can be loaded by calling `lua require('plugins')` from your init.vim

-- Only required if you have packer configured as `opt`
--vim.cmd [[packadd packer.nvim]]

return require('packer').startup(function(use)
  -- Packer can manage itself
  use 'wbthomason/packer.nvim'

  use {
  'nvim-telescope/telescope.nvim',
  requires = { {'nvim-lua/plenary.nvim'} }
  }
  use {
    'kyazdani42/nvim-tree.lua',
    requires = { {'kyazdani42/nvim-web-devicons'} }  -- for file icons
  }
  use {
    "folke/trouble.nvim",
    requires = "kyazdani42/nvim-web-devicons",
    config = function()
      require("trouble").setup {
        -- your configuration comes here
        -- or leave it empty to use the default settings
        -- refer to the configuration section below
      }
    end
  }

  -- Simple plugins can be specified as strings in a list
  use {
    'neovim/nvim-lspconfig',
    'kamykn/popup-menu.nvim',
    'averms/black-nvim',
    'stsewd/isort.nvim',
    'ellisonleao/glow.nvim',
    'lewis6991/gitsigns.nvim',
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

  -- colorschemes
  use {
    'marko-cerovac/material.nvim',
    'ishan9299/nvim-solarized-lua',
  }

  -- Post-install/update hook with neovim command
  use { 'nvim-telescope/telescope-fzf-native.nvim', run = 'make' }
  use { 'nvim-treesitter/nvim-treesitter', run = ':TSUpdate' }

  use { 'echasnovski/mini.nvim', branch = 'stable' }
end)
