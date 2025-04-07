return {
  {
    "zbirenbaum/copilot.lua",
    enabled = true,
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
        markdown = true,
        yaml = false,
      },
      panel = { enabled = false },
      suggestion = {
        enabled = true,
        auto_trigger = true,
      },
    },
  },
  {
    -- Set up some keymaps
    "CopilotC-Nvim/CopilotChat.nvim",
    branch = "main",
    enabled = true,
    dependencies = {
      { "zbirenbaum/copilot.lua" }, -- or github/copilot.vim
      { "nvim-lua/plenary.nvim" }, -- for curl, log wrapper
    },
    build = "make tiktoken", -- Only on MacOS or Linux
    keys = {
      {
        "<leader>ccq",
        function()
          local input = vim.fn.input("Quick Chat: ")
          if input ~= "" then
            require("CopilotChat").ask(input, { selection = require("CopilotChat.select").buffer })
          end
        end,
        desc = "CopilotChat - Quick chat",
      },
      {
        "<leader>ccr",
        "<cmd>CopilotChatReview<cr>",
        desc = "CopilotChat - Review Selected Code",
      },
    },
    opts = {
      debug = true, -- Enable debugging
      -- See Configuration section for rest
    },
    -- See Commands section for default commands if you want to lazy load on them
  },
}
