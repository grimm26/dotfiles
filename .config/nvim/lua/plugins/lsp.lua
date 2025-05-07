return {
  { "onsails/lspkind.nvim", lazy = true },
  {
    "neovim/nvim-lspconfig",
    enabled = true,
    event = { "BufReadPre", "BufNewFile" },
    dependencies = {
      "mason-org/mason.nvim",
      "mason-org/mason-lspconfig.nvim",
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
          require("conform").format({ lsp_fallback = true })
        end,
        desc = "Format buffer with conform or LSP",
        buffer = true,
        silent = true,
        noremap = true,
      },
    },
    config = function()
      -- Set up lspconfig.
      local cmp_capabilities = require("blink.cmp").get_lsp_capabilities()
      local lsp_capabilities = vim.lsp.protocol.make_client_capabilities()
      lsp_capabilities.textDocument.completion.completionItem.snippetSupport = true

      require("mason-lspconfig").setup()
      local lspconfig = require("lspconfig")
      lspconfig.ansiblels.setup({
        capabilities = cmp_capabilities,
      })
      lspconfig.bashls.setup({
        capabilities = cmp_capabilities,
      })
      lspconfig.dockerls.setup({
        capabilities = cmp_capabilities,
      })
      lspconfig.gopls.setup({
        capabilities = cmp_capabilities,
      })
      lspconfig.jdtls.setup({
        capabilities = cmp_capabilities,
      })
      lspconfig.jsonls.setup({
        capabilities = lsp_capabilities,
      })
      lspconfig.marksman.setup({
        capabilities = lsp_capabilities,
      })
      lspconfig.terraformls.setup({
        on_init = function(client, _)
          client.server_capabilities.semanticTokensProvider = nil
        end,
        capabilities = cmp_capabilities,
      })
      lspconfig.vimls.setup({
        capabilities = cmp_capabilities,
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
}
