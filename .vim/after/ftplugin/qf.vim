setlocal colorcolumn=0
setlocal statusline= %{&filetype} │ %=%<
setlocal statusline+=%{exists('w:quickfix_title')?' '.w:quickfix_title:''} 
