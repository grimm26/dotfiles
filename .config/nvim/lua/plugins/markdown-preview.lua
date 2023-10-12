return {
  {
    "iamcco/markdown-preview.nvim",
    build = "cd app && yarn install",
    config = function()
      vim.g.mkdp_filetypes = { "markdown" }
    end,
    keys = {
      { "<leader>mp", "<cmd>MarkdownPreviewToggle<cr>", desc = "Toggle MardownPreview" },
    },
    ft = "markdown",
  },
}
