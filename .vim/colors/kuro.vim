"{ Vim Text
highlight Normal               NONE ctermfg=7 cterm=bold
highlight Bold                 NONE           cterm=bold
highlight!link ErrorMsg        Error
highlight SpecialKey           NONE ctermfg=0 cterm=bold
"}
"{ Columns
highlight ColorColumn          NONE ctermbg=0
highlight! link CursorColumn   ColorColumn
highlight! link CursorLine     ColorColumn
highlight FoldColumn           NONE ctermbg=0 ctermfg=6
highlight SignColumn           NONE ctermbg=0
highlight LineNr               NONE ctermfg=6
highlight CursorLineNr         NONE ctermbg=0 ctermfg=6 cterm=bold
"}
"{ Visual
highlight Visual               NONE ctermbg=0 cterm=underline,bold
"}
"{ Fold
highlight! link Folded         Comment
"}
"{ Diff
highlight DiffAdd              NONE ctermfg=0 ctermbg=2 cterm=underline,bold
highlight DiffChange           NONE                     cterm=underline
highlight DiffText             NONE ctermfg=0 ctermbg=4 cterm=underline,bold
highlight DiffDelete           NONE ctermfg=0 ctermbg=1
"}
"{ Borders
highlight KR_Border            NONE ctermfg=4 ctermbg=0 cterm=bold
highlight KR_BorderNC          NONE ctermfg=7 ctermbg=0 cterm=NONE
highlight! link StatusLine     KR_Border
highlight! link StatusLineNC   KR_BorderNC
highlight! link VertSplit      KR_BorderNC
highlight! link TabLineSel     KR_Border
highlight! link TabLine        KR_BorderNC
highlight! link TabLineFill    KR_BorderNC
"}
"{ Syntax
highlight Comment              NONE ctermfg=3
highlight Constant             NONE ctermfg=2 cterm=bold
highlight String               NONE ctermfg=2
highlight Identifier           NONE ctermfg=2
highlight Function             NONE ctermfg=6
highlight Statement            NONE ctermfg=4
highlight! link Operator       Function
highlight PreProc              NONE ctermfg=3
highlight Define               NONE ctermfg=3 cterm=bold
highlight Include              NONE ctermfg=3 cterm=bold
highlight Type                 NONE ctermfg=1
highlight! link Structure      Type
highlight Special              NONE ctermfg=6 cterm=bold
highlight Underlined           NONE           cterm=underline
highlight! link Ignore         Normal
highlight Error                NONE ctermfg=7 ctermbg=1 cterm=bold
highlight Todo                 NONE ctermfg=0 ctermbg=6
"}
" vim: foldmarker=\"{,\"}: foldlevel=0: foldmethod=marker

