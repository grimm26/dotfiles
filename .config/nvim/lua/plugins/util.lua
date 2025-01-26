return {
  -- library used by other plugins
  { "nvim-lua/plenary.nvim", lazy = true },
  { "onsails/lspkind.nvim", lazy = true },
  {
    "lambdalisue/vim-suda",
    init = function()
      vim.g.suda_smart_edit = 1
      vim.api.nvim_create_user_command("W", function(opts)
        vim.cmd("SudaWrite " .. vim.trim(opts.args) or "")
      end, { nargs = "*" })
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
    opts = {},
  },
}
