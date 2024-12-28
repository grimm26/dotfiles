" Check if this is probably vim-tiny
if has('eval')
  " Set up persistent undo across all files.
  set undofile
  if !isdirectory(expand("$HOME/.vim/undodir"))
    call mkdir(expand("$HOME/.vim/undodir"), "p")
  endif
  set undodir=$HOME/.vim/undodir

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
  let mapleader = " "
  let g:mapleader = " "
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
  set swapfile
  if !isdirectory(expand("$HOME/.vim/swap"))
    call mkdir(expand("$HOME/.vim/swap"), "p")
  endif
  set directory=$HOME/.vim/swap//
endif

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
if has('eval')

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
  map <leader>pp :setlocal paste!<cr>
  "
  " Returns true if paste mode is enabled
  function! HasPaste()
      if &paste
          return 'PASTE MODE  '
      en
      return ''
  endfunction

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
endif
