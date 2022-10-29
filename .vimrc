
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
set ttymouse=xterm2
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

" GUI OPTIONS{{{
if has('gui_running')
	set guioptions-=T
	set guioptions-=m
	set guioptions-=r
	set guioptions-=L
	set guioptions-=e
	set guioptions+=c

	set guipty
	set guifont=Source\ Code\ Pro\ Medium\ 14
endif "}}}

" PATHS FOR FUZZY FIND
set path=/usr/include,$PWD/**
set wildignore+=**/node_modules/**

" PLUGINS
call plug#begin()
Plug 'morhetz/gruvbox'
Plug 'maxmellon/vim-jsx-pretty'
Plug 'leafOfTree/vim-vue-plugin'
Plug 'xavierd/clang_complete'
Plug 'sudar/vim-arduino-syntax'
Plug 'preservim/tagbar'
Plug 'dart-lang/dart-vim-plugin'
call plug#end()

" CLANG SETTINGS
let g:clang_library_path='/usr/lib'
let g:clang_complete_auto=0
let g:clang_user_options = '-std=c++11'
let g:clang_jumpto_declaration_key = ''

" TAGBAR SETTINGS
nnoremap <leader>tt :TagbarToggle<CR>

" COLORSCHEME
colo gruvbox
set background=dark

" FILE EXPLORER
let g:netrw_liststyle = 3
let g:netrw_banner = 0
let g:netrw_browse_split = 4
let g:netrw_winsize = 20

" AUTOCOMPLETTION
set tags+=~/.vim/tags/cpp
set completeopt=menuone,longest
set shortmess+=c
set pumheight=20

" -----SHORTCUTS-----

" SETTING WORKING DIRECTORY
autocmd VimEnter    :lcd %:p:h
nnoremap <leader>cd :lcd %:p:h<CR>

" GRACEFULLY EXIT
nnoremap <leader>q  :qa

" FILE HANDLING
nnoremap <leader>oo :ls<CR>:b<Space>
nnoremap <leader>or :10split <bar> enew <bar> put=execute('old') <bar> set buftype=nofile <bar> norm! ggdj41ggdGgg2wl<CR>

cnoremap bda silent bufdo bd

nnoremap <leader>sn :-1read ~/.vim/skeleton.
nnoremap <leader>io :40vs %:r.in <bar> sp %:r.out<CR>

" CONFIG RELOADING
nnoremap <leader>hr :so ~/.vimrc<CR>
nnoremap <leader>rr :so ~/.vim/plugin/

" TERMINAL 
nnoremap <leader>tc :term ++curwin<CR>
nnoremap <leader>tn :tabnew <bar> term ++curwin<CR>

" GO TO 
function! GoToDefinitions()"{{{
	if &ft == 'cpp' || &ft == 'c'
		let @/ = 'int\ main'
		normal! ggn2k
	elseif &ft == 'javascript'
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

nnoremap <leader>gd :call GoToDefinitions()<CR>
nnoremap <leader>gm :call GoToMain()<CR>

" REMAP SHIFT-TAB TO RIGHT
inoremap <S-Tab> <right>

" FILE EXPLORER SHORTCUT
nnoremap <Leader>f :Vex <CR>
