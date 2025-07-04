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
        graphql = { "prettierd" },
        hcl = { "keep-sorted", "terraform_fmt" },
        html = { "prettierd" },
        javascript = { "prettierd" },
        json = { "jq" },
        lua = { "stylua" },
        markdown = { "mdslw", "mdformat" },
        python = { "isort", "black" },
        terraform = { "keep-sorted", "terraform_fmt" },
        toml = { "keep-sorted" },
        typescript = { "prettierd" },
        vue = { "prettierd" },
        yaml = { "keep-sorted", "yamlfmt" },
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
