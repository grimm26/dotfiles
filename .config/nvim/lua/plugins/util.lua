return {
  -- library used by other plugins
  { "nvim-lua/plenary.nvim", lazy = true },
  { "onsails/lspkind.nvim", lazy = true },
  { "nvim-tree/nvim-web-devicons", lazy = true },
  {
    "lambdalisue/vim-suda",
    init = function()
      vim.g.suda_smart_edit = 1
    end,
  },
  {
    "mikesmithgh/kitty-scrollback.nvim",
    enabled = true,
    lazy = true,
    cmd = { "KittyScrollbackGenerateKittens", "KittyScrollbackCheckHealth" },
    event = { "User KittyScrollbackLaunch" },
    version = "*", -- latest stable version, may have breaking changes if major version changed
    -- version = "^2.0.0", -- pin major version, include fixes and features that do not have breaking changes
    config = function()
      require("kitty-scrollback").setup()
    end,
  },
}
