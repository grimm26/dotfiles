return {
  {
    "roobert/search-replace.nvim",
    config = function()
      require("search-replace").setup({
        -- optionally override defaults
        default_replace_single_buffer_options = "gcI",
        default_replace_multi_buffer_options = "egcI",
      })
      local wk = require("which-key")
      wk.add({
        { "<leader>r", group = "SearchReplaceSingleBuffer" },
        { "<leader>rW", "<CMD>SearchReplaceSingleBufferCWORD<CR>", desc = "[W]ORD" },
        { "<leader>rb", group = "SearchReplaceMultiBuffer" },
        { "<leader>rbW", "<CMD>SearchReplaceMultiBufferCWORD<CR>", desc = "[W]ORD" },
        { "<leader>rbe", "<CMD>SearchReplaceMultiBufferCExpr<CR>", desc = "[e]xpr" },
        { "<leader>rbf", "<CMD>SearchReplaceMultiBufferCFile<CR>", desc = "[f]ile" },
        { "<leader>rbo", "<CMD>SearchReplaceMultiBufferOpen<CR>", desc = "[o]pen" },
        {
          "<leader>rbs",
          "<CMD>SearchReplaceMultiBufferSelections<CR>",
          desc = "SearchReplaceMultiBuffer [s]election list",
        },
        { "<leader>rbw", "<CMD>SearchReplaceMultiBufferCWord<CR>", desc = "[w]ord" },
        { "<leader>re", "<CMD>SearchReplaceSingleBufferCExpr<CR>", desc = "[e]xpr" },
        { "<leader>rf", "<CMD>SearchReplaceSingleBufferCFile<CR>", desc = "[f]ile" },
        { "<leader>ro", "<CMD>SearchReplaceSingleBufferOpen<CR>", desc = "[o]pen" },
        {
          "<leader>rs",
          "<CMD>SearchReplaceSingleBufferSelections<CR>",
          desc = "SearchReplaceSingleBuffer [s]election list",
        },
        { "<leader>rw", "<CMD>SearchReplaceSingleBufferCWord<CR>", desc = "[w]ord" },
      })

      -- show the effects of a search / replace in a live preview window
      -- vim.o.inccommand = "split"
    end,
  },
}
