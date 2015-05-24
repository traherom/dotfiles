" Editting settings
set tabstop=4
set autoindent
set shiftwidth=4

" Text display
if has("gui_running")
	set cursorline
endif
"set background=light
syntax on

set number

" UI elements
set showcmd
set hidden

set wildmenu

"set spell spelllang=en_us

set statusline=%t       "tail of the filename
set statusline+=[%{strlen(&fenc)?&fenc:'none'}, "file encoding
set statusline+=%{&ff}] "file format
set statusline+=%h      "help file flag
set statusline+=%m      "modified flag
set statusline+=%r      "read only flag
set statusline+=%y      "filetype
set statusline+=%=      "left/right separator
set statusline+=%c,     "cursor column
set statusline+=%l/%L   "cursor line/total lines
set statusline+=\ %P    "percent through file

" Search
set hlsearch
set ignorecase
set smartcase
set incsearch

noremap <Leader>t :noautocmd vimgrep /tbd/j **<CR>:cw<CR>

" Nicer cursor movement
set whichwrap+=<,>
map <Up> gk
map <Down> gj

" Random shortcuts
nmap cn <esc>:cn<cr>
nmap cp <esc>:cp<cr>

" Pathogen
"execute pathogen#infect()

