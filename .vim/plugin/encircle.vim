if exists("loaded_encircle")
	finish
endif
let g:loaded_encircle=1

function! SymbolEnding(start_str)
	if a:start_str == '('
		return ')'
	elseif a:start_str == '{'
		return '}'
	elseif a:start_str == '['
		return ']'
	elseif a:start_str == '<'
		return '>'
	else
		return a:start_str
	endif
endfunction

function! AddEncircle(...)
	if a:0
		let st='['
		let end=']'
	else
		let st='<'
		let end='>'
	endif

	let start_str = input('Select encircle symbols: ')
	let end_str = SymbolEnding(start_str)

	execute "normal! `" . st . "my`" . end . "mz"
	if a:1 == 'char'
		execute "normal! `za" . end_str
	elseif a:1 == 'line'
		execute "normal! `zA" . end_str
	endif
	execute "normal! `yi" . start_str
endfunction

function! ChangeEncircle()
	let old_st = input("Select symbols to be removed: ")
	let old_end = SymbolEnding(old_st)

	let new_st = input("Select symbol to be inserted: ")
	let new_end = SymbolEnding(new_st)

	let @/ = old_st
	normal! N
	let i=0
	while i<len(old_st)
		normal! x
		let i += 1
	endwhile
	execute "normal! i" . new_st

	let @/ = old_end
	normal! n
	let i=0
	while i<len(old_end)
		normal! x
		let i += 1
	endwhile
	execute "normal! i" . new_end
endfunction

function! DeleteEncircle()
	let start_str = input('Select encircle symbols: ')
	let end_str = SymbolEnding(start_str)

	let @/ = start_str
	normal! N
	let i=0
	while i<len(start_str)
		normal! x
		let i += 1
	endwhile

	let @/ = end_str
	normal! n
	let i=0
	while i<len(end_str)
		normal! x
		let i += 1
	endwhile
endfunction

function! SpacedEncircle(...)
	if a:0
		let st='['
		let end=']'
	else
		let st='<'
		let end='>'
	endif

	execute "normal! `" . st . "my`" . end . "mz"
	normal! `za 
	normal! `yi 
endfunction

function! LinedEncircle()
	let start_str = input('Select encircle symbols: ')
	let end_str = SymbolEnding(start_str)

	let @/ = start_str
	normal! N
	if len(start_str) > 1
		normal! e
	endif
	normal! a 

	let @/ = end_str
	normal! n
	if len(end_str) > 1
		normal! e
	endif
	normal! a 

endfunction

nnoremap <leader>ae :set opfunc=AddEncircle<CR>g@
vnoremap <leader>ae :<C-U>call AddEncircle()<CR>
nnoremap <leader>ce :call ChangeEncircle()<CR>
nnoremap <leader>de :call DeleteEncircle()<CR>
nnoremap <leader>se :set opfunc=SpacedEncircle<CR>g@
vnoremap <leader>se :<C-U>call SpacedEncircle()<CR>
