if exists("loaded_compile")
	finish
endif
let g:loaded_compile=1

nnoremap <F12> :make<CR>

autocmd BufEnter *.cpp :set makeprg=g++\ %\ \-o\ %:r\ \-DLOCAL
autocmd BufEnter *.cpp :command! Run w <bar> !./%:r
autocmd BufEnter *.cpp :nnoremap <F12> :w <bar> make <bar>Run<CR>
"autocmd BufEnter *.cpp :set errorformat=
"	\%E%f\:%l\:%c\:\ error\:\ %m,
"	\%W%f\:%l\:%c\:\ warning\:\ %m,
"	\%-G%.%#

autocmd BufEnter *.tex :set makeprg=pdflatex\ %:p
autocmd BufEnter *.tex :set errorformat=%-G%.%#
autocmd BufEnter *.tex :nnoremap <F12> :w <bar> make<CR>
autocmd BufEnter *.tex :nnoremap <F9> :!evince %:r.pdf &<CR>

autocmd BufEnter *.js :nnoremap <F12> :w <bar> !clear && node %<CR>

autocmd BufEnter *.md :nnoremap <F12> :w <bar> !clear && cat % <bar> mdless<CR>
