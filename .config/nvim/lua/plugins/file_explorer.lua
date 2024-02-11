return {
  {
    -- file explorer
    "stevearc/oil.nvim",
    dependencies = { "nvim-tree/nvim-web-devicons" },
    config = function()
      require("oil").setup()
      local wk = require("which-key")
      wk.register({
        ["-"] = {
          "<CMD>Oil<CR>",
          "Open parent directory",
        },
      })
    end,
  },
}
