command! -nargs=+ Encircle call EncircleFunc(<f-args>)
vnoremap <leader>e :<C-U>Encircle 

function! EncircleFunc (...)
	execute "normal! `<i" . a:1
	if a:0 == 2
		execute "normal! `>la" . a:2
	else
		execute "normal! `>la" . a:1
	endif
endfunction

