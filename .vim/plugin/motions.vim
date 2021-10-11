if exists("g:loaded_motions")
	finish
endif
let g:loaded_motions = 1

onoremap il :<C-U>normal! 0v$h<CR>
onoremap al :<C-U>normal! 0v$<CR>
