return {
  {
    "stevearc/conform.nvim",
    opts = {
      notify_no_formatters = true,
      formatters = {
        mdslw = {
          prepend_args = { "--max-width", "5000", "--suppressions", "!!!" },
        },
        mdformat = {
          prepend_args = { "--extensions", "admon", "--align-semantic-breaks-in-lists" },
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
      default_format_opts = {
        lsp_format = "never",
      },
      format_on_save = {
        -- These options will be passed to conform.format()
        timeout_ms = 500,
      },
    },
  },
}
