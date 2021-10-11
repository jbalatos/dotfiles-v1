if exists("loaded_indent")
	finish
endif
let g:loaded_indent=1

function! ToIndentEnd()
	let ln = line('.')
	let indent_level = indent(ln)

	if indent_level == 0
		return
	endif

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

function! SelectIndentation(isAround)
	if len( getline(line('.')) ) == 0
		return
	endif

	call ToIndentStart()
	if a:isAround == 1
		normal! k0vj
	else
		normal! 0v
	endif

	call ToIndentEnd()
	if a:isAround == 1
		normal! j$
	else
		normal! $
	endif
endfunction

onoremap ii :<C-U>call SelectIndentation(0)<CR>
onoremap ai :<C-U>call SelectIndentation(1)<CR>
onoremap <leader>[ :<C-U>call ToIndentStart()<CR>
onoremap <leader>] :<C-U>call ToIndentEnd()<CR>

nnoremap <leader>[ :call ToIndentStart()<CR>
nnoremap <leader>] :call ToIndentEnd()<CR>
