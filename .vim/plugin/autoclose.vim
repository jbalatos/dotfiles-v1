if exists("loaded_autoclose")
	finish
endif
let g:loaded_autoclose=1

" General autoclose rules (with/without space)
inoremap ' ''<left>
inoremap ` ``<left>
inoremap " ""<left>
inoremap ( ()<left>
inoremap [ []<left>
inoremap { {}<left>
autocmd BufRead *.tex :inoremap \( \(  \)<left><left><left>
autocmd BufRead *.tex :inoremap $ $$<left>

inoremap '<space> '  '<left><left>
inoremap `<space> `  `<left><left>
inoremap "<space> "  "<left><left>
inoremap (<space> (  )<left><left>
inoremap [<space> [  ]<left><left>
inoremap {<space> {  }<left><left>

" Autoclose with exceeding semicolon (with/without space)
inoremap '; '';<left><left>
inoremap `; ``;<left><left>
inoremap "; "";<left><left>
inoremap (; ();<left><left>
inoremap [; [];<left><left>
inoremap {; {};<left><left>

inoremap ';<space> '  ';<left><left><left>
inoremap `;<space> `  `;<left><left><left>
inoremap ";<space> "  ";<left><left><left>
inoremap (;<space> (  );<left><left><left>
inoremap [;<space> [  ];<left><left><left>
inoremap {;<space> {  };<left><left><left>

" Autoclose without writing inside
inoremap '<Tab> ''
inoremap `<Tab> ``
inoremap "<Tab> ""
inoremap (<Tab> ()
inoremap [<Tab> []
inoremap {<Tab> {}

" Autoclose with new line inside
inoremap '<CR> '<CR>'<ESC>O
inoremap `<CR> `<CR>`<ESC>O
inoremap "<CR> "<CR>"<ESC>O
inoremap (<CR> (<CR>)<ESC>O
inoremap [<CR> [<CR>]<ESC>O
inoremap {<CR> {<CR>}<ESC>O
autocmd BufRead *.tex :inoremap \[ \[<CR>\]<ESC>O

" Autoclose on html
autocmd BufEnter *.html,*.htm :inoremap <// </<C-X><C-O>
" Autoclose on latex
autocmd BufEnter *.tex :inoremap <C-X><C-O> <C-C><C-C>mxyi{o\end{}<C-C><C-C>P`xa
autocmd BufEnter *.tex :nnoremap <C-X><C-O> yi{o\end{}<C-C><C-C>P

