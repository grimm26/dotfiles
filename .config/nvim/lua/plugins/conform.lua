return {
  {
    "stevearc/conform.nvim",
    opts = {},
    config = function()
      require("conform").setup({
        formatters = {
          mdslw = {
            prepend_args = { "--max-width", "5000" },
          },
        },
        formatters_by_ft = {
          lua = { "stylua" },
          terraform = { "terraform_fmt" },
          hcl = { "terraform_fmt" },
          yaml = { "yamlfmt" },
          python = { "isort", "black" },
          javascript = { "prettierd" },
          typescript = { "prettierd" },
          vue = { "prettierd" },
          html = { "prettierd" },
          graphql = { "prettierd" },
          markdown = { "mdslw", "mdformat" },
        },
        format_on_save = {
          -- These options will be passed to conform.format()
          timeout_ms = 500,
          lsp_fallback = true,
        },
      })
    end,
  },
}
