function! s:exe_range() abort
	for line in getline("'<", "'>")
		exe line
	endfor
endfunction
nnoremap <buffer> <silent> <leader>e :exe getline('.')<CR>
vnoremap <buffer> <silent> <leader>e :<c-u>call <SID>exe_range()<CR>
