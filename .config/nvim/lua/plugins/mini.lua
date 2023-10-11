return {
  {
    "echasnovski/mini.nvim",
    version = false,
    config = function()
      -- Enable modules out of mini,nvim that we want to use
      local starter = require("mini.starter")
      starter.setup({
        items = {
          starter.sections.telescope(),
        },
        content_hooks = {
          starter.gen_hook.adding_bullet(),
          starter.gen_hook.aligning("center", "center"),
        },
      })
      require("mini.align").setup()
      require("mini.comment").setup({})
      -- require("mini.indentscope").setup({})
      require("mini.surround").setup({
        mappings = {
          add = "<leader>sa", -- Add surrounding in Normal and Visual modes
          delete = "<leader>sd", -- Delete surrounding
          find = "<leader>sf", -- Find surrounding (to the right)
          find_left = "<leader>sF", -- Find surrounding (to the left)
          highlight = "<leader>sh", -- Highlight surrounding
          replace = "<leader>sr", -- Replace surrounding
          update_n_lines = "<leader>sn", -- Update `n_lines`

          suffix_last = "l", -- Suffix to search with "prev" method
          suffix_next = "n", -- Suffix to search with "next" method
        },
      })
    end,
  },
}
