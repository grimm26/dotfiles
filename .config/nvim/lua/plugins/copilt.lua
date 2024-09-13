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
  {
    -- Set up some keymaps
    "CopilotC-Nvim/CopilotChat.nvim",
    branch = "canary",
    dependencies = {
      { "zbirenbaum/copilot.lua" }, -- or github/copilot.vim
      { "nvim-lua/plenary.nvim" }, -- for curl, log wrapper
    },
    build = "make tiktoken", -- Only on MacOS or Linux
    opts = {
      debug = true, -- Enable debugging
      -- See Configuration section for rest
    },
    -- See Commands section for default commands if you want to lazy load on them
  },
}
