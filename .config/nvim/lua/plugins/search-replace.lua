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
      wk.register({
        r = {
          mode = { "n" },
          name = "SearchReplaceSingleBuffer",
          s = { "<CMD>SearchReplaceSingleBufferSelections<CR>", "SearchReplaceSingleBuffer [s]election list" },
          o = { "<CMD>SearchReplaceSingleBufferOpen<CR>", "[o]pen" },
          w = { "<CMD>SearchReplaceSingleBufferCWord<CR>", "[w]ord" },
          W = { "<CMD>SearchReplaceSingleBufferCWORD<CR>", "[W]ORD" },
          e = { "<CMD>SearchReplaceSingleBufferCExpr<CR>", "[e]xpr" },
          f = { "<CMD>SearchReplaceSingleBufferCFile<CR>", "[f]ile" },

          b = {
            name = "SearchReplaceMultiBuffer",

            s = { "<CMD>SearchReplaceMultiBufferSelections<CR>", "SearchReplaceMultiBuffer [s]election list" },
            o = { "<CMD>SearchReplaceMultiBufferOpen<CR>", "[o]pen" },
            w = { "<CMD>SearchReplaceMultiBufferCWord<CR>", "[w]ord" },
            W = { "<CMD>SearchReplaceMultiBufferCWORD<CR>", "[W]ORD" },
            e = { "<CMD>SearchReplaceMultiBufferCExpr<CR>", "[e]xpr" },
            f = { "<CMD>SearchReplaceMultiBufferCFile<CR>", "[f]ile" },
          },
        },
      }, { prefix = "<leader>" })

      -- show the effects of a search / replace in a live preview window
      -- vim.o.inccommand = "split"
    end,
  },
}
