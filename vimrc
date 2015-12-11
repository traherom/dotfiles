set nocompatible

"""""""""""""""""""""""
" Plugins
" Load vim-plug
if empty(glob("~/.vim/autoload/plug.vim"))
	execute '!mkdir -p ~/.vim/autoload'
	execute '!mkdir -p ~/.vim/plugged'
    execute '!curl -fLo ~/.vim/autoload/plug.vim https://raw.github.com/junegunn/vim-plug/master/plug.vim'
endif

call plug#begin('~/.vim/plugged')

" Tab completion
Plug 'Valloric/YouCompleteMe'
Plug 'ervandew/supertab'

" Fuzzy file search
Plug 'ctrlpvim/ctrlp.vim'

" General syntax checking
Plug 'scrooloose/syntastic'

" Python
Plug 'davidhalter/jedi-vim', { 'for': 'python' }

" Javascript
Plug 'pangloss/vim-javascript'

" Go
Plug 'fatih/vim-go', { 'for': 'go' }

" Writing/markdown
Plug 'plasticboy/vim-markdown', { 'for': 'markdown' }
Plug 'reedes/vim-pencil'

" Colorschemes
Plug 'chriskempson/base16-vim'
Plug 'tomasr/molokai'

" Fancy status line
Plug 'bling/vim-airline'

" Indent navigation
Plug 'michaeljsmith/vim-indent-object'

filetype plugin indent on                   " required!
call plug#end()

""""""""""""""""""""""""
" Base VIM settings
set encoding=utf-8
set ttyfast
set noshowmode      " vim-airline will draw modeline
set ruler           " line,col
set showcmd
set wildmenu                " Command completion
set wildmode=list:longest   " List all matches and complete till longest common string
set nohidden

" Buffer area visuals
set scrolloff=7             " Minimal number of screen lines to keep above and below the cursor.
set visualbell              " Use a visual bell, don't beep!
set cursorline              " Highlight the current line
set number                  " Show line numbers
set wrap                    " Soft wrap at the window width
set linebreak               " Break the line on words
set textwidth=79            " Break lines at just under 80 characters

"set secure

" Editing settings
set tabstop=2
set autoindent
set shiftwidth=2

" Text display
"set background=light
syntax on
colorscheme molokai
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

noremap <Leader>t :noautocmd vimgrep /tbd/j **<CR>:cw<CR>

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

" Disable Ex mode
" Nobody ever uses "Ex" mode, and it's annoying to leave
noremap Q <nop>

"""""""""""""""""""""""""""""""""
" Plugin settings
" Return to last edit position when opening files, except git commit message
autocmd BufReadPost *
    \ if &ft != 'gitcommit' && line("'\"") > 0 && line("'\"") <= line("$") |
    \   exe "normal g`\"" |
    \ endif

" Ctrl-P
let g:ctrlp_working_path_mode = 'rw'
let g:ctrlp_custom_ignore = { 
    \ 'dir': '\v[\/]\.(git|hg|svn|sass-cache|pip_download_cache|wheel_cache)$',
    \ 'file': '\v\.(png|jpg|jpeg|gif|DS_Store|pyc)$',
    \ 'link': '',
    \ }
let g:ctrlp_show_hidden = 1
let g:ctrlp_clear_cache_on_exit = 0
"" Wait to update results (This should fix the fact that backspace is so slow)
let g:ctrlp_lazy_update = 1
"" Show as many results as our screen will allow
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
endif


" Jedi Python Autocomplete
let g:jedi#use_tabs_not_buffers = 0 " Jedi needs you to unset this default to get to splits
let g:jedi#use_splits_not_buffers = "bottom"

"""""""""""""""""""""""""""""""""
" Machine-specific VIM settings?
if filereadable(glob("$HOME/.vimrc.local"))
	source $HOME/.vimrc.local
endif
