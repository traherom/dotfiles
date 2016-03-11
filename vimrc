" Very high-level stuff
set nocompatible
let mapleader = " "    " I really like spacemacs use of spacebar as the leader

"""""""""""""""""""""""
" Plugins
" Load vim-plug
if empty(glob("~/.vim/autoload/plug.vim"))
  execute '!mkdir -p ~/.vim/autoload'
  execute '!mkdir -p ~/.vim/plugged'
  execute '!curl -fLo ~/.vim/autoload/plug.vim https://raw.github.com/junegunn/vim-plug/master/plug.vim'
endif

call plug#begin('~/.vim/plugged')

" Languages/Tab completion
Plug 'ervandew/supertab'
"Plug 'Valloric/YouCompleteMe'
Plug 'davidhalter/jedi-vim', { 'for': 'python' }
Plug 'pangloss/vim-javascript'
Plug 'fatih/vim-go', { 'for': 'go' }

" Fuzzy file search
Plug 'ctrlpvim/ctrlp.vim'

" General syntax checking
Plug 'scrooloose/syntastic'

" Writing/markdown
Plug 'plasticboy/vim-markdown', { 'for': 'markdown' }
Plug 'reedes/vim-pencil', { 'for': 'markdown' }

" Colorschemes
Plug 'chriskempson/base16-vim'
Plug 'tomasr/molokai'
Plug 'chriskempson/vim-tomorrow-theme'
Plug 'flazz/vim-colorschemes'

" Fancy status line
Plug 'vim-airline/vim-airline-themes'
Plug 'bling/vim-airline'

" Indent navigation
Plug 'michaeljsmith/vim-indent-object'

filetype plugin indent on                   " required!
call plug#end()

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
set linebreak               " Break the line on words
set textwidth=79            " Break lines at just under 80 characters
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
colorscheme Tomorrow-Night
if !has("gui_running")
	set t_Co=256                " enable 256 colors
"	let g:rehash256 = 1
endif

" UI elements
set laststatus=2 " Show airline all the time
let g:airline#extensions#tabline#enabled = 1
let g:airline_theme='zenburn'  " Airline theme

"set spell spelllang=en_us
"set statusline=%t       "tail of the filename"
"set statusline+=[%{strlen(&fenc)?&fenc:'none'}, "file encoding"
"set statusline+=%{&ff}] "file format"
"set statusline+=%h      "help file flag"
"set statusline+=%m      "modified flag"
"set statusline+=%r      "read only flag"
"set statusline+=%y      "filetype"
"set statusline+=%=      "left/right separator"
"set statusline+=%c,     "cursor column"
"set statusline+=%l/%L   "cursor line/total lines"
"set statusline+=\ %P    "percent through file"

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
nnoremap <Leader>p p
nnoremap <Leader>P P
nnoremap p p'[v']=
nnoremap P P'[v']=

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
" Ctrl-P
let g:ctrlp_working_path_mode = 'rw'
let g:ctrlp_custom_ignore = {
    \ 'dir': '\v[\/]\.(git|hg|svn|sass-cache|pip_download_cache|wheel_cache)$',
    \ 'file': '\v\.(png|jpg|jpeg|gif|DS_Store|pyc)$',
    \ 'link': '',
    \ }
let g:ctrlp_show_hidden = 1
let g:ctrlp_clear_cache_on_exit = 0
" Wait to update results (This should fix the fact that backspace is so slow)
let g:ctrlp_lazy_update = 1
" Show as many results as our screen will allow
let g:ctrlp_match_window = 'max:1000'


" If we have The Silver Searcher
if executable('ag')
	" Use ag over grep
	set grepprg=ag\ --nogroup\ --nocolor

	" Use ag in CtrlP for listing files. Lightning fast and respects
	" .gitignore
	let g:ctrlp_user_command = 'ag %s -l --nocolor -g ""'

	" ag is fast enough that CtrlP doesn't need to cache
	let g:ctrlp_use_caching = 0
else
  " No ag, so use git to list files 
  let g:ctrlp_user_command = ['.git/', 'git --git-dir=%s/.git ls-files -oc --exclude-standard']
endif

" Markdown
let g:vim_markdown_folding_disabled = 1

"""""""""""""""""""""""""""""""""
" Machine-specific VIM settings?
if filereadable(glob("$HOME/.vimrc.local"))
	source $HOME/.vimrc.local
endif
