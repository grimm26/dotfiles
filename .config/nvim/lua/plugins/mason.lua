return {
  {
    "williamboman/mason.nvim",
    build = ":MasonUpdate",
    config = function()
      require("mason").setup({
        pip = {
          install_args = { "--upgrade" },
        },
      })
    end,
  },
  {
    "williamboman/mason-lspconfig.nvim",
    dependencies = {
      "neovim/nvim-lspconfig",
    },
    config = true,
  },
  {
    "WhoIsSethDaniel/mason-tool-installer.nvim",
    cmd = {
      "MTU",
      "MasonToolsUpdate",
      "MasonToolsInstall",
    },
    config = function()
      require("mason-tool-installer").setup({
        -- a list of all tools you want to ensure are installed upon
        -- start; they should be the names Mason uses for each tool
        ensure_installed = {
          "ansible-lint",
          "bash-language-server",
          "black",
          "codespell",
          "dockerfile-language-server",
          "gopls",
          "jdtls",
          "json-lsp",
          "jsonlint",
          "markdownlint",
          "marksman",
          "prettierd",
          "python-lsp-server",
          "stylua",
          "isort",
          "solargraph",
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
          vim.schedule(function()
            print(vim.inspect(e.data)) -- print the table that lists the programs that were installed
          end)
        end,
      })
    end,
  },
}
