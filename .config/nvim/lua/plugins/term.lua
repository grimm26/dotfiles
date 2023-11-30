return {
  {
    {
      "akinsho/toggleterm.nvim",
      version = "*",
      opts = {
        open_mapping = "<leader>tt",
      },
      config = function(_, opts)
        require("toggleterm").setup(opts)
      end,
    },
  },
}
