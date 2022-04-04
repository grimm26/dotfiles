" Things needed pre-plugin load
if isdirectory(expand("$HOME/.fzf"))
  set rtp+=~/.fzf
elseif isdirectory("/usr/local/opt/fzf")
  set rtp+=/usr/local/opt/fzf
endif
"" Plugin stuff
" Install vim-plug if it isn't here.
let data_dir = has('nvim') ? stdpath('data') . '/site' : '~/.vim'
if empty(glob(data_dir . '/autoload/plug.vim'))
  silent execute '!curl -fLo '.data_dir.'/autoload/plug.vim --create-dirs  https://raw.githubusercontent.com/junegunn/vim-plug/master/plug.vim'
  autocmd VimEnter * PlugInstall --sync | source $MYVIMRC
endif
" Start loading plugins
call plug#begin()
if has('nvim')
  " nvim specific plugins
  Plug 'averms/black-nvim', {'do': ':UpdateRemotePlugins'}
  Plug 'stsewd/isort.nvim', {'do': ':UpdateRemotePlugins'}
else
  " vim plugins instead of the nvim specific ones
  Plug 'psf/black'
  Plug 'fisadev/vim-isort'
endif
Plug 'lifepillar/vim-solarized8'
Plug 'tpope/vim-commentary'
Plug 'preservim/nerdtree'
Plug 'tpope/vim-surround'
Plug 'vim-syntastic/syntastic'
Plug 'vim-airline/vim-airline'
Plug 'vim-airline/vim-airline-themes'
Plug 'will133/vim-dirdiff'
Plug 'tpope/vim-endwise'
Plug 'tpope/vim-fugitive'
Plug 'fatih/vim-go'
Plug 'elzr/vim-json'
Plug 'dietsche/vim-lastplace'
Plug 'hashivim/vim-terraform'
Plug 'tmux-plugins/vim-tmux'
Plug 'airblade/vim-gitgutter'
Plug 'wincent/terminus'
Plug 'plasticboy/vim-markdown'
Plug 'z0mbix/vim-shfmt'
Plug 'junegunn/fzf.vim'
Plug 'prettier/vim-prettier'
call plug#end()
silent! helptags ALL
" Run PlugInstall if there are missing plugins
autocmd VimEnter * if len(filter(values(g:plugs), '!isdirectory(v:val.dir)'))
  \| PlugInstall --sync | source $MYVIMRC
\| endif

"" General config
command! PU PlugUpdate | PlugUpgrade
command! PI PlugInstall --sync | source $MYVIMRC
" Set up persistent undo across all files.
set undofile
if has('nvim')
  if !isdirectory(expand("$HOME/.vim/undodir-nvim"))
    call mkdir(expand("$HOME/.vim/undodir-nvim"), "p")
  endif
  set undodir=$HOME/.vim/undodir-nvim
else
  if !isdirectory(expand("$HOME/.vim/undodir"))
    call mkdir(expand("$HOME/.vim/undodir"), "p")
  endif
  set undodir=$HOME/.vim/undodir
endif

set updatetime=100
" Turn on syntax highlighting
"syntax on
syntax enable
" Enable filetype plugins
"filetype plugin indent on
" Set to auto read when a file is changed from the outside
" I think this tends to give false alarms or something, though.
set autoread
" filename completion for multiple files
set wildmenu
set wildmode=list:longest

" With a map leader it's possible to do extra key combinations
let mapleader = "\\"
let g:mapleader = "\\"
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
if has('termguicolors')
  set termguicolors
  let &t_8f = "\<Esc>[38;2;%lu;%lu;%lum"
  let &t_8b = "\<Esc>[48;2;%lu;%lu;%lum"
endif
set background=dark
" set t_Co=256
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
colorscheme solarized8_high
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
" autocmd VimEnter * if argc() == 0 && !exists('s:std_in') | NERDTree | endif
" Start NERDTree when Vim starts with a directory argument.
autocmd VimEnter * if argc() == 1 && isdirectory(argv()[0]) && !exists('s:std_in') |
    \ execute 'NERDTree' argv()[0] | wincmd p | enew | execute 'cd '.argv()[0] | wincmd p | endif

""
" fzf
""
nnoremap <leader>ff :Files<cr>
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
" end syntastic
"autocmd BufNewFile,BufRead *.template set ft=json
let g:vim_json_syntax_conceal = 0
" do good terraform stuff
let g:terraform_fmt_on_save = 1
let g:terraform_align = 1

" shfmt options
let g:shfmt_extra_args = '-i 2 -bn -ci'
let g:shfmt_fmt_on_save = 1

" gitgutter
let g:gitgutter_preview_win_floating = 1

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
let g:syntastic_python_checkers=['flake8']
"" Commented out the pylint/flake8 options below in order to allow them to be
"" set per project.
" I don't care about long lines
" let g:syntastic_python_flake8_args = "--extend-ignore E501"
" I don't care about long lines and duplicates of what flake8 does
"let g:syntastic_python_pylint_args = "--disable=C0301,undefined-variable,unused-import,unused-variable"

" spelling
autocmd FileType Markdown set spell spelllang=en_us
map <leader>sp :set spell spelllang=en_us<cr>
