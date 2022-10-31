local cmd = vim.cmd -- to execute Vim commands e.g. cmd('pwd')
local g = vim.g -- a table to access global variables (let g:something = foo)
local set = vim.opt -- to set options

local fd = 'fdfind'
if vim.fn.executable('fdfind') == 1 then
  fd = 'fdfind'
elseif vim.fn.executable('fd') == 1 then
  fd = 'fd'
end

-- Enable modules out of mini,nvim that we want to use
local starter = require('mini.starter')
starter.setup({
  items = {
    starter.sections.telescope(),
  },
  content_hooks = {
    starter.gen_hook.adding_bullet(),
    starter.gen_hook.aligning('center', 'center'),
  },
})
require("mini.align").setup()
require("mini.comment").setup({})
require("mini.completion").setup({})
require("mini.indentscope").setup({})
require("mini.surround").setup({})
require("mini.trailspace").setup({})

require("gitsigns").setup({
  diff_opts = {
    internal = true
  },
  current_line_blame = false,
  current_line_blame_opts = {
    virt_text = true,
    virt_text_pos = 'eol', -- 'eol' | 'overlay' | 'right_align'
    delay = 1000,
    ignore_whitespace = false,
  },
  yadm = {
    enable = true
  },
  on_attach = function(bufnr)
    local gs = package.loaded.gitsigns

    local function map(mode, l, r, opts)
      opts = opts or {}
      opts.buffer = bufnr
      vim.keymap.set(mode, l, r, opts)
    end

    -- Navigation
    map('n', ']c', function()
      if vim.wo.diff then return ']c' end
      vim.schedule(function() gs.next_hunk() end)
      return '<Ignore>'
    end, {expr = true})

    map('n', '[c', function()
      if vim.wo.diff then return '[c' end
      vim.schedule(function() gs.prev_hunk() end)
      return '<Ignore>'
    end, {expr = true})

    -- Actions
    map({'n', 'v'}, '<leader>hs', ':Gitsigns stage_hunk<CR>')
    map({'n', 'v'}, '<leader>hr', ':Gitsigns reset_hunk<CR>')
    map('n', '<leader>hS', gs.stage_buffer)
    map('n', '<leader>hu', gs.undo_stage_hunk)
    map('n', '<leader>hR', gs.reset_buffer)
    map('n', '<leader>hp', gs.preview_hunk)
    map('n', '<leader>hb', function() gs.blame_line {full = true} end)
    map('n', '<leader>tb', gs.toggle_current_line_blame)
    map('n', '<leader>hd', gs.diffthis)
    map('n', '<leader>hD', function() gs.diffthis('~') end)
    map('n', '<leader>td', gs.toggle_deleted)

    -- Text object
    map({'o', 'x'}, 'ih', ':<C-U>Gitsigns select_hunk<CR>')
  end
})
require("telescope").setup {
  pickers = {
    find_files = {
      find_command = {fd, "--type", "f", "--hidden", "--exclude", ".git"},
      mappings = {
        n = {
          ["cd"] = function(prompt_bufnr)
            local selection = require("telescope.actions.state").get_selected_entry()
            local dir = vim.fn.fnamemodify(selection.path, ":p:h")
            require("telescope.actions").close(prompt_bufnr)
            -- Depending on what you want put `cd`, `lcd`, `tcd`
            cmd(string.format("silent lcd %s", dir))
          end
        }
      }
    }
  },
  extensions = {
    file_browser = {
      -- disables netrw and use telescope-file-browser in its place
      hijack_netrw = true,
    },
  }
}
require("telescope").load_extension("fzf")
require("telescope").load_extension("file_browser")
require("nvim-tree").setup()
-- Most of the lualine config is default, just had it here to show what can be tweaked.
local function diff_source()
  local gitsigns = vim.b.gitsigns_status_dict
  if gitsigns then
    return {
      added = gitsigns.added,
      modified = gitsigns.changed,
      removed = gitsigns.removed
    }
  end
end

require("lualine").setup({
  options = {
    icons_enabled = true,
    theme = "powerline_dark",
    component_separators = {left = "", right = ""},
    section_separators = {left = "", right = ""},
    disabled_filetypes = {},
    always_divide_middle = true,
    globalstatus = true
  },
  sections = {
    lualine_a = {"mode"},
    lualine_b = {
      {"b:gitsigns_head", icon = ''}, {"diff", source = diff_source},
      "diagnostics"
    },
    lualine_c = {{"filename", path = 1}},
    lualine_x = {"encoding", "fileformat", "filetype"},
    lualine_y = {"progress"},
    lualine_z = {"location"}
  },
  inactive_sections = {
    lualine_a = {},
    lualine_b = {},
    lualine_c = {{"filename", path = 1}},
    lualine_x = {"location"},
    lualine_y = {},
    lualine_z = {}
  },
  tabline = {},
  extensions = {"nvim-tree"}
})

require('legendary').setup({
  -- Include builtins by default, set to false to disable
  include_builtin = true,
  -- Include the commands that legendary.nvim creates itself
  -- in the legend by default, set to false to disable
  include_legendary_cmds = true,
  -- Customize the prompt that appears on your vim.ui.select() handler
  -- Can be a string or a function that takes the `kind` and returns
  -- a string. See "Item Kinds" below for details. By default,
  -- prompt is 'Legendary' when searching all items,
  -- 'Legendary Keymaps' when searching keymaps,
  -- 'Legendary Commands' when searching commands,
  -- and 'Legendary Autocmds' when searching autocmds.
  select_prompt = nil,
  -- Optionally pass a custom formatter function. This function
  -- receives the item as a parameter and must return a table of
  -- non-nil string values for display. It must return the same
  -- number of values for each item to work correctly.
  -- The values will be used as column values when formatted.
  -- See function `get_default_format_values(item)` in
  -- `lua/legendary/formatter.lua` to see default implementation.
  formatter = nil,
  -- When you trigger an item via legendary.nvim,
  -- show it at the top next time you use legendary.nvim
  most_recent_item_at_top = true,
  -- Initial keymaps to bind
  keymaps = {
    {"<leader>ts", MiniTrailspace.trim, description = "Trim trailing whitespace."},
    {"<leader>fb", require("telescope").extensions.file_browser.file_browser, description = "Browse Files"},
    {"<leader>fd", require('telescope.builtin').find_files, description = "Find Files"},
    {"<leader>fg", require('telescope.builtin').live_grep, description = "Grep files"},
    {"<leader>fbuf", require('telescope.builtin').buffers, description = "List buffers"},
    {"<leader>help", require('telescope.builtin').help_tags, description = "List help tags"},
    {"<leader>gitf", require('telescope.builtin').git_files, description = "List files under Git control"},
    {"<leader>ci", require('telescope.builtin').git_commits, description = "List/Search Git commits"},
    {"<leader>lf", function() vim.lsp.buf.format {async = true} end, description = 'Format buffer with LSP',
      opts = {buffer = true, silent = true, noremap = true}},
    {"<leader>f", ":Format<cr>", description = "Use Formatter to format"},
    {"<leader>num", ":set number!<cr>", description = "Toggle line numbers"},
    -- Base utility mappings
    {"<leader>ev", ":vsplit $MYVIMRC<cr>", description = "Edit vim init"},
    {"<leader>sv", ":source $MYVIMRC<cr>", description = "Read in vim init"},
    -- look into making these open in a new tab
    {"<leader>ep",
      ":vsplit " ..
          vim.fn.stdpath('config') ..
          "/lua/plugins.lua<cr>:vsplit " .. vim.fn.stdpath('config') .. "/lua/config_plugins.lua<cr>",
      description = "Edit vim plugins config"},
    -- Disable mini.indentscope
    {"<leader>mindent", ":lua vim.b.miniindentscope_disable = not vim.b.miniindentscope_disable<cr>",
      description = "Toggle mini.indentscope for this buffer", opts = {buffer = true, silent = true, noremap = true}},
  },
  -- Initial commands to bind
  commands = {
    {":PU", ":PackerSync", description = "Packer Sync"},
    {":TgPlan", function()
      require('FTerm').scratch({cmd = {"terragrunt", "plan"}})
    end, {bang = true}, description = "Run terragrunt plan"}
  },
  -- Initial augroups and autocmds to bind
  autocmds = {
    {
      name = 'Formatter',
      {
        "BufWritePost",
        ":FormatWriteLock",
        opts = {
          pattern = {"*.json", "*.go"},
        }
      }
    },
  },

  -- Automatically add which-key tables to legendary
  -- see "which-key.nvim Integration" below for more details
  auto_register_which_key = false,
  -- settings for the :LegendaryScratch command
  scratchpad = {
    -- configure how to show results of evaluated Lua code,
    -- either 'print' or 'float'
    -- Pressing q or <ESC> will close the float
    display_results = 'float',
  },
})

local ts = require("nvim-treesitter.configs")
ts.setup({
  ensure_installed = {
    "bash", "c", "comment", "dockerfile", "go", "gomod", "hcl", "html",
    "java", "javascript", "json", "json5", "lua", "make", "markdown", "markdown_inline", "perl",
    "php", "regex", "python", "ruby", "rust", "toml", "typescript", "vim",
    "vue", "yaml"
  },
  ignore_install = {
    "c_sharp",
    "clojure",
    "cooklang",
    "cuda",
    "elvish",
    "gleam",
    "glimmer",
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
  highlight = {enable = true}
})

-- spelling
-- turn off vim builtin spelling, cuz we using spelunker
set.spell = false
-- Enable spelunker.vim. (default: 1)
-- 1: enable
-- 0: disable
g.enable_spelunker_vim = 0

-- Enable spelunker.vim on readonly files or buffer. (default: 0)
-- 1: enable
-- 0: disable
g.enable_spelunker_vim_on_readonly = 0

-- Check spelling for words longer than set characters. (default: 4)
g.spelunker_target_min_char_len = 4

-- Max amount of word suggestions. (default: 15)
g.spelunker_max_suggest_words = 15

-- Max amount of highlighted words in buffer. (default: 100)
g.spelunker_max_hi_words_each_buf = 100

-- Spellcheck type: (default: 1)
-- 1: File is checked for spelling mistakes when opening and saving. This
-- may take a bit of time on large files.
-- 2: Spellcheck displayed words in buffer. Fast and dynamic. The waiting time
-- depends on the setting of CursorHold `set updatetime=1000`.
g.spelunker_check_type = 2

-- Option to disable word checking.
-- Disable URI checking. (default: 0)
g.spelunker_disable_uri_checking = 1

-- Disable email-like words checking. (default: 0)
g.spelunker_disable_email_checking = 1

-- Disable account name checking, e.g. @foobar, foobar@. (default: 0)
-- NOTE: Spell checking is also disabled for JAVA annotations.
g.spelunker_disable_account_name_checking = 1

-- Disable acronym checking. (default: 0)
g.spelunker_disable_acronym_checking = 1

-- Disable checking words in backtick/backquote. (default: 0)
g.spelunker_disable_backquoted_checking = 1

-- Disable default autogroup. (default: 0)
g.spelunker_disable_auto_group = 0
-- Override highlight setting.
-- highlight SpelunkerSpellBad cterm=underline ctermfg=247 gui=underline guifg=#9e9e9e
-- highlight SpelunkerComplexOrCompoundWord cterm=underline ctermfg=NONE gui=underline guifg=NONE
g.spelunker_white_list_for_user = {
  "kamykn", "vimrc", "keisler", "syntastic", "solarized", "powerline", "shfmt"
}

-- LSP settings
require("mason").setup({
  -- automatic_installation = true,
  pip = {
    install_args = {"--upgrade"}
  }
})

require("mason-tool-installer").setup({
  -- a list of all tools you want to ensure are installed upon
  -- start; they should be the names Mason uses for each tool
  ensure_installed = {
    "bash-language-server",
    "black",
    "dockerfile-language-server",
    "gopls",
    "json-lsp",
    "jsonlint",
    "lua-language-server",
    "marksman",
    "prettier",
    "python-lsp-server",
    "shfmt",
    "isort",
    "solargraph",
    "terraform-ls",
    "vim-language-server",
    "yaml-language-server",
  },

  -- if set to true this will check each tool for updates. If updates
  -- are available the tool will be updated.
  -- Default: false
  auto_update = true,

  -- automatically install / update on startup. If set to false nothing
  -- will happen on startup. You can use `:MasonToolsUpdate` to install
  -- tools and check for updates.
  -- Default: true
  run_on_start = true
})

local lua_runtime_path = vim.split(package.path, ';')
table.insert(lua_runtime_path, "lua/?.lua")
table.insert(lua_runtime_path, "lua/?/init.lua")
table.insert(lua_runtime_path, vim.fn.stdpath('config') .. "lua/?.lua")

require("mason-lspconfig").setup()
local lspconfig = require('lspconfig')
lspconfig.ansiblels.setup {}
lspconfig.bashls.setup {}
lspconfig.dockerls.setup {}
lspconfig.gopls.setup {}
lspconfig.jsonls.setup {}
lspconfig.solargraph.setup {}
lspconfig.marksman.setup {}
lspconfig.terraformls.setup {}
lspconfig.vimls.setup {}
lspconfig.pylsp.setup {
  -- https://github.com/williamboman/nvim-lsp-installer/blob/main/lua/nvim-lsp-installer/servers/pylsp/README.md
  -- Install pylsp plugins with :PylspInstall pyls-flake8 pyls-isort python-lsp-black
  settings = {
    pylsp = {
      configurationSources = {"flake8"},
      plugins = {
        black = {
          enabled = true
        },
        -- Use flake8 instead of pycodestyle,pyflakes,mccabe
        flake8 = {
          enabled = true
        },
        pycodestyle = {
          enabled = false
        },
        pyflakes = {
          enabled = false
        },
        mccabe = {
          enabled = false
        },
      }
    }
  }
}
lspconfig.yamlls.setup {
  settings = {
    ["yaml"] = {
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
}

-- Provide settings that should only apply to the "sumneko_lua" server
lspconfig.sumneko_lua.setup({
  settings = {
    Lua = {
      runtime = {
        -- Tell the language server which version of Lua you're using (most likely LuaJIT in the case of Neovim)
        version = 'LuaJIT',
        -- Setup your lua path
        path = lua_runtime_path,
      },
      format = {
        enable = true,
        defaultConfig = {
          keep_one_space_between_table_and_bracket = "false",
        }
      },
      diagnostics = {
        -- Get the language server to recognize the `vim` global
        globals = {'vim'},
        ["codestyle-check"] = "Any",
      },
      -- This makes loading the lua lsp much slower. I generally don't need it.
      -- workspace = {
      --   -- Make the server aware of Neovim runtime files
      --   library = vim.api.nvim_get_runtime_file("", true),
      -- },
      -- Do not send telemetry data containing a randomized but unique identifier
      telemetry = {
        enable = false,
      },
    },
  }
})

-- formatter plugin
-- Utilities for creating configurations
local formatter_util = require "formatter.util"

-- Provides the Format and FormatWrite commands
require("formatter").setup {
  -- Enable or disable logging
  logging = true,
  -- Set the log level
  log_level = vim.log.levels.WARN,
  -- All formatter configurations are opt-in
  filetype = {
    -- Formatter configurations for filetype "go" go here
    -- and will be executed in order
    go = {
      -- "formatter.filetypes.go" defines default configurations for the
      -- "go" filetype
      require("formatter.filetypes.go").gofmt,
    },
    json = {
      require("formatter.filetypes.json").jq,
    },
    sh = {
      function()
        return {
          exe = "shfmt",
          args = {"-i", "2", "-bn", "-ci", "-s"},
          stdin = true,
        }
      end
    },
    terraform = {
      function()
        return {
          exe = "terraform",
          args = {
            "fmt", "-",
          },
          stdin = true,
        }
      end
    },
    -- Use the special "*" filetype for defining formatter configurations on
    -- any filetype
    ["*"] = {
      -- "formatter.filetypes.any" defines default configurations for any
      -- filetype
      require("formatter.filetypes.any").remove_trailing_whitespace
    }
  }
}

require("octo").setup({
  github_hostname = vim.env.GH_HOST; -- GitHub Enterprise host (if set)
})

-- hashivim/terraform
g.terraform_fmt_on_save = 1

-- vim: ts=2 sts=2 sw=2 et
