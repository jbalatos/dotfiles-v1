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

	execute "normal! F" . old_st . "xi" . new_st
	execute "normal! f" . old_end . "xi" . new_end
endfunction

function! DeleteEncircle()
	let start_str = input('Select encircle symbols: ')
	let end_str = SymbolEnding(start_str)

	execute "normal! F" . start_str . "xf" . end_str . "x"
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
	execute "normal! `za "
	execute "normal! `yi "
endfunction

nnoremap <leader>ae :set opfunc=AddEncircle<CR>g@
vnoremap <leader>ae :<C-U>call AddEncircle()<CR>
nnoremap <leader>ce :call ChangeEncircle()<CR>
nnoremap <leader>de :call DeleteEncircle()<CR>
nnoremap <leader>se :set opfunc=SpacedEncircle<CR>g@
vnoremap <leader>se :<C-U>call SpacedEncircle()<CR>
