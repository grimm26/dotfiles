require('mini.comment').setup({})
require('gitsigns').setup()
require('telescope').load_extension('fzf')
require('nvim-tree').setup()
-- maps for telescope
nmap('<leader>ff',"<cmd>lua require('telescope.builtin').find_files()<cr>")
nmap('<leader>fg',"<cmd>lua require('telescope.builtin').live_grep()<cr>")
nmap('<leader>fb',"<cmd>lua require('telescope.builtin').buffers()<cr>")
nmap('<leader>fh',"<cmd>lua require('telescope.builtin').help_tags()<cr>")
