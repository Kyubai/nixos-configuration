''
syntax on

" change leader key
let mapleader = " "

" dynamic line-numbers
set number relativenumber

" disable beep
set belloff=all

set showmatch
set hlsearch

" Ignore case in general, but become case-sensitive when uppercase is present
set ignorecase smartcase 

set autoindent

" Tab settings
set tabstop=4       " visual spaces per tab
set softtabstop=4   " spaces in tab on edit
set shiftwidth=4    " spaces used for autoident
set expandtab       " expand tab to spaces

" Align indent to next multiple value of shiftwidth. For its meaning,
" see http://vim.1045645.n5.nabble.com/shiftround-option-td5712100.html
set shiftround

set smartindent
set 
set ruler 
set undolevels=1000

" use backspace to delete
set backspace=indent,eol,start

" spell-check
set spelllang=en,de

" Go to start or end of line easier
nnoremap H ^
xnoremap H ^
nnoremap L g_
xnoremap L g_

" Change text without putting the text into register,
" see https://stackoverflow.com/q/54255/6064933
nnoremap c "_c
nnoremap C "_C
nnoremap cc "_cc

" Paste mode toggle, it seems that Neovim's bracketed paste mode
" does not work very well for nvim-qt, so we use good-old paste mode
set pastetoggle=<F12>

inoremap <C-d> <Esc>

" Persistent undo even after you close a file and re-open it.
" For vim, we need to set up an undodir so that $HOME is not cluttered with
" undo files.
if !has('nvim')
    if !isdirectory($HOME . '/.local/vim/undo')
        call mkdir($HOME . '/.local/vim/undo', 'p', 0700)
    endif
    set undodir=~/.local/vim/undo
endif
set undofile

" Copy from clipboard
vnoremap  <C-c>  "+y
nnoremap  <C-c>  "+y
vnoremap  <leader>y  "+y
nnoremap  <leader>Y  "+yg_

" " Paste from clipboard
nnoremap <leader>p "+p
nnoremap <leader>P "+P
vnoremap <leader>p "+p
vnoremap <leader>P "+P
''
