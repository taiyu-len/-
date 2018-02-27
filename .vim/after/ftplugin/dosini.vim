setlocal foldmethod=expr
setlocal foldexpr=getline(v:lnum)=~'^\['?'>1':1
