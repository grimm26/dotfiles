return {
  {
    -- file explorer
    "stevearc/oil.nvim",
    dependencies = { "nvim-tree/nvim-web-devicons" },
    config = function()
      require("oil").setup()
      local wk = require("which-key")
      wk.add({
        { "-", "<CMD>Oil<CR>", desc = "Open parent directory" },
      })
    end,
  },
}
