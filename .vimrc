
	" [x] compile
	" [x] statusline
	" [x] comments (not necessary at last)
	" [x] autoclosing
	" [ ] competitive tricks + debug comments
	" [x] encircling
	" [ ] goto

set nocompatible
set wildmenu
syntax on
set encoding=utf-8
set autoindent
set exrc
set cursorline
set noerrorbells
"set colorcolumn=80

set noexpandtab
set shiftwidth=2
set tabstop=2
set nowrap
set scrolloff=4

set incsearch
set smartcase
set showmatch

set noswapfile
set undofile
set undodir=~/.vim/undodir

set list
set listchars=tab:\|\ ,precedes:<,extends:>

set splitright
set splitbelow
set foldmethod=marker

" LINE NUMBERS
set nu
set rnu

" PATHS FOR FUZZY FIND
set path=/usr/include,$PWD/**
set wildignore+=**/node_modules/**

set omnifunc=syntaxcomplete#Complete
set completeopt=menuone,longest
set shortmess+=c

" PLUGINS
call plug#begin()
Plug 'morhetz/gruvbox'
Plug 'maxmellon/vim-jsx-pretty'
Plug 'leafOfTree/vim-vue-plugin'
" Plug 'lervag/vimtex'
call plug#end()

colo gruvbox
set background=dark

" FILE EXPLORER
nnoremap <Leader>F :Vex <CR>
let g:netrw_liststyle = 3
let g:netrw_banner = 0
let g:netrw_browse_split = 4
let g:netrw_winsize = 20

function! GoToDefinitions()
	let @/ = 'int\ main'
	normal! ggn2k
endfunction
nnoremap <leader>gd :call GoToDefinitions()<CR>

inoremap <S-Tab> <right>
nnoremap <leader>q :qa
nnoremap <leader>sn :-1read ~/.vim/skeleton.

