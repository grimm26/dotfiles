-- This file can be loaded by calling `lua require('plugins')` from your init.vim
-- Only required if you have packer configured as `opt`
-- vim.cmd [[packadd packer.nvim]]
local packer_group = vim.api.nvim_create_augroup('Packer', {clear = true})
vim.api.nvim_create_autocmd('BufWritePost', {
  command = 'source <afile> | PackerCompile',
  group = packer_group,
  pattern = 'plugins.lua'
})

return require("packer").startup(function(use)
  -- Packer can manage itself
  use("wbthomason/packer.nvim")

  use({
    "nvim-telescope/telescope.nvim",
    requires = {{"nvim-lua/plenary.nvim"}}
  })
  use({
    "kyazdani42/nvim-tree.lua",
    requires = {{"kyazdani42/nvim-web-devicons"}} -- for file icons
  })
  use({
    "folke/trouble.nvim",
    requires = "kyazdani42/nvim-web-devicons",
    config = function()
      require("trouble").setup({
        -- your configuration comes here
        -- or leave it empty to use the default settings
        -- refer to the configuration section below
      })
    end
  })

  -- Simple plugins can be specified as strings in a list
  use({
    "neovim/nvim-lspconfig",
    'williamboman/nvim-lsp-installer',
    "hrsh7th/nvim-cmp",
    "hrsh7th/cmp-nvim-lsp",
    "saadparwaiz1/cmp_luasnip",
    "L3MON4D3/LuaSnip",
    "kamykn/popup-menu.nvim",
    -- "averms/black-nvim",
    "ellisonleao/glow.nvim",
    "lewis6991/gitsigns.nvim",
    "will133/vim-dirdiff",
    "tpope/vim-endwise",
    "tpope/vim-fugitive",
    "fatih/vim-go",
    "elzr/vim-json",
    "tmux-plugins/vim-tmux",
    "prettier/vim-prettier",
    "kamykn/spelunker.vim",
    "mrjones2014/legendary.nvim", -- keymappings, commands, autocmds
    'stevearc/dressing.nvim', -- fancy ui menu with legendary
  })

  use({
    'pwntester/octo.nvim',
    requires = {
      'nvim-lua/plenary.nvim',
      'nvim-telescope/telescope.nvim',
      'kyazdani42/nvim-web-devicons',
    },
  })

  use({
    "nvim-lualine/lualine.nvim",
    requires = {"kyazdani42/nvim-web-devicons", opt = true}
  })
  -- colorschemes
  use({"marko-cerovac/material.nvim", "ishan9299/nvim-solarized-lua", "Domeee/mosel.nvim"})

  -- Post-install/update hook with neovim command
  use({"nvim-telescope/telescope-fzf-native.nvim", run = "make"})
  use({"nvim-treesitter/nvim-treesitter", run = ":TSUpdate"})
  use("nvim-treesitter/nvim-treesitter-textobjects")

  use({"echasnovski/mini.nvim", branch = "stable"})
end)
