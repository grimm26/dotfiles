return {
  { "onsails/lspkind.nvim", lazy = true },
  { "hrsh7th/cmp-nvim-lsp", lazy = true },
  {
    "neovim/nvim-lspconfig",
    event = { "BufReadPre", "BufNewFile" },
    dependencies = {
      "mason.nvim",
      "williamboman/mason-lspconfig.nvim",
      "hrsh7th/cmp-nvim-lsp",
    },
    keys = {
      {
        "<leader>ca",
        function()
          vim.lsp.buf.code_action()
        end,
        desc = "Code Action menu",
      },
      {
        "<leader>lf",
        function()
          vim.lsp.buf.format({
            async = true,
          })
        end,
        desc = "Format buffer with LSP",
        buffer = true,
        silent = true,
        noremap = true,
      },
    },
    config = function()
      local lsp_on_attach_no_fmt = function(client, bufnr)
        -- Set this when using mini.completion
        -- local function buf_set_option(name, value)
        --   vim.api.nvim_buf_set_option(bufnr, name, value)
        -- end
        --
        -- buf_set_option("omnifunc", "v:lua.MiniCompletion.completefunc_lsp")

        -- Mappings are created globally for simplicity

        -- Currently all formatting is handled with 'null-ls' plugin
        if vim.fn.has("nvim-0.8") == 1 then
          client.server_capabilities.documentFormattingProvider = false
          client.server_capabilities.documentRangeFormattingProvider = false
        else
          client.resolved_capabilities.document_formatting = false
          client.resolved_capabilities.document_range_formatting = false
        end
      end
      local lsp_on_attach_fmt_on_write = function(client, bufnr)
        if client.supports_method("textDocument/formatting") then
          vim.api.nvim_clear_autocmds({ group = augroup, buffer = bufnr })
          vim.api.nvim_create_autocmd("BufWritePre", {
            group = augroup,
            buffer = bufnr,
            callback = function()
              vim.lsp.buf.format({
                bufnr = bufnr,
                async = false,
              })
            end,
          })
        end
      end
      require("cmp_config")
      -- Set up lspconfig.
      local cmp_capabilities = require("cmp_nvim_lsp").default_capabilities()
      require("mason-lspconfig").setup()
      local lspconfig = require("lspconfig")
      lspconfig.ansiblels.setup({
        capabilities = cmp_capabilities,
        on_attach = lsp_on_attach_no_fmt,
      })
      lspconfig.bashls.setup({
        capabilities = cmp_capabilities,
        on_attach = lsp_on_attach_no_fmt,
      })
      lspconfig.dockerls.setup({
        capabilities = cmp_capabilities,
      })
      lspconfig.gopls.setup({
        capabilities = cmp_capabilities,
        on_attach = lsp_on_attach_fmt_on_write,
      })
      lspconfig.jdtls.setup({
        capabilities = cmp_capabilities,
        on_attach = lsp_on_attach_fmt_on_write,
      })
      lspconfig.jsonls.setup({
        capabilities = cmp_capabilities,
        on_attach = lsp_on_attach_fmt_on_write,
      })
      lspconfig.solargraph.setup({
        capabilities = cmp_capabilities,
        on_attach = lsp_on_attach_no_fmt,
      })
      lspconfig.marksman.setup({
        capabilities = cmp_capabilities,
        on_attach = lsp_on_attach_no_fmt,
      })
      lspconfig.terraformls.setup({
        capabilities = cmp_capabilities,
        on_attach = lsp_on_attach_no_fmt,
      })
      lspconfig.vimls.setup({
        capabilities = cmp_capabilities,
        on_attach = lsp_on_attach_no_fmt,
      })
      lspconfig.pylsp.setup({
        capabilities = cmp_capabilities,
        settings = {
          pylsp = {
            plugins = {
              pycodestyle = {
                maxLineLength = 100,
              },
            },
          },
        },
      })
      lspconfig.yamlls.setup({
        capabilities = cmp_capabilities,
        on_attach = lsp_on_attach_no_fmt,
        settings = {
          yaml = {
            -- don't freak out on Cloudformation
            customTags = {
              "!Base64",
              "!Cidr",
              "!FindInMap sequence",
              "!GetAtt",
              "!GetAtt sequence",
              "!GetAZs",
              "!ImportValue",
              "!Join sequence",
              "!Ref",
              "!Select sequence",
              "!Split sequence",
              "!Sub sequence",
              "!Sub",
              "!And sequence",
              "!Condition",
              "!Equals sequence",
              "!If sequence",
              "!Not sequence",
              "!Or sequence",
            },
          },
        },
      })
    end,
  },
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
    end,
  },
}
