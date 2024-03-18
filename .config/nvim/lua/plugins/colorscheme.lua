return {
  {
    "ishan9299/nvim-solarized-lua",
    lazy = false,
    priority = 1000,
    enabled = false,
    config = function()
      -- vim.cmd.colorscheme("solarized")
    end,
  },
  {
    -- More features than ishan9299/nvim-solarized-lua
    "maxmx03/solarized.nvim",
    lazy = false,
    priority = 1000,
    config = function()
      require("solarized").setup({
        transparent = false,
        -- neo theme gives better highlighting
        theme = "neo",
      })
      vim.o.background = "dark"
      vim.cmd.colorscheme("solarized")
    end,
  },
  {
    -- also more features, highlighting is not as good.
    "craftzdog/solarized-osaka.nvim",
    lazy = false,
    priority = 1000,
    config = function()
      require("solarized-osaka").setup({
        transparent = false,
        dim_inactive = true,
        lualine_bold = true,
      })
      -- vim.cmd.colorscheme("solarized-osaka")
    end,
  },
}
