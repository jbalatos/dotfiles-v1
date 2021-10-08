if exists("loaded_indent")
	finish
endif
let g:loaded_indent=1

function! ToIndentEnd()
	let ln = line('.')
	let indent_level = indent(ln)

	let i = ln
	while ( indent(i) >= indent_level || len(getline(i)) == 0 ) && i != line('$')
		let i += 1
	endwhile
	let i -= 1
	if i != ln
		execute "normal! " . i . "gg"
	endif
endfunction

function! ToIndentStart()
	let ln = line('.')
	let indent_level = indent(ln)

	let i = ln
	while ( indent(i) >= indent_level || len(getline(i)) == 0 ) && i != 1
		let i -= 1
	endwhile
	let i += 1
	if i != ln
		execute "normal! " . i . "gg"
	endif
endfunction

function! SelectIndentation()
	if len( getline(line('.')) ) == 0
		return
	endif

	call ToIndentStart()
	normal! 0v
	call ToIndentEnd()
	normal! $
endfunction

onoremap ii :<C-U>call SelectIndentation()<CR>

nnoremap <leader>[ :call ToIndentStart()<CR>
nnoremap <leader>] :call ToIndentEnd()<CR>
