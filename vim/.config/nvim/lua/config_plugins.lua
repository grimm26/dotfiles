local cmd = vim.cmd -- to execute Vim commands e.g. cmd('pwd')
local g = vim.g -- a table to access global variables (let g:something = foo)
local set = vim.opt -- to set options

require("mini.comment").setup({})
require("mini.completion").setup({})
require("mini.indentscope").setup({})
require("mini.surround").setup({})
require("mini.trailspace").setup({})
require("mini.pairs").setup({})
require("gitsigns").setup({
    diff_opts = {
        internal = true
    }
})
require("telescope").load_extension("fzf")
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
    {"<leader>find", require('telescope.builtin').find_files, description = "Find Files"},
    {"<leader>grep", require('telescope.builtin').live_grep, description = "Grep files"},
    {"<leader>fbuf", require('telescope.builtin').buffers, description = "List buffers"},
    {"<leader>help", require('telescope.builtin').help_tags, description = "List help tags"},
    {"<leader>gitfiles", require('telescope.builtin').git_files, description = "List files under Git control"},
    {"<leader>commits", require('telescope.builtin').git_commits, description = "List/Search Git commits"},
    {"<C-n>", ":NvimTreeToggle<cr>", mode = {""}, description = "Toggle nvim-tree"},
  },
  -- Initial commands to bind
  commands = {
    -- your command tables here
  },
  -- Initial augroups and autocmds to bind
  autocmds = {
    -- your autocmd tables here
  },
  -- Automatically add which-key tables to legendary
  -- see "which-key.nvim Integration" below for more details
  auto_register_which_key = true,
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
        "java", "javascript", "json", "json5", "lua", "make", "nix", "perl",
        "php", "regex", "python", "ruby", "rust", "toml", "typescript", "vim",
        "vue", "yaml"
    },
    highlight = {enable = true}
})

-- -- maps for telescope
-- vim.keymap.set("n", "<leader>find", require('telescope.builtin').find_files)
-- vim.keymap.set("n", "<leader>grep", require('telescope.builtin').live_grep)
-- vim.keymap.set("n", "<leader>fbuf", require('telescope.builtin').buffers)
-- vim.keymap.set("n", "<leader>help", require('telescope.builtin').help_tags)
-- vim.keymap.set("n", "<leader>gitfiles", require('telescope.builtin').git_files)
-- vim.keymap.set("n", "<leader>commits", require('telescope.builtin').git_commits)
-- vim.keymap.set("", "<C-n>", ":NvimTreeToggle<cr>")
-- shfmt options
g.shfmt_extra_args = "-i 2 -bn -ci"
g.shfmt_fmt_on_save = 1
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
-- lsop installer
local lsp_installer = require("nvim-lsp-installer")
lsp_installer.settings({
    pip = {
        install_args = {"--user", "--upgrade"}
    }
})

local enhance_server_opts = {
  -- Provide settings that should only apply to the "sumneko_lua" server
  ["sumneko_lua"] = function(opts)
    opts.settings = {
      Lua = {
      runtime = {
        -- Tell the language server which version of Lua you're using (most likely LuaJIT in the case of Neovim)
        version = 'LuaJIT',
        -- Setup your lua path
        -- path = runtime_path,
      },
      diagnostics = {
        -- Get the language server to recognize the `vim` global
        globals = {'vim'},
      },
      workspace = {
        -- Make the server aware of Neovim runtime files
        library = vim.api.nvim_get_runtime_file("", true),
      },
      -- Do not send telemetry data containing a randomized but unique identifier
      telemetry = {
        enable = false,
      },
    }
  }
  end,
}
-- Register a handler that will be called for each installed server when it's ready (i.e. when installation is finished
-- or if the server is already installed).
lsp_installer.on_server_ready(function(server)
    local opts = {}

    -- (optional) Customize the options passed to the server
    -- if server.name == "tsserver" then
    --     opts.root_dir = function() ... end
    -- end

    if enhance_server_opts[server.name] then
      -- Enhance the default opts with the server-specific ones
      enhance_server_opts[server.name](opts)
    end
    -- This setup() function will take the provided server configuration and decorate it with the necessary properties
    -- before passing it onwards to lspconfig.
    -- Refer to https://github.com/neovim/nvim-lspconfig/blob/master/doc/server_configurations.md
    server:setup(opts)
end)

vim.api.nvim_create_autocmd("BufWritePre", {
    callback = vim.lsp.buf.formatting_sync,
    pattern = {"*.tf", "*.tfvars"}
})

-- The below cmp/snip was just copied from https://github.com/nvim-lua/kickstart.nvim/blob/master/init.lua
-- luasnip setup
local luasnip = require("luasnip")
--
-- nvim-cmp setup
local cmp = require("cmp")
cmp.setup({
    snippet = {
        expand = function(args) require("luasnip").lsp_expand(args.body) end
    },
    mapping = {
        ["<C-p>"] = cmp.mapping.select_prev_item(),
        ["<C-n>"] = cmp.mapping.select_next_item(),
        ["<C-d>"] = cmp.mapping.scroll_docs(-4),
        ["<C-f>"] = cmp.mapping.scroll_docs(4),
        ["<C-Space>"] = cmp.mapping.complete(),
        ["<C-e>"] = cmp.mapping.close(),
        ["<CR>"] = cmp.mapping.confirm({
            behavior = cmp.ConfirmBehavior.Replace,
            select = true
        }),
        ["<Tab>"] = function(fallback)
            if cmp.visible() then
                cmp.select_next_item()
            elseif luasnip.expand_or_jumpable() then
                luasnip.expand_or_jump()
            else
                fallback()
            end
        end,
        ["<S-Tab>"] = function(fallback)
            if cmp.visible() then
                cmp.select_prev_item()
            elseif luasnip.jumpable(-1) then
                luasnip.jump(-1)
            else
                fallback()
            end
        end
    },
    sources = {{name = "nvim_lsp"}, {name = "luasnip"}}
})

-- vim: ts=2 sts=2 sw=2 et
