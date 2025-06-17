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
        keep_sorted = {
          command = "keep-sorted",
          args = { "$FILENAME" },
          stdin = false,
        },
      },
      formatters_by_ft = {
        graphql = { "prettierd" },
        hcl = { "terraform_fmt" },
        html = { "prettierd" },
        javascript = { "prettierd" },
        lua = { "stylua" },
        markdown = { "mdslw", "mdformat" },
        python = { "isort", "black" },
        terraform = { "keep_sorted", "terraform_fmt" },
        toml = { "keep_sorted" },
        typescript = { "prettierd" },
        vue = { "prettierd" },
        yaml = { "yamlfmt" },
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
