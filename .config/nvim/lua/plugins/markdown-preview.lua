return {
  {
    "iamcco/markdown-preview.nvim",
    build = function(plugin)
      if vim.fn.executable("npx") then
        vim.cmd("!cd " .. plugin.dir .. " && cd app && npx --yes yarn install")
      else
        vim.cmd([[Lazy load markdown-preview.nvim]])
        vim.fn["mkdp#util#install"]()
      end
    end,
    init = function()
      vim.g.mkdp_filetypes = { "markdown" }
      vim.g.mkdp_browser = "/usr/bin/xdg-open"
    end,
    ft = { "markdown" },
    keys = {
      { "<leader>mp", "<cmd>MarkdownPreviewToggle<cr>", desc = "Toggle MardownPreview" },
    },
  },
  {
    "OXY2DEV/markview.nvim",
    lazy = false,
    priority = 49,
    keys = {
      { "<leader>mvt", "<cmd>Markview Toggle<cr>", desc = "Toggle Markview" },
      { "<leader>mvs", "<cmd>Markview splitToggle<cr>", desc = "Toggle Markview Split view" },
      { "<leader>mvh", "<cmd>Markview HybridToggle<cr>", desc = "Toggle Markview Hybrid view" },
    },
    opts = {
      preview = {
        enable = true,
        enable_hybrid_mode = true,
        hybrid_modes = { "n", "no", "c" },
        icon_provider = "mini", -- "mini" or "devicons"
      },
    },
    -- For blink.cmp's completion
    -- source
    dependencies = {
      "saghen/blink.cmp",
    },
  },
}
