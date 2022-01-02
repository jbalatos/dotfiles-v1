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

	execute "normal! mz"
	if &ft == 'cpp' || &ft == "typescriptreact"
		execute "'" . st ",'" . end "normal! I//"
	elseif &ft == 'vim'
		execute "'" . st ",'" . end "normal! I\""
	elseif &ft == 'sh' || &ft == "python"
		execute "'" . st ",'" . end "normal! I#"
	elseif &ft == 'tex'
		execute "'" . st ",'" . end "normal! I%"
	elseif &ft == 'css'
		execute "normal! '" . st . "I/*"
		execute "normal! '" . end . "A*/"
	endif
	execute "normal! `z"
endfunction

function! Uncomment(...)
	if a:0
		let st = "["
		let end = "]"
	else
		let st = "<"
		let end = ">"
	endif

	execute "normal! mz"
	if &ft == 'cpp' || &ft == "typescriptreact"
		execute "'" . st . ",'" . end . "s/\\/\\///"
	elseif &ft == 'vim'
		execute "'" . st . ",'" . end . "s/\"//"
	elseif &ft == 'tex'
		execute "'" . st . ",'" . end . "s/%//"
	elseif &ft == 'sh' || &ft == "python"
		execute "'" . st . ",'" . end . "s/#//"
	elseif &ft == 'css'
		execute "'" . st ",'" . end . "s/\\/\\*//"
		execute "'" . st ",'" . end . "s/\\*\\///"
	endif
	execute "normal! `z"
endfunction

nnoremap <leader>c :set opfunc=Comment<CR>g@
nnoremap <leader>cc :set opfunc=Comment<CR>g@l
nnoremap <leader>u :set opfunc=Uncomment<CR>g@
nnoremap <leader>uu :set opfunc=Uncomment<CR>g@l
vnoremap <leader>c :<C-U>call Comment()<CR>
vnoremap <leader>u :<C-U>call Uncomment()<CR>

