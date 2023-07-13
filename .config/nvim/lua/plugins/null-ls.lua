return {
  {
    "jose-elias-alvarez/null-ls.nvim",
    dependencies = {
      "nvim-lua/plenary.nvim",
    },
    config = function()
      local augroup = vim.api.nvim_create_augroup("LspFormatting", {})
      local null_ls = require("null-ls")
      null_ls.setup({
        sources = {
          null_ls.builtins.code_actions.gitsigns,
          null_ls.builtins.completion.spell.with({
            filetypes = { "gitcommit", "markdown", "text", "asciidoc" },
          }),
          null_ls.builtins.diagnostics.codespell,
          null_ls.builtins.diagnostics.jsonlint,
          null_ls.builtins.diagnostics.markdownlint.with({
            extra_args = { "--disable", "MD013" },
          }),
          null_ls.builtins.diagnostics.misspell,
          null_ls.builtins.diagnostics.zsh,
          null_ls.builtins.formatting.gofmt,
          null_ls.builtins.formatting.isort,
          null_ls.builtins.formatting.prettierd.with({
            filetypes = { "javascript", "typescript", "vue", "less", "html", "graphql" },
          }),
          null_ls.builtins.formatting.stylua,
          null_ls.builtins.formatting.terraform_fmt.with({
            extra_filetypes = { "hcl" },
          }),
          null_ls.builtins.formatting.yamlfmt,
        },
        -- you can reuse a shared lspconfig on_attach callback here
        on_attach = function(client, bufnr)
          if client.supports_method("textDocument/formatting") then
            vim.api.nvim_clear_autocmds({ group = augroup, buffer = bufnr })
            vim.api.nvim_create_autocmd("BufWritePre", {
              group = augroup,
              buffer = bufnr,
              callback = function()
                vim.lsp.buf.format({
                  bufnr = bufnr,
                  async = false,
                  filter = function(client)
                    return client.name == "null-ls"
                  end,
                })
              end,
            })
          end
        end,
      })
    end,
  },
}
