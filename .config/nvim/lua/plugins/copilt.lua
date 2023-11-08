return {
  {
    "zbirenbaum/copilot.lua",
    event = "VeryLazy",
    cmd = "Copilot",
    keys = {
      {
        "<leader>cop",
        function()
          require("copilot.suggestion").toggle_auto_trigger()
        end,
        desc = "Toggle Copilot suggestion auto trigger",
      },
    },
    opts = {
      filetypes = {
        ["."] = false,
        gitcommit = false,
        gitrebase = false,
        help = false,
        markdown = false,
        yaml = false,
      },
      suggestion = {
        enabled = true,
        auto_trigger = true,
      },
    },
  },
}
