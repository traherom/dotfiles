" Very high-level stuff
set nocompatible
let mapleader = " "    " I really like spacemacs use of spacebar as the leader

""""""""""""""""""""""""
" Base VIM settings
set encoding=utf-8	" A sane default encoding
set ttyfast					" We aren't in the 80s
set noshowmode      " vim-airline will draw modeline
set ruler           " line,col
set showcmd					" I frequently forget what I'm typing?
set wildmenu                " Command completion
set wildmode=list:longest   " List all matches and complete till longest common string
set hidden					" Nicer buffers

" Buffer area visuals
set scrolloff=7             " Minimal number of screen lines to keep above and below the cursor.
set visualbell              " Use a visual bell, don't beep!
set cursorline              " Highlight the current line
set number                  " Show line numbers
set relativenumber          " With both number and relativenumber set, VIM shows an abs number on the current line and relative elsewhere (v7)
set nowrap                    " Soft wrap at the window width
set showmatch								" Briefly (match time) show the matching bracket
set matchtime=2							" Tenths of a second to flash matching bracket

"set secure

" Editing settings
set tabstop=2
set autoindent
set expandtab
set shiftwidth=2

" Carry undo history across sessions
set undofile
set undodir=~/.vimundo/
set undolevels=1000
set undoreload=10000

" Return to last edit position when opening files, except git commit message
autocmd BufReadPost *
			\ if &ft != 'gitcommit' && line("'\"") > 0 && line("'\"") <= line("$") |
			\   exe "normal g`\"" |
			\ endif

" Text display
"set background=light
syntax on
"colorscheme Tomorrow-Night
if !has("gui_running")
	set t_Co=256                " enable 256 colors
"	let g:rehash256 = 1
endif

" Search
"set hlsearch
set ignorecase
set smartcase
set incsearch

" Tags
set tags=./tags;/ " Search all the way up to root if needed to find the ctags

""""""""""""""""""""""""""
" Key Bindings
" Navigate using displayed lines not actual lines
"set whichwrap+=<,>
nnoremap j gj
nnoremap k gk

" Repurpose arrow keys to navigating windows
nnoremap <left> <C-w>h
nnoremap <right> <C-w>l
nnoremap <up> <C-w>k
nnoremap <down> <C-w>j
inoremap <up> <nop>
inoremap <down> <nop>
inoremap <left> <nop>
inoremap <right> <nop>

" To encourage the use of <C-[np]> instead of the arrow keys in ex mode, remap
" them to use <Up/Down> instead so that they will filter completions
cnoremap <C-p> <Up>
cnoremap <C-n> <Down>

" Make Y consistent with D
nnoremap Y y$

" Reselect visual block after indent/outdent
vnoremap < <gv
vnoremap > >gv
vnoremap = =gv

" Fix indenting on paste
"nnoremap <Leader>p p
"nnoremap <Leader>P P
"nnoremap p p'[v']=
"nnoremap P P'[v']=

" Bindings here are (similar) to spacemacs
" Easy buffer management
nnoremap <Leader>bd :bdelete<cr>
nnoremap <Leader>bn :bnext<cr>
nnoremap <Leader>bp :bprevious<cr>
nnoremap <Leader>bs :CtrlPBuffer<cr>

" Easy window mangement
nnoremap <Leader>wj <C-w><C-j>
nnoremap <Leader>wk <C-w><C-k>
nnoremap <Leader>wl <C-w><C-l>
nnoremap <Leader>wh <C-w><C-h>

nnoremap <Leader>wc <C-w><C-c>
nnoremap <Leader>ws :sp<cr>
nnoremap <Leader>wv :vsp<cr>

" File search management
nnoremap <Leader>ff <C-p>

" Easily run make/equivalent build
nnoremap <Leader>m :make<cr>

" Allow w!! to write a file as sudo even if not opened that way
cmap w!! %!sudo tee >/dev/null %

" Disable Ex mode
noremap Q <nop>

"""""""""""""""""""""""""""""""""
" Plugin settings
" What should we use for project-specific vimrc settings?
