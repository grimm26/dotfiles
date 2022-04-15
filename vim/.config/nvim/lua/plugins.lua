-- This file can be loaded by calling `lua require('plugins')` from your init.vim

-- Only required if you have packer configured as `opt`
--vim.cmd [[packadd packer.nvim]]
vim.cmd([[
  augroup Packer
    autocmd!
    autocmd BufWritePost plugins.lua PackerCompile
  augroup end
]])

return require("packer").startup(function(use)
	-- Packer can manage itself
	use("wbthomason/packer.nvim")

	use({
		"nvim-telescope/telescope.nvim",
		requires = { { "nvim-lua/plenary.nvim" } },
	})
	use({
		"kyazdani42/nvim-tree.lua",
		requires = { { "kyazdani42/nvim-web-devicons" } }, -- for file icons
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
		end,
	})

	-- Simple plugins can be specified as strings in a list
	use({
		"neovim/nvim-lspconfig",
		"hrsh7th/nvim-cmp",
		"hrsh7th/cmp-nvim-lsp",
		"saadparwaiz1/cmp_luasnip",
		"L3MON4D3/LuaSnip",
		"kamykn/popup-menu.nvim",
		"averms/black-nvim",
		"stsewd/isort.nvim",
		"ellisonleao/glow.nvim",
		"lewis6991/gitsigns.nvim",
		"will133/vim-dirdiff",
		"tpope/vim-endwise",
		"tpope/vim-fugitive",
		"fatih/vim-go",
		"elzr/vim-json",
		"tmux-plugins/vim-tmux",
		"z0mbix/vim-shfmt",
		"prettier/vim-prettier",
		"kamykn/spelunker.vim",
	})

	use({
		"nvim-lualine/lualine.nvim",
		requires = { "kyazdani42/nvim-web-devicons", opt = true },
	})
	-- colorschemes
	use({
		"marko-cerovac/material.nvim",
		"ishan9299/nvim-solarized-lua",
	})

	-- Post-install/update hook with neovim command
	use({ "nvim-telescope/telescope-fzf-native.nvim", run = "make" })
	use({ "nvim-treesitter/nvim-treesitter", run = ":TSUpdate" })
	use("nvim-treesitter/nvim-treesitter-textobjects")

	use({ "echasnovski/mini.nvim", branch = "stable" })

	use({
		"jose-elias-alvarez/null-ls.nvim",
		requires = { "nvim-lua/plenary.nvim" },
	})
end)
