local cmd = vim.cmd  -- to execute Vim commands e.g. cmd('pwd')
local fn = vim.fn    -- to call Vim functions e.g. fn.bufnr()
local g = vim.g      -- a table to access global variables (let g:something = foo)
local set = vim.opt  -- to set options

g.mapleader = ' '
require('helpers')
cmd([[
augroup packer_user_config
  autocmd!
  autocmd BufWritePost plugins.lua source <afile> | PackerCompile
augroup end
]])
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
set.expandtab=true
set.shiftwidth=2
set.tabstop=2
set.softtabstop=2
set.ai=true --Auto indent
set.si=true --Smart indent
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
-- airline theme
g['airline#extensions#tabline#formatter'] = 'unique_tail'
g.airline_theme="base16_solarized"
g.airline_solarized_bg='dark'
g.airline_powerline_fonts = 1
--
g.vim_json_syntax_conceal = 0
-- highlight trailing spaces
cmd([[
highlight ExtraWhitespace ctermbg=red guibg=red
match ExtraWhitespace /\s\+$/
autocmd BufWinEnter * match ExtraWhitespace /\s\+$/
autocmd InsertEnter * match ExtraWhitespace /\s\+\%#\@<!$/
autocmd InsertLeave * match ExtraWhitespace /\s\+$/
autocmd BufWinLeave * call clearmatches()
]])
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
