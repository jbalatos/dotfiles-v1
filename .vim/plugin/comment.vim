if exists("loaded_comment")
	finish
endif
let g:loaded_comment=1

function! Comment(...)
	if a:0
		let st='['
		let end=']'
	else
		let st='<'
		let end='>'
	endif

	if &ft == 'cpp'
		execute "'" . st ",'" . end "normal! 0i//"
	elseif &ft == 'vim'
		execute "'" . st ",'" . end "normal! 0i\""
	elseif &ft == 'sh' || &ft == "python"
		execute "'" . st ",'" . end "normal! 0i#"
	elseif &ft == 'tex'
		execute "'" . st ",'" . end "normal! 0i%"
	endif
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
		execute "'" . st . ",'" . end . "s/\\/\\///"
	elseif &ft == 'vim'
		execute "'" . st . ",'" . end . "s/\"//"
	elseif &ft == 'tex'
		execute "'" . st . ",'" . end . "s/%//"
	elseif &ft == 'sh' || &ft == "python"
		execute "'" . st . ",'" . end . "s/#//"
	endif
endfunction

onoremap ic :<C-U>call SelectComments()<CR>
nnoremap <leader>c :set opfunc=Comment<CR>g@
nnoremap <leader>u :set opfunc=Uncomment<CR>g@
vnoremap <leader>c :<C-U>call Comment()<CR>
vnoremap <leader>u :<C-U>call Uncomment()<CR>

