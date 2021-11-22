" https://catonmat.net/vim-plugins-matchit-vim
runtime macros/matchit.vim
if isdirectory(expand("$HOME/.fzf"))
  set rtp+=~/.fzf
elseif isdirectory("/usr/local/opt/fzf")
  set rtp+=/usr/local/opt/fzf
endif
"set shell=/usr/local/bin/zsh
"au BufNewFile,BufRead /dev/shm/gopass.* setlocal noswapfile nobackup noundofile

" Set up persistent undo across all files.
set undofile
if !isdirectory(expand("$HOME/.vim/undodir"))
  call mkdir(expand("$HOME/.vim/undodir"), "p")
endif
set undodir=$HOME/.vim/undodir

set updatetime=100
" Turn on syntax highlighting
syntax on
syntax enable
" Enable filetype plugins
filetype plugin indent on
" Set to auto read when a file is changed from the outside
" I think this tends to give false alarms or something, though.
set autoread
" filename completion for multiple files
set wildmenu
set wildmode=list:longest

" With a map leader it's possible to do extra key combinations
let mapleader = "\\"
let g:mapleader = "\\"
" :W sudo saves the file
" (useful for handling the permission-denied error)
command! W w !sudo tee % > /dev/null

"Always show current position
set ruler

" Show matching brackets when text indicator is over them
set showmatch
" How many tenths of a second to blink when matching brackets
set mat=2

" No annoying sound on errors
set noerrorbells
set novisualbell
set t_vb=
set tm=500
" Set utf8 as standard encoding and en_US as the standard language
set encoding=utf8

" Use Unix as the standard file type
set ffs=unix,dos,mac

set modeline modelines=5    " use settings from file being edited
set writebackup
set swapfile
if !isdirectory(expand("$HOME/.vim/swap"))
  call mkdir(expand("$HOME/.vim/swap"), "p")
endif
set directory=$HOME/.vim/swap//
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
set termguicolors
set background=dark
set t_Co=256
"option name default optional
"------------------------------------------------
"g:solarized_termcolors= 16 | 256
"g:solarized_termtrans = 0 | 1
"g:solarized_degrade = 0 | 1
"g:solarized_bold = 1 | 0
"g:solarized_underline = 1 | 0
"g:solarized_italic = 1 | 0
"g:solarized_contrast = "normal"| "high" or "low"
"g:solarized_visibility= "normal"| "high" or "low"
"------------------------------------------------
"g:solarized_termcolors= 16 | 256
colorscheme solarized8
"colorscheme solarized

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

" Format the status line
"set statusline=\ %{HasPaste()}%F%m%r%h\ %w\ \ CWD:\ %r%{getcwd()}%h\ \ \ Line:\ %l
"
" Move a line of text using ALT+[jk] or Comamnd+[jk] on mac
"nmap <M-j> mz:m+<cr>`z
"nmap <M-k> mz:m-2<cr>`z
"vmap <M-j> :m'>+<cr>`<my`>mzgv`yo`z
"vmap <M-k> :m'<-2<cr>`>my`<mzgv`yo`z

"if has("mac") || has("macunix")
  "nmap <D-j> <M-j>
  "nmap <D-k> <M-k>
  "vmap <D-j> <M-j>
  "vmap <D-k> <M-k>
"endif
" Toggle paste mode on and off
map <leader>pp :setlocal paste!<cr>
"
" Returns true if paste mode is enabled
function! HasPaste()
    if &paste
        return 'PASTE MODE  '
    en
    return ''
endfunction
"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" => Nerd Tree
"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
map <leader>nn :NERDTreeToggle<cr>
map <leader>nb :NERDTreeFromBookmark
map <leader>nf :NERDTreeFind<cr>
autocmd StdinReadPre * let s:std_in=1
" Start NERDTree when Vim is started without file arguments.
autocmd VimEnter * if argc() == 0 && !exists('s:std_in') | NERDTree | endif
" Start NERDTree when Vim starts with a directory argument.
autocmd VimEnter * if argc() == 1 && isdirectory(argv()[0]) && !exists('s:std_in') |
    \ execute 'NERDTree' argv()[0] | wincmd p | enew | execute 'cd '.argv()[0] | wincmd p | endif

"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" => vim-airline config (force color)
"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
let g:airline_theme="solarized"
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
" end syntastic
"autocmd BufNewFile,BufRead *.template set ft=json
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
"
" python stuff
let g:syntastic_python_checkers=['flake8'] ", 'pylint']
" I don't care about long lines
let g:syntastic_python_flake8_args = "--ignore E501"
" I don't care about long lines and duplicates of what flake8 does
let g:syntastic_python_pylint_args = "--disable=C0301,undefined-variable,unused-import,unused-variable"

" spelling
autocmd FileType Markdown set spell spelllang=en_us
map <leader>sp :set spell spelllang=en_us<cr>

packloadall
silent! helptags ALL
