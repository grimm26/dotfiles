local cmd = vim.cmd -- to execute Vim commands e.g. cmd('pwd')
local fn = vim.fn -- to call Vim functions e.g. fn.bufnr()
local g = vim.g -- a table to access global variables (let g:something = foo)
local set = vim.opt -- to set options
fd = "fdfind"
if vim.fn.executable("fdfind") == 1 then
  fd = "fdfind"
elseif vim.fn.executable("fd") == 1 then
  fd = "fd"
end

-- load lazy plugin manager
local lazypath = vim.fn.stdpath("data") .. "/lazy/lazy.nvim"
if not vim.loop.fs_stat(lazypath) then
  vim.fn.system({
    "git",
    "clone",
    "--filter=blob:none",
    "https://github.com/folke/lazy.nvim.git",
    "--branch=stable", -- latest stable release
    lazypath,
  })
end
vim.opt.rtp:prepend(lazypath)
-- Remap space as leader key
vim.keymap.set({ "n", "v" }, "<Space>", "<Nop>", { silent = true })
g.mapleader = " "
g.maplocalleader = " "
vim.lsp.set_log_level("off")
if fn.has("termguicolors") == 1 then
  set.termguicolors = true
end
set.completeopt = { "menu", "menuone", "noselect" }
require("lastplace")
require("lazy").setup("plugins")
-- require("plugins_load")
-- require("plugins_config")
-- require("my_lua_snippets")
-- See https://github.com/neovim/neovim/pull/20633, https://github.com/folke/noice.nvim/issues/47
if fn.has("nvim-0.9.0") == 1 then
  set.shortmess:append({ C = true })
  -- cmd("set shortmess+=C")
end
-- don't give "search hit BOTTOM, continuing at TOP" or "search
-- hit TOP, continuing at BOTTOM" messages; when using the search
-- count do not show "W" after the count message (see S below)
set.shortmess:append({ s = true })
set.mouse = ""
-- cmd("behave xterm")
set.spell = false
set.updatetime = 100
set.undofile = true
-- Show matching brackets when text indicator is over them
set.showmatch = true
set.autoread = true
set.wildmode = { "list", "longest" }
-- How many tenths of a second to blink when matching brackets
set.mat = 2
set.timeoutlen = 500
set.modeline = true
set.modelines = 5
set.hlsearch = false
vim.o.number = true
-- Enable break indent
set.breakindent = true
set.expandtab = true
set.shiftwidth = 2
set.tabstop = 2
set.softtabstop = 2
vim.bo.autoindent = true -- Auto indent
set.smartindent = true -- Smart indent
set.foldenable = false
set.foldnestmax = 3
set.foldminlines = 3
set.foldmethod = "expr"
set.foldexpr = "nvim_treesitter#foldexpr()"
set.guifont = "Monaco:h14"
-- Use Unix as the standard file type
set.ffs = { "unix", "dos", "mac" }
set.background = "dark"
g.solarized_visibility = "high"
-- show me where my cursor is
set.cursorline = true
set.cursorcolumn = true
-- caSe MaTtERs, people!
set.ignorecase = false
set.smartcase = false
set.laststatus = 2
--
g.vim_json_syntax_conceal = 0
-- help my common typos
cmd([[
iabbrev adn and
iabbrev teh the
iabbrev taht that
iabbrev endopint endpoint
iabbrev updaet update
]])
-- Set up some keymaps
vim.keymap.set("n", "<leader>num", ":set number!<cr>", { desc = "Toggle line numbers" })
