local cmd = vim.cmd  -- to execute Vim commands e.g. cmd('pwd')
local fn = vim.fn    -- to call Vim functions e.g. fn.bufnr()
local g = vim.g      -- a table to access global variables (let g:something = foo)
local set = vim.opt  -- to set options

require('mini.comment').setup({})
require('mini.completion').setup({})
require('mini.indentscope').setup({})
require('mini.surround').setup({})
require('mini.trailspace').setup({})
require('mini.pairs').setup({})
require('gitsigns').setup()
require('telescope').load_extension('fzf')
require('nvim-tree').setup()
-- Most of the lualine config is default, just had it here to show what can be tweaked.
require('lualine').setup {
  options = {
    icons_enabled = true,
    theme = 'powerline_dark',
    component_separators = { left = '', right = ''},
    section_separators = { left = '', right = ''},
    disabled_filetypes = {},
    always_divide_middle = true,
    globalstatus = false,
  },
  sections = {
    lualine_a = {'mode'},
    lualine_b = {'branch', 'diff', 'diagnostics'},
    lualine_c = {'filename'},
    lualine_x = {'encoding', 'fileformat', 'filetype'},
    lualine_y = {'progress'},
    lualine_z = {'location'}
  },
  inactive_sections = {
    lualine_a = {},
    lualine_b = {},
    lualine_c = {'filename'},
    lualine_x = {'location'},
    lualine_y = {},
    lualine_z = {}
  },
  tabline = {},
  extensions = {}
}

-- trim EOL whitespace
nmap('<leader>ts', "<cmd>lua MiniTrailspace.trim()<cr>")

local lsp_servers = {
  'pyright',
  'terraformls',
  'tflint',
}
for _, lsp in ipairs(lsp_servers) do
  require('lspconfig')[lsp].setup {
    --on_attach = on_attach,
    --handlers = handlers,
  }
end
--[[
require'lspconfig'.pyright.setup{}
require'lspconfig'.terraformls.setup{}
require'lspconfig'.tflint.setup{}
]]--

local ts = require 'nvim-treesitter.configs'
ts.setup {
  ensure_installed = {
    'bash',
    'c',
    'comment',
    'dockerfile',
    'go',
    'gomod',
    'hcl',
    'html',
    'java',
    'javascript',
    'json',
    'json5',
    'lua',
    'make',
    'nix',
    'perl',
    'php',
    'regex',
    'python',
    'ruby',
    'rust',
    'toml',
    'typescript',
    'vim',
    'vue',
    'yaml'
  },
  highlight = {enable = true}
}

-- maps for telescope
nmap('<leader>ff',"<cmd>lua require('telescope.builtin').find_files()<cr>")
nmap('<leader>fg',"<cmd>lua require('telescope.builtin').live_grep()<cr>")
nmap('<leader>fb',"<cmd>lua require('telescope.builtin').buffers()<cr>")
nmap('<leader>fh',"<cmd>lua require('telescope.builtin').help_tags()<cr>")
nmap('<leader>fgf',"<cmd>lua require('telescope.builtin').git_files()<cr>")
nmap('<leader>fgc',"<cmd>lua require('telescope.builtin').git_commits()<cr>")
map('','<C-n>',':NvimTreeToggle<cr>')
-- do good terraform stuff
g.terraform_fmt_on_save = 1
g.terraform_align = 1
-- shfmt options
g.shfmt_extra_args = '-i 2 -bn -ci'
g.shfmt_fmt_on_save = 1
-- spelling
-- turn off vim builtin spelling, cuz we using spelunker
set.spell=false
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
g.spelunker_white_list_for_user = {'kamykn', 'vimrc', 'keisler', 'syntastic', 'solarized', 'powerline', 'shfmt'}
