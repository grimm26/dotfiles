return {
  {
    "mason-org/mason.nvim",
    -- version = "^1.0.0",
    build = ":MasonUpdate",
    opts = {
      pip = {
        install_args = { "--upgrade" },
      },
    },
  },
  {
    "mason-org/mason-lspconfig.nvim",
    -- version = "^1.0.0",
    dependencies = {
      "neovim/nvim-lspconfig",
    },
    config = true,
  },
  {
    "WhoIsSethDaniel/mason-tool-installer.nvim",
    config = function()
      require("mason-tool-installer").setup({
        -- a list of all tools you want to ensure are installed upon
        -- start; they should be the names Mason uses for each tool
        ensure_installed = {
          "ansible-lint",
          "bash-language-server",
          "black",
          "codespell",
          "curlylint",
          "dockerfile-language-server",
          "gitlint",
          "gopls",
          "jdtls",
          "json-lsp",
          "jsonlint",
          "markdownlint",
          "marksman",
          "mdslw",
          "prettierd",
          "python-lsp-server",
          "stylua",
          "isort",
          "terraform-ls",
          "vim-language-server",
          "yaml-language-server",
          "yamlfmt",
        },

        -- if set to true this will check each tool for updates. If updates
        -- are available the tool will be updated.
        -- Default: false
        auto_update = false,

        -- automatically install / update on startup. If set to false nothing
        -- will happen on startup. You can use `:MasonToolsUpdate` to install
        -- tools and check for updates.
        -- Default: true
        run_on_start = true,
        -- set a delay (in ms) before the installation starts. This is only
        -- effective if run_on_start is set to true.
        -- e.g.: 5000 = 5 second delay, 10000 = 10 second delay, etc...
        -- Default: 0
        start_delay = 3000, -- 3 second delay  -- Only attempt to install if 'debounce_hours' number of hours has
        -- elapsed since the last time Neovim was started. This stores a
        -- timestamp in a file named stdpath('data')/mason-tool-installer-debounce.
        -- This is only relevant when you are using 'run_on_start'. It has no
        -- effect when running manually via ':MasonToolsInstall' etc....
        -- Default: nil
        -- debounce_hours = 5, -- at least 5 hours between attempts to install/update
      })
      vim.api.nvim_create_user_command("MTU", "MasonToolsUpdate", { desc = "Run MasonToolsUpdate" })
      vim.api.nvim_create_autocmd("User", {
        pattern = "MasonToolsStartingInstall",
        callback = function()
          vim.schedule(function()
            print("mason-tool-installer is starting")
          end)
        end,
      })
      vim.api.nvim_create_autocmd("User", {
        pattern = "MasonToolsUpdateCompleted",
        callback = function(e)
          if #e.data == 0 then
            return
          else
            vim.schedule(function()
              print("Mason packages installed/updated: ", vim.inspect(e.data)) -- print the table that lists the programs that were installed
            end)
          end
        end,
      })
    end,
  },
}
