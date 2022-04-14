local cmd = vim.cmd  -- to execute Vim commands e.g. cmd('pwd')
local fn = vim.fn    -- to call Vim functions e.g. fn.bufnr()
local g = vim.g      -- a table to access global variables (let g:something = foo)
local set = vim.opt  -- to set options

-- Install packer
local install_path = vim.fn.stdpath 'data' .. '/site/pack/packer/start/packer.nvim'

if vim.fn.empty(vim.fn.glob(install_path)) > 0 then
  vim.fn.execute('!git clone https://github.com/wbthomason/packer.nvim ' .. install_path)
end
g.mapleader = ' '
require('helpers')
require('lastplace')
require('plugins')
require('config_plugins')
cmd 'silent! helptags ALL'
cmd 'command! PU PackerSync'
cmd 'syntax enable'
-- :W sudo saves the file
-- (useful for handling the permission-denied error)
cmd 'command! W w !sudo tee % > /dev/null'
set.updatetime = 100
set.undofile = true
--Show matching brackets when text indicator is over them
set.showmatch = true
set.autoread = true
set.wildmode = {'list', 'longest'}
g.TerminusMouse=0
-- How many tenths of a second to blink when matching brackets
set.mat=2
set.tm=500
set.modeline=true
set.modelines=5
set.hlsearch=false
--Make line numbers default
vim.wo.number = false
nmap('<leader>num','<cmd>:set number!<cr>')
--Enable break indent
set.breakindent = true
set.expandtab=true
set.shiftwidth=2
set.tabstop=2
set.softtabstop=2
vim.bo.autoindent=true --Auto indent
set.smartindent=true --Smart indent
-- I'm not a fan of folding in general so I disable it.
set.foldenable=false
set.guifont='Monaco:h14'
-- Use Unix as the standard file type
set.ffs={'unix','dos','mac'}
if vim.fn.has('termguicolors') == 1 then
  set.termguicolors = true
end
set.background="dark"
cmd 'colorscheme solarized-high'
-- show me where my cursor is
set.cursorline=true
set.cursorcolumn=true
-- caSe MaTtERs, people!
set.ignorecase=false
set.smartcase=false
set.laststatus=2
--
g.vim_json_syntax_conceal = 0
-- Base utility mappings
nmap('<leader>ev','<cmd>vsplit $MYVIMRC<cr>')
nmap('<leader>sv','<cmd>source $MYVIMRC<cr>')
-- surround word cursor is on in double quotes
nmap('<leader>"','viw<esc>a"<esc>bi"<esc>lel')
-- surround word cursor is on in single quotes
nmap("<leader>'","viw<esc>a'<esc>bi'<esc>lel")
-- help my common typos
cmd([[
iabbrev adn and
iabbrev teh the
iabbrev taht that
iabbrev endopint endpoint
iabbrev updaet update
]])
