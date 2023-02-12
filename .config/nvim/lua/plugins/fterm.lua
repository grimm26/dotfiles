return {
  {
    "numToStr/FTerm.nvim",
    cmd = {
      "FTermOpen",
      "FTermClose",
      "FTermExit",
      "FTermToggle",
    },
    config = function()
      vim.api.nvim_create_user_command("FTermOpen", function()
        require("FTerm").open()
      end, { bang = true })
      vim.api.nvim_create_user_command("FTermClose", function()
        require("FTerm").close()
      end, { bang = true })
      vim.api.nvim_create_user_command("FTermExit", function()
        require("FTerm").exit()
      end, { bang = true })
      vim.api.nvim_create_user_command("FTermToggle", function()
        require("FTerm").toggle()
      end, { bang = true })
    end,
  },
}
