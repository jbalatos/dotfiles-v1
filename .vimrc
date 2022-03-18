
	" [x] compile
	" [x] statusline
	" [x] comments (not necessary at last)
	" [x] autoclosing
	" [ ] competitive tricks + debug comments
	" [x] encircling
	" [ ] goto

set nocompatible
set wildmenu
set encoding=utf-8
set autoindent
set exrc
set cursorline
set noerrorbells
set mouse=a
set showcmd

set autoread
autocmd CursorHold * checktime

syntax on
filetype plugin on

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
set listchars=tab:\|\ 

set splitright
set splitbelow
set foldmethod=marker

" LINE NUMBERS
set nu
set rnu

" PATHS FOR FUZZY FIND
set path=/usr/include,$PWD/**
set wildignore+=**/node_modules/**

" PLUGINS
call plug#begin()
Plug 'morhetz/gruvbox'
Plug 'maxmellon/vim-jsx-pretty'
Plug 'leafOfTree/vim-vue-plugin'
Plug 'xavierd/clang_complete'
call plug#end()

let g:clang_library_path='/usr/lib'
let g:clang_complete_auto=0
let g:clang_user_options = '-std=c++11'

colo gruvbox
set background=dark

" FILE EXPLORER
nnoremap <Leader>F :Vex <CR>
let g:netrw_liststyle = 3
let g:netrw_banner = 0
let g:netrw_browse_split = 4
let g:netrw_winsize = 20

" AUTOCOMPLETTION
set tags+=~/.vim/tags/cpp
set completeopt=menuone,longest
set shortmess+=c
set pumheight=20

function! GoToDefinitions()"{{{
	if &ft == 'cpp' || &ft == 'c'
		let @/ = 'int\ main'
		normal! ggn2k
	elseif &ft == "javascript"
		let @/ = 'import\|require'
		normal! ggn
	endif
endfunction
function! GoToMain()
	if &ft == 'cpp' || &ft == 'c'
		let @/ = 'int\ main'
		normal! ggn$
	endif
endfunction"}}}

autocmd VimEnter :lcd %:p:h
nnoremap <leader>cd :lcd %:p:h
nnoremap <leader>o :ls<CR>:b<Space>

nnoremap <leader>gd :call GoToDefinitions()<CR>
nnoremap <leader>gm :call GoToMain()<CR>

inoremap <S-Tab> <right>
nnoremap <leader>q :qa

nnoremap <leader>sn :-1read ~/.vim/skeleton.
nnoremap <leader>io :60vs %:r.in <bar> sp %:r.out<CR>

