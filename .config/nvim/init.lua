local cmd = vim.cmd -- to execute Vim commands e.g. cmd('pwd')
local fn = vim.fn -- to call Vim functions e.g. fn.bufnr()
local g = vim.g -- a table to access global variables (let g:something = foo)
local set = vim.opt -- to set options

-- Install packer
local install_path = fn.stdpath("data") .. "/site/pack/packer/start/packer.nvim"

if fn.empty(vim.fn.glob(install_path)) > 0 then
  fn.execute("!git clone https://github.com/wbthomason/packer.nvim " ..
  install_path)
end
-- Remap space as leader key
-- vim.keymap.set({'n', 'v'}, '<Space>', '<Nop>', {silent = true})
g.mapleader = ' '
g.maplocalleader = ' '
require("lastplace")
require("plugins")
require("config_plugins")
-- Set completeopt to have a better completion experience
vim.o.completeopt = 'menuone,noselect'
set.updatetime = 100
set.undofile = true
-- Show matching brackets when text indicator is over them
set.showmatch = true
set.autoread = true
set.wildmode = {"list", "longest"}
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
-- I'm not a fan of folding in general so I disable it.
set.foldenable = false
set.guifont = "Monaco:h14"
-- Use Unix as the standard file type
set.ffs = {"unix", "dos", "mac"}
if fn.has("termguicolors") == 1 then set.termguicolors = true end
set.background = "dark"
cmd("colorscheme solarized-high")
-- cmd("colorscheme mosel")
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
