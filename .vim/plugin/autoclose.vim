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
inoremap /* /**/<left><left>
autocmd BufRead *.tex :inoremap \( \(  \)<left><left><left>
autocmd BufRead *.tex :inoremap $ $$<left>

inoremap '<space> '  '<left><left>
inoremap `<space> `  `<left><left>
inoremap "<space> "  "<left><left>
inoremap (<space> (  )<left><left>
inoremap [<space> [  ]<left><left>
inoremap {<space> {  }<left><left>
inoremap /*<space> /*  */<left><left><left>

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

inoremap '' ''
inoremap `` ``
inoremap "" ""
inoremap () ()
inoremap [] []
inoremap {} {}

" Autoclose with new line inside
inoremap '<CR> '<CR>'<ESC>O
inoremap `<CR> `<CR>`<ESC>O
inoremap "<CR> "<CR>"<ESC>O
inoremap (<CR> (<CR>)<ESC>O
inoremap [<CR> [<CR>]<ESC>O
inoremap {<CR> {<CR>}<ESC>O
inoremap /*<CR> /*<CR>*/<ESC>O

" Autoclose with new line inside and semicolon
inoremap ';<CR> '<CR>';<ESC>O
inoremap `;<CR> `<CR>`;<ESC>O
inoremap ";<CR> "<CR>";<ESC>O
inoremap (;<CR> (<CR>);<ESC>O
inoremap [;<CR> [<CR>];<ESC>O
inoremap {;<CR> {<CR>};<ESC>O

autocmd BufRead *.tex :inoremap \[ \[\]<left><left>
autocmd BufRead *.tex :inoremap \[<space> \[  \]<left><left><left>
autocmd BufRead *.tex :inoremap \[<CR> \[<CR>\]<ESC>O
autocmd BufRead *.tex :inoremap \( \(\)<left><left>
autocmd BufRead *.tex :inoremap \(<space> \(  \)<left><left><left>
autocmd BufRead *.tex :inoremap \(<CR> \(<CR>\)<ESC>O

" Autoclose on html
" Autoclose on latex
autocmd BufEnter *.tex :inoremap <C-X><C-O> <C-C><C-C>mxyi{o\end{}<C-C><C-C>P`xa
autocmd BufEnter *.tex :nnoremap <C-X><C-O> yi{o\end{}<C-C><C-C>P
" Autoclose on tsx
autocmd BufEnter *.htm,*.html,*.tsx,*.js :inoremap <leader>> <C-C><C-C>mzF<lyiw`za</><C-C><C-C>F/p`za
