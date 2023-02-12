return {
  {
    "folke/trouble.nvim",
    dependencies = "kyazdani42/nvim-web-devicons",
    keys = {
      { "<leader>xx", "<cmd>TroubleToggle<cr>", desc = "Toggle Trouble" },
      { "<leader>xw", "<cmd>TroubleToggle workspace_diagnostics<cr>", desc = "Toggle Trouble workspace diagnostics" },
      { "<leader>xd", "<cmd>TroubleToggle document_diagnostics<cr>", desc = "Toggle Trouble document diagnostics" },
      { "<leader>xq", "<cmd>TroubleToggle quickfix<cr>", desc = "Toggle Trouble quickfix" },
      { "<leader>xl", "<cmd>TroubleToggle loclist<cr>", desc = "Toggle Trouble window location list" },
      {
        "gR",
        "<cmd>TroubleToggle lsp_references<cr>",
        desc = "Toggle Trouble references of the word under the cursor from the builtin LSP client",
      },
    },
    config = true,
  },
}
