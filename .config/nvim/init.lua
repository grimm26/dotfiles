local cmd = vim.cmd -- to execute Vim commands e.g. cmd('pwd')
local fn = vim.fn -- to call Vim functions e.g. fn.bufnr()
local g = vim.g -- a table to access global variables (let g:something = foo)
local set = vim.opt -- to set options

-- Install packer
local install_path = fn.stdpath("data") .. "/site/pack/packer/start/packer.nvim"

if fn.empty(vim.fn.glob(install_path)) > 0 then
  fn.execute("!git clone https://github.com/wbthomason/packer.nvim " .. install_path)
end
-- Remap space as leader key
vim.keymap.set({ "n", "v" }, "<Space>", "<Nop>", { silent = true })
g.mapleader = " "
g.maplocalleader = " "
vim.lsp.set_log_level("error")
if fn.has("termguicolors") == 1 then
  set.termguicolors = true
end
set.completeopt = { "menu", "menuone", "noselect" }
require("lastplace")
require("plugins_load")
require("plugins_config")
require("my_lua_snippets")
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
vim.wo.number = false
-- Enable break indent
set.breakindent = true
set.expandtab = true
set.shiftwidth = 2
set.tabstop = 2
set.softtabstop = 2
vim.bo.autoindent = true -- Auto indent
set.smartindent = true -- Smart indent
set.foldenable = true
set.foldnestmax = 3
set.foldminlines = 3
set.foldmethod = "expr"
set.foldexpr = "nvim_treesitter#foldexpr()"
set.guifont = "Monaco:h14"
-- Use Unix as the standard file type
set.ffs = { "unix", "dos", "mac" }
set.background = "dark"
g.solarized_visibility = "high"
cmd.colorscheme("solarized-high")
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
