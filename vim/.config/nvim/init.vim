set runtimepath^=~/.vim runtimepath+=~/.vim/after
let &packpath = &runtimepath
source ~/.vimrc
lua require('mini.comment').setup({})
lua require('gitsigns').setup()
