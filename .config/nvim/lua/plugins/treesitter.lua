return {
  {
    "nvim-treesitter/nvim-treesitter",
    version = false, -- last release is way too old and doesn't work on Windows
    build = ":TSUpdate",
    event = { "BufReadPost", "BufNewFile" },
    keys = {
      { "<c-space>", desc = "Increment selection" },
      { "<bs>", desc = "Schrink selection", mode = "x" },
    },
    ---@type TSConfig
    opts = {
      highlight = { enable = true },
      indent = { enable = true },
      context_commentstring = { enable = true, enable_autocmd = false },
      ensure_installed = {
        "bash",
        "c",
        "comment",
        "dockerfile",
        "go",
        "gomod",
        "hcl",
        "html",
        "java",
        "help",
        "html",
        "javascript",
        "json",
        "json5",
        "lua",
        "markdown",
        "markdown_inline",
        "perl",
        "php",
        "python",
        "query",
        "regex",
        "ruby",
        "rust",
        "terraform",
        "toml",
        "vim",
        "yaml",
      },
      ignore_install = {
        "agda",
        "beancount",
        "c_sharp",
        "clojure",
        "cooklang",
        "cuda",
        "d",
        "dart",
        "dot",
        "elvish",
        "erlang", -- broken, 2022-12-11
        "gleam",
        "glimmer",
        "hack",
        "haskell",
        "heex",
        "kotlin",
        "ocaml",
        "ocaml_interface",
        "pascal",
        "pioasm",
        "pug",
        "scala",
        "supercollider",
        "vala",
      },
      incremental_selection = {
        enable = true,
        keymaps = {
          init_selection = "<C-space>",
          node_incremental = "<C-space>",
          scope_incremental = "<nop>",
          node_decremental = "<bs>",
        },
      },
    },
    ---@param opts TSConfig
    config = function(_, opts)
      require("nvim-treesitter.configs").setup(opts)
    end,
  },
}