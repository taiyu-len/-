setlocal spell
nnoremap <buffer><silent> { :call search('^@@', 'bWz')<CR>zz
nnoremap <buffer><silent> } :call search('^@@', 'Wz')<CR>zz
