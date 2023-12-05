return {
  {
    {
      "akinsho/toggleterm.nvim",
      version = "*",
      opts = {
        open_mapping = "<leader>tt",
        insert_mappings = false,
      },
      config = function(_, opts)
        require("toggleterm").setup(opts)
      end,
    },
  },
}
