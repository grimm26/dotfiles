return {
  { "onsails/lspkind.nvim", lazy = true },
  {
    "neovim/nvim-lspconfig",
    enabled = true,
    event = { "BufReadPre", "BufNewFile" },
    dependencies = {
      { "mason-org/mason.nvim" },
      { "mason-org/mason-lspconfig.nvim" },
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

      vim.lsp.config("ansiblels", {
        capabilities = cmp_capabilities,
      })
      vim.lsp.config("bashls", {
        capabilities = cmp_capabilities,
      })
      vim.lsp.config("dockerls", {
        capabilities = cmp_capabilities,
      })
      vim.lsp.config("gopls", {
        capabilities = cmp_capabilities,
      })
      vim.lsp.config("jdtls", {
        capabilities = cmp_capabilities,
      })
      vim.lsp.config("jsonls", {
        capabilities = lsp_capabilities,
      })
      vim.lsp.config("terraformls", {
        on_init = function(client, _)
          client.server_capabilities.semanticTokensProvider = nil
        end,
        capabilities = cmp_capabilities,
      })
      vim.lsp.config("vimls", {
        capabilities = cmp_capabilities,
      })
      vim.lsp.config("pylsp", {
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
      vim.lsp.config("yamlls", {
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
      require("mason-lspconfig").setup()
    end,
  },
}
