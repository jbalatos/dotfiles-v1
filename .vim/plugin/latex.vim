if exists("loaded_latex")
	finish
endif
let g:loaded_latex=1

autocmd BufRead *.tex :set ft=tex
autocmd BufRead *.tex :inoremap <=> \Leftrightarrow
