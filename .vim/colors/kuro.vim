"{{{ Vim Text
highlight Error                ctermbg=1 ctermfg=0 cterm=None
highlight SpellCap             ctermbg=3 ctermfg=0 cterm=None
highlight Normal               ctermfg=7
highlight Bold                 cterm=bold
highlight!link SpellBad        Error
highlight!link ErrorMsg        Error
highlight!link SpecialKey      Comment
highlight!link NonText         Comment
"}}}
"{{{ Visual
highlight Visual               NONE ctermbg=0 cterm=underline,bold
"}}}
"{{{ Fold
highlight!link Folded          Comment
"}}}
"{{{ Diff
highlight DiffAdd              NONE ctermfg=0 ctermbg=2 cterm=underline
highlight DiffChange           NONE                     cterm=underline
highlight DiffText             NONE ctermfg=0 ctermbg=4 cterm=underline
highlight DiffDelete           NONE ctermfg=7 ctermbg=1 cterm=bold
"}}}
"{{{ Columns
highlight ColorColumn          NONE ctermbg=0
highlight!link CursorColumn    ColorColumn
highlight CursorLine           NONE cterm=underline
highlight FoldColumn           NONE ctermbg=0 ctermfg=6
highlight SignColumn           NONE ctermbg=0
highlight LineNr               NONE ctermfg=1
highlight CursorLineNr         NONE ctermbg=0 ctermfg=6 cterm=bold
"}}}
"{{{ Borders
highlight KR_Border            NONE ctermfg=1 ctermbg=0 cterm=bold
highlight KR_BorderNC          NONE ctermfg=1 ctermbg=0
highlight!link StatusLine      KR_Border
highlight!link StatusLineNC    KR_BorderNC
highlight!link VertSplit       KR_BorderNC
highlight!link TabLineSel      KR_Border
highlight!link TabLine         KR_BorderNC
highlight!link TabLineFill     KR_BorderNC
"}}}
"{{{ Syntax
highlight Comment              NONE ctermfg=0 cterm=bold
highlight Constant             NONE ctermfg=2 cterm=bold
highlight String               NONE ctermfg=2
highlight Identifier           NONE ctermfg=2
highlight Function             NONE ctermfg=6
highlight Statement            NONE ctermfg=4
highlight!link Operator        Function
highlight PreProc              NONE ctermfg=5
highlight Define               NONE ctermfg=5 cterm=bold
highlight!link Include         Define
highlight Type                 NONE ctermfg=1
highlight!link Structure       Type
highlight Special              NONE ctermfg=6 cterm=bold
highlight Underlined           NONE           cterm=underline
highlight!link Ignore          Normal
highlight Error                NONE ctermfg=7 ctermbg=1 cterm=bold
highlight Todo                 NONE ctermfg=0 ctermbg=6
"}}}
"{{{ Git Diff
highlight!link DiffRemoved DiffDelete
highlight!link DiffAdded   DiffAdd
""}}}
" vim: foldlevel=0: foldmethod=marker
