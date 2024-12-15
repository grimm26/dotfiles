return {
  {
    "mfussenegger/nvim-lint",
    event = { "BufReadPre", "BufNewFile" },
    config = function()
      local lint = require("lint")
      local codespell_linter = lint.linters.codespell
      local markdownlint_linter = lint.linters.markdownlint
      codespell_linter.args = {
        "-I",
        vim.fn.expand("~/.config/codespell.ignore_words"),
        "--stdin-single-line",
        "-",
      }
      markdownlint_linter.args = {
        "--disable",
        "MD013",
      }
      lint.linters_by_ft = {
        ansible = { "ansible_lint", "codespell" },
        asciidoc = { "codespell" },
        gitcommit = { "gitlint" },
        html = { "codespell" },
        jinja = { "codespell", "curlylint" },
        json = { "codespell" },
        lua = { "codespell" },
        markdown = { "codespell", "markdownlint" },
        terraform = { "codespell" },
        python = { "codespell" },
        zsh = { "zsh" },
      }
      local lint_augroup = vim.api.nvim_create_augroup("nvim-lint", { clear = true })
      local events = { "BufReadPost", "BufWritePost", "InsertLeave" }
      vim.api.nvim_create_autocmd(events, {
        group = lint_augroup,
        callback = function()
          lint.try_lint()
        end,
      })
      vim.keymap.set("n", "<leader>ll", function()
        lint.try_lint()
      end, { desc = "Trigger linting for current file" })
    end,
  },
}
