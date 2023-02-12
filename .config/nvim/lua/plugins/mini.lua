return {
  {
    "echasnovski/mini.nvim",
    branch = "stable",
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
      require("mini.surround").setup({})
    end,
  },
}
