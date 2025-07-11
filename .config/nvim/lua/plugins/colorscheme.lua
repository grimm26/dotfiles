return {
  {
    -- More features than ishan9299/nvim-solarized-lua
    -- https://github.com/maxmx03/solarized.nvim
    "maxmx03/solarized.nvim",
    enabled = true,
    lazy = false,
    priority = 1000,
    ---@type solarized.config
    opts = {
      variant = "summer",
      error_lens = {
        text = true,
        symbol = true,
      },
      plugins = {
        noice = true,
      },
    },
    config = function(_, opts)
      vim.o.termguicolors = true
      vim.o.background = "dark"
      require("solarized").setup(opts)
      vim.cmd.colorscheme("solarized")
    end,
  },
  -- disabled themes
  {
    "ishan9299/nvim-solarized-lua",
    lazy = false,
    priority = 1000,
    enabled = false,
    config = function()
      vim.cmd.colorscheme("solarized")
    end,
  },
  {
    -- also more features, highlighting is not as good.
    "craftzdog/solarized-osaka.nvim",
    enabled = false,
    lazy = false,
    priority = 1000,
    config = function()
      require("solarized-osaka").setup({
        transparent = false,
        dim_inactive = true,
        lualine_bold = true,
      })
      vim.cmd.colorscheme("solarized-osaka")
    end,
  },
  {
    "folke/tokyonight.nvim",
    lazy = false,
    enabled = false,
    priority = 1000,
    opts = {},
    config = function(_, opts)
      vim.o.background = "dark"
      vim.cmd([[colorscheme tokyonight-night]])
    end,
  },
}
