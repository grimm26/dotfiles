augroup packer_user_config
  autocmd!
  autocmd BufWritePost plugins.lua source <afile> | PackerCompile
augroup end
lua require('plugins')
lua require('config_plugins')
silent! helptags ALL
command! PU PackerSync | source $MYVIMRC
if executable('ugrep')
    set grepprg=ugrep\ -RInk\ -j\ -u\ --tabs=1\ --ignore-files
    set grepformat=%f:%l:%c:%m,%f+%l+%c+%m,%-G%f\\\|%l\\\|%c\\\|%m
endif
" Set up persistent undo across all files.
set undofile

set updatetime=100
syntax enable
set autoread
" filename completion for multiple files
set wildmenu
set wildmode=list:longest

" mapleader is backslash \\
" maps for telescope
nnoremap <leader>ff <cmd>lua require('telescope.builtin').find_files()<cr>
nnoremap <leader>fg <cmd>lua require('telescope.builtin').live_grep()<cr>
nnoremap <leader>fb <cmd>lua require('telescope.builtin').buffers()<cr>
nnoremap <leader>fh <cmd>lua require('telescope.builtin').help_tags()<cr>
" Base utility mappings
nnoremap <leader>ev :vsplit $MYVIMRC<cr>
nnoremap <leader>sv :source $MYVIMRC<cr>
" surround word cursor is on in double quotes
nnoremap <leader>" viw<esc>a"<esc>bi"<esc>lel
" surround word cursor is on in single quotes
nnoremap <leader>' viw<esc>a'<esc>bi'<esc>lel
" surround visually selected block in double quotes
vnoremap <leader>v" <esc>`>a"<esc>`<i"<esc>lel
" surround visually selected block in single quotes
vnoremap <leader>v' <esc>`>a'<esc>`<i'<esc>lel
" help my common typos
iabbrev adn and
iabbrev teh the
iabbrev taht that
iabbrev endopint endpoint
iabbrev chanegs changes
iabbrev updaet update
" :W sudo saves the file
" (useful for handling the permission-denied error)
command! W w !sudo tee % > /dev/null

" Show matching brackets when text indicator is over them
set showmatch
" How many tenths of a second to blink when matching brackets
set mat=2

set tm=500

" Use Unix as the standard file type
set ffs=unix,dos,mac

set modeline modelines=5    " use settings from file being edited
set writebackup
set swapfile
" yes, I hate highlight search
set nohlsearch
"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" => Text, tab and indent related
"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" Use spaces instead of tabs, as the Lord intended.
set expandtab
" Be smart when using tabs ;)
set smarttab
" 1 tab == 2 spaces
set shiftwidth=2
set tabstop=2
set softtabstop=2
set ai "Auto indent
set si "Smart indent

" I'm not a fan of folding in general so I disable it.
set foldcolumn=0
set nofoldenable

set guifont=Monaco:h14
if has('termguicolors')
  set termguicolors
endif
set background=dark
colorscheme solarized-high
" show me where my cursor is
set cursorline cursorcolumn

" caSe MaTtERs, people!
set noignorecase
set nosmartcase
""""""""""""""""""""""""""""""
" => Status line
""""""""""""""""""""""""""""""
" Always show the status line
set laststatus=2
let g:airline#extensions#tabline#formatter = 'unique_tail'

map <leader>pp :setlocal paste!<cr>
"
" Returns true if paste mode is enabled
function! HasPaste()
    if &paste
        return 'PASTE MODE  '
    en
    return ''
endfunction

map <leader>nn :NvimTreeToggle<cr>
autocmd StdinReadPre * let s:std_in=1
" Start NvimTree when Vim is started without file arguments.
" autocmd VimEnter * if argc() == 0 && !exists('s:std_in') | NvimTree | endif
" Start NvimTree when Vim starts with a directory argument.
autocmd VimEnter * if argc() == 1 && isdirectory(argv()[0]) && !exists('s:std_in') |
    \ execute 'NvimTreeOpen' argv()[0] | endif

"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" => vim-airline config (force color)
"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
let g:airline_theme="base16_solarized"
let g:airline_solarized_bg='dark'
let g:airline_powerline_fonts = 1
"let g:airline_theme="luna"

" Syntastic Settings
" statusline stuff
set statusline+=%#warningmsg#
set statusline+=%{SyntasticStatuslineFlag()}
set statusline+=%*
" Check my syntax
let g:syntastic_always_populate_loc_list = 1
let g:syntastic_auto_loc_list = 2
let g:syntastic_check_on_open = 1
"let g:syntastic_debug = 3
"let g:syntastic_debug_file = "~/syntastic.log"
" Don't check it on write because that gets annoying
let g:syntastic_check_on_wq = 0
" python stuff
let g:syntastic_python_checkers=['flake8']
"" Commented out the pylint/flake8 options below in order to allow them to be
"" set per project.
" I don't care about long lines
" let g:syntastic_python_flake8_args = "--extend-ignore E501"
" I don't care about long lines and duplicates of what flake8 does
"let g:syntastic_python_pylint_args = "--disable=C0301,undefined-variable,unused-import,unused-variable"
" end syntastic
let g:vim_json_syntax_conceal = 0
" do good terraform stuff
let g:terraform_fmt_on_save = 1
let g:terraform_align = 1

" shfmt options
let g:shfmt_extra_args = '-i 2 -bn -ci'
let g:shfmt_fmt_on_save = 1

let g:TerminusMouse=0
" highlight trailing spaces
highlight ExtraWhitespace ctermbg=red guibg=red
match ExtraWhitespace /\s\+$/
autocmd BufWinEnter * match ExtraWhitespace /\s\+$/
autocmd InsertEnter * match ExtraWhitespace /\s\+\%#\@<!$/
autocmd InsertLeave * match ExtraWhitespace /\s\+$/
autocmd BufWinLeave * call clearmatches()
" spelling
" turn off vim builtin spelling, cuz we using spelunker
set nospell
" Enable spelunker.vim. (default: 1)
" 1: enable
" 0: disable
let g:enable_spelunker_vim = 0

" Enable spelunker.vim on readonly files or buffer. (default: 0)
" 1: enable
" 0: disable
let g:enable_spelunker_vim_on_readonly = 0

" Check spelling for words longer than set characters. (default: 4)
let g:spelunker_target_min_char_len = 4

" Max amount of word suggestions. (default: 15)
let g:spelunker_max_suggest_words = 15

" Max amount of highlighted words in buffer. (default: 100)
let g:spelunker_max_hi_words_each_buf = 100

" Spellcheck type: (default: 1)
" 1: File is checked for spelling mistakes when opening and saving. This
" may take a bit of time on large files.
" 2: Spellcheck displayed words in buffer. Fast and dynamic. The waiting time
" depends on the setting of CursorHold `set updatetime=1000`.
let g:spelunker_check_type = 2

" Option to disable word checking.
" Disable URI checking. (default: 0)
let g:spelunker_disable_uri_checking = 1

" Disable email-like words checking. (default: 0)
let g:spelunker_disable_email_checking = 1

" Disable account name checking, e.g. @foobar, foobar@. (default: 0)
" NOTE: Spell checking is also disabled for JAVA annotations.
let g:spelunker_disable_account_name_checking = 1

" Disable acronym checking. (default: 0)
let g:spelunker_disable_acronym_checking = 1

" Disable checking words in backtick/backquote. (default: 0)
let g:spelunker_disable_backquoted_checking = 1

" Disable default autogroup. (default: 0)
let g:spelunker_disable_auto_group = 0
" Override highlight setting.
" highlight SpelunkerSpellBad cterm=underline ctermfg=247 gui=underline guifg=#9e9e9e
" highlight SpelunkerComplexOrCompoundWord cterm=underline ctermfg=NONE gui=underline guifg=NONE
let g:spelunker_white_list_for_user = ['kamykn', 'vimrc', 'keisler', 'syntastic', 'solarized', 'powerline', 'shfmt']
