if exists("loaded_compile")
	finish
endif
let g:loaded_compile=1

nnoremap <F12> :make<CR>

function! ShellCommand(cmd) "{{{
	let initial_nr = bufwinnr(bufname())

	let cmd_str = a:cmd
	let idx=0
	while idx < strlen(a:cmd)
		if a:cmd[idx] == '%'
			if idx+1 < strlen(a:cmd) && a:cmd[idx+1] == ':'
				let cmd_str = substitute(cmd_str, strpart(a:cmd, idx, 3), expand(strpart(a:cmd, idx, 3)), "")
			else
				let cmd_str = substitute(cmd_str, a:cmd[idx], expand(a:cmd[idx]), "")
			endif
		endif
		let idx += 1
	endwhile

	let nr = bufwinnr('Shell Command')
	if nr >= 0
		execute nr . 'wincmd w'
		normal! Go
		execute 'normal! o---Command: ' . cmd_str
		normal! o---Output:
	elseif winnr('h') == winnr('l')
		execute 'vertical 50new Shell Command'
		call setline(1, '---Command: ' . cmd_str)
		call setline(2, '---Output:')
	else
		wincmd b
		execute 'rightb 10new Shell Command'
		call setline(1, '---Command: ' . cmd_str)
		call setline(2, '---Output:')
	endif

	setlocal buftype=nowrite nobuflisted nowrap noswapfile bufhidden=wipe
	nnoremap <buffer> <leader>d ggdG
	normal! G
	execute 'read !' . cmd_str

	execute initial_nr . 'wincmd w'
endfunction "}}}

function! RunProgram(output) "{{{
	let error_number = len( getqflist() )
	let warning_number = len( filter( getqflist(), 'v:val["type"] == "W"' ) )

	if error_number != warning_number
		echo "errors exist"
		return
	endif

	if a:output == 1
		if len( bufname( expand("%:r") . ".out" ) ) == 0
			execute "60vs %:r.out"
		endif
		:!./%:r > %:r.out
	else
		:!./%:r
	endif
endfunc "}}}

"autocmd BufEnter *.cpp :set makeprg=g++\ %\ -o\ %:r\ -DLOCAL\ -std=c++11\ -g\ -fsanitize=address\ -fsanitize=undefined
autocmd BufEnter *.cpp :set makeprg=g++\ %\ -o\ %:r\ -DLOCAL\ -std=c++11\ -O2\ -Wall\ -g
autocmd BufEnter *.cpp :set errorformat=
	\%E%f\:%l\:%c\:\ error\:\ %m,
	\%W%f\:%l\:%c\:\ warning\:\ %m,
	\%-G%.%#
autocmd BufEnter *.cpp :nnoremap <F12> :w <bar> make <bar> call RunProgram(1)<CR>
autocmd BufEnter *.cpp :nnoremap <F9> :w <bar> make <bar> call RunProgram(0)<CR>
autocmd BufEnter *.cpp :nnoremap <leader>r :call RunProgram(1)<CR>
autocmd BufEnter *.cpp :nnoremap <leader>R :call RunProgram(0)<CR>
autocmd VimLeavePre *.cpp :call delete( expand("%:r").".out" )

autocmd BufEnter *.tex :set makeprg=pdflatex\ %:p
autocmd BufEnter *.tex :set errorformat=%-G%.%#
autocmd BufEnter *.tex :nnoremap <F12> :w <bar> make<CR>
autocmd BufEnter *.tex :nnoremap <F9> :!evince %:r.pdf &<CR>

autocmd BufEnter *.js :set makeprg=eslint\ .
autocmd BufEnter *.tsx :set makeprg=tsc

autocmd BufEnter *.java :set makeprg=javac\ %

autocmd BufEnter *.md :nnoremap <F12> :w <bar> !clear && pandoc % --from=gfm --pdf-engine=xelatex -o %:r.pdf -V mainfont="Liberation Serif" -t latex<CR>
autocmd BufEnter *.md :nnoremap <F9> :!evince %:r.pdf &<CR>

autocmd BufEnter *.dot :nnoremap <F12> :w <bar> !clear && dot -Tpng % -o %:r.png<CR>

autocmd BufEnter *.py :nnoremap <F12> :w <bar> !clear && python3 %<CR>
