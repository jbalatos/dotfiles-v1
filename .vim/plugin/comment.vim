function! Comment(...)
	if &ft == 'cpp'
		execute "'[,']normal! 0i//"
	elseif &ft == 'vim'
		execute "'[,']normal! 0i\""
	elseif &ft == 'sh'
		execute "'[,']normal! 0i#"
	elseif &ft == 'tex'
		execute "'[,']normal! 0i%"
	endif
nnoremap <leader>C :w
endfunction

function! Uncomment(...)
	if a:0
		let st = "["
		let end = "]"
	else
		let st = "<"
		let end = ">"
	endif

	if &ft == 'cpp'
		execute "'" . st . ",'" . end . "s/\/\///"
	elseif &ft == 'vim'
		execute "'" . st . ",'" . end . "s/\"//"
	elseif &ft == 'tex'
		execute "'" . st . ",'" . end . "s/%//"
	elseif &ft == 'sh'
		execute "'" . st . ",'" . end . "s/#//"
	endif
endfunction

nnoremap <leader>c :set opfunc=Comment<CR>g@
nnoremap <leader>u :set opfunc=Uncomment<CR>g@
vnoremap <leader>c :<C-U>call Comment()<CR>
vnoremap <leader>u :<C-U>call Uncomment()<CR>

