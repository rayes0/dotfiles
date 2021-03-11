" Name:         Yui
" Version:      0.16.0
" Author:       Florian B <yuuki@protonmail.com>
" Maintainer:   Florian B <yuuki@protonmail.com>
" License:      Vim License (see `:help license`)
" Last Updated: Mon Jul 27 17:27:26 2020
" MODFIED by me

set background=light

" Exit if terminal doesn't support 256 colors
" if !has('gui_running') && &t_Co < 256
" 	finish
" endif

hi clear
if exists('g:syntax_on')
	syntax reset
endif

let g:colors_name = 'yui'

" XXX
" ============== COLORS ==================
" DEFAULT BG: #ede6e3 - lightneess=91.8
" Soft BG: #dad3d0 - lightness=85.0

" Neutral Light BG: #b6a8a2 - Lightness=70.0

" Hard Colored BG: #e3d0cb
" Soft Colored BG: #e6dad6
" Purple BG: 

" DEFAULT FG: #685c56 - Lightness=40.0
" Dark FG: #544943 - Lightness=32.0
" Light FG: #938680 - Lightness=57.0

" Pinkish Light FG: #8f8678

" Syntax1: 
" Syntax2:
" Syntax3:

" Red BG: #fccec1 - Used for warnings, spelling errors, and diff deletions
" Green BG: 

" XXX

hi! Normal guibg=#ede6e3 guifg=#685c56 guisp=NONE
hi! CursorLineNr guibg=#FFFFFF guifg=#544943 gui=NONE
hi! CursorLine guibg=#FFFFFF guifg=fg gui=NONE
hi! Cursor guifg=bg guibg=fg guisp=NONE gui=NONE
hi! link CursorIM Cursor
hi! link lCursor Cursor
hi! link TermCursor Cursor
hi! TermCursorNC guifg=bg guibg=#544953

" -------------- Left Sidebar -------------------
hi! ColorColumn guibg=#dad3d0 guifg=NONE gui=NONE
hi! SignColumn guibg=NONE guifg=#b6a8a2 gui=NONE
hi! LineNr guibg=NONE guifg=#b6a8a2 gui=NONE

" -------------- Statusline ---------------------
hi! StatusLine guifg=fg guibg=#e3d0cb gui=bold,italic guisp=NONE
hi! StatusLineNC guibg=#e6dad6 guifg=fg gui=italic guisp=NONE
" hi! WildMenu guibg=#FFFFFF guifg=fg guisp=NONE gui=NONE
" hi! WildMenu guibg=#5137e1 guifg=#DCD7F9 guisp=NONE gui=NONE

" -------------- Tabline ------------------------
hi! TabLine guibg=#dad3d0 guifg=NONE gui=italic guisp=NONE
hi! link TabLineFill TabLine
hi! TabLineSel guibg=#8f8678 guifg=bg guisp=NONE gui=bold,italic
hi! link Title TabLineSel

" -------------- Folds --------------------------
hi! Folded guibg=NONE guifg=#938680 guisp=NONE gui=italic
hi! link FoldColumn Folded

" -------------- Completion Menu ----------------
hi! Pmenu guifg=NONE guibg=#e6dad6 guisp=NONE gui=NONE
hi! PmenuThumb guifg=NONE guibg=fg guisp=NONE gui=NONE
hi! link PmenuSbar PMenu
hi! PmenuSel guibg=#938680 guifg=bg guisp=NONE gui=NONE

" -------------- Special Colors -----------------
hi! Directory guifg=NONE guibg=NONE guisp=NONE gui=italic,underline
hi! link ErrorMsg Error
hi! VertSplit guibg=#b6a8a2 guifg=bg
hi! link EndOfBuffer LineNr
hi! link NonText Whitespace
hi! Conceal guifg=NONE guibg=NONE guisp=NONE gui=NONE
hi! MatchParen guifg=NONE guibg=#dad3d0 guisp=NONE gui=underline,bold
hi! link ModeMsg Normal
hi! link MoreMsg Normal
hi! link MsgArea Normal
hi! link MsgSeparator Normal

hi! link NormalFloat Pmenu
hi! link NormalNC Normal

hi! WarningMsg guibg=#fbf1be guifg=fg gui=italic,underline,bold
hi! Whitespace guifg=#b6a8a2 guibg=NONE guisp=NONE gui=NONE
hi! link SpecialKey Whitespace
hi! link Visual Search
hi! link VisualNOS Visual
hi! link Question Normal
hi! link EndOfBuffer Normal

" XXX - Only did up to here

" -------------- Spellchecker -------------------
hi! link SpellBad ErrorMsg
hi! SpellCap guifg=NONE guibg=NONE guisp=NONE gui=underline
hi! SpellLocal guifg=NONE guibg=NONE guisp=NONE gui=underline
hi! SpellRare guifg=NONE guibg=NONE guisp=NONE gui=underline

" -------------- VIM Only -----------------------
" if !has('nvim')
" 	hi! Tooltip guifg=#534946 guibg=#EBE2E0
" 	hi! Menu guifg=#534946 guibg=#EBE2E0
" endif

" -------------- Diffs --------------------------
  hi! DiffAdd guifg=#304D00 guibg=#E3FFB3 guisp=NONE gui=NONE
  hi! DiffChange guifg=#4D4000 guibg=#FFF5C4 guisp=NONE gui=NONE
  hi! DiffText guifg=#4D4000 guibg=#FFF5C4 guisp=NONE gui=bold
  hi! DiffDelete guifg=#751400 guibg=#fccec1 guisp=NONE gui=NONE

" -------------- Search & Replace ---------------
  hi! Search guibg=#DCD7F9 guifg=#5137e1 guisp=NONE gui=NONE
  " hi! IncSearch guibg=#DBEAFF guifg=#004AB3 guisp=NONE gui=NONE
  hi! IncSearch guibg=#5137e1 guifg=#DCD7F9 guisp=NONE gui=bold
  " hi! Search guibg=#E0D4D1 guifg=NONE guisp=NONE gui=NONE
  " hi! Substitute guibg=NONE guifg=NONE guisp=NONE gui=underline
  hi! link Substitute IncSearch

" -------------- Preferred groups ---------------
  " :h group-name
" Only colored ones should be statement, preproc, and conditional
hi! Comment guibg=NONE guifg=#8f8678 guisp=NONE gui=italic
hi! Identifier guibg=NONE guifg=fg guisp=NONE gui=NONE
hi! Constant guibg=NONE guifg=fg guisp=NONE gui=italic
  hi! Statement guibg=NONE guifg=fg guisp=NONE gui=italic
hi! PreProc guibg=NONE guifg=fg guisp=NONE gui=italic
  hi! Type guibg=NONE guifg=fg guisp=NONE gui=italic
  hi! Special guibg=NONE guifg=fg guisp=NONE gui=NONE
  hi! Underlined guibg=NONE guifg=fg guisp=NONE gui=underline
hi! Error guibg=#fccec1 guifg=#fg guisp=NONE gui=NONE
hi! link Todo WarningMsg
  hi! Ignore guibg=#F5F1F0 guifg=fg guisp=NONE gui=NONE

" -------------- More granular groups -----------
" -------------- XML ----------------------------
  hi! link xmlProcessingDelim Normal
  hi xmlTagName guifg=NONE guibg=NONE guisp=NONE gui=NONE

" -------------- Vim Script ---------------------
  " v-- These are normally linked to Type, which is italicized, leading to
  " lots of italics in this file
  hi! link vimGroup Normal
  hi! link vimHiGui Normal
  hi! link vimHiGroup Normal
  hi! link vimHiGuiFgBg Normal
  hi! vimCommentTitle guifg=NONE guibg=#EBE2E0 guisp=NONE gui=underline
  hi! vimCommentTitleLeader guifg=NONE guibg=#EBE2E0 guisp=NONE gui=NONE

" -------------- Help Text ----------------------
  hi! helpHyperTextJump guifg=NONE guifg=NONE gui=underline guisp=NONE
  " v-- Making this underlined can have weird effects since sometimes a
  " helpHeadline is empty and then you just have a weird line
  hi! helpHeadline guifg=NONE guibg=NONE guisp=NONE gui=bold

" -------------- vim-sneak ----------------------
  hi! link Sneak Visual
  hi! link SneakScope IncSearch
  " v-- For all matches except the first, where the cursor currently resides
  hi! link SneakLabel Search

" -------------- vim-dirvish --------------------
   " v-- items added to the arglist
   hi! link DirvishArg Search
   " v-- directories
   hi! DirvishPathTail guifg=NONE guibg=NONE guisp=NONE gui=bold

" -------------- quickfix -----------------------
   hi! link quickfixline Visual

" -------------- markdown -----------------------
   " hi! markdownHeadingDelimiter guifg=NONE guibg=NONE guisp=NONE gui=underline
   hi! markdownHeadingDelimiter guifg=NONE guibg=NONE guisp=NONE gui=underline
   " hi! link markdownH1Delimiter markdownHeadingDelimiter
   " hi! link markdownH2Delimiter markdownH1Delimiter
   " hi! link markdownH3Delimiter markdownH1Delimiter
   " hi! link markdownH4Delimiter markdownH1Delimiter
   " hi! link markdownH5Delimiter markdownH1Delimiter
   " hi! link markdownH6Delimiter markdownH1Delimiter

   hi! mkdHeading guifg=NONE guibg=NONE guisp=NONE gui=italic,bold,underline
   hi! link markdownH1 mkdHeading
   hi! link markdownH2 mkdHeading
   hi! link markdownH3 mkdHeading
   hi! link markdownH4 mkdHeading
   hi! link markdownH5 mkdHeading
   hi! link markdownH6 mkdHeading

   hi! markdownCode guifg=NONE guibg=NONE guisp=NONE gui=bold
   hi! link markdownCodeDelimiter folded
   hi! markdownBold guifg=NONE guibg=NONE guisp=NONE gui=bold
   hi! link markdownBoldDelimiter folded
   hi! markdownItalic guifg=NONE guibg=NONE guisp=NONE gui=italic
   hi! link markdownItalicDelimiter folded
   hi! markdownBoldItalic guifg=NONE guibg=NONE guisp=NONE gui=italic,bold
   hi! link markdownBoldItalicDelimiter folded
   hi! markdownUrl guifg=NONE guibg=NONE guisp=NONE gui=underline
   hi! link markdownLinkDelimiter folded
   hi! link markdownLinkDelimiter folded
   hi! markdownLinkText guifg=NONE guibg=NONE guisp=NONE gui=NONE
   hi! link markdownLinkTextDelimiter folded

" -------------- pandoc -----------------------
   hi! link pandocEmphasis markdownItalic
   hi! link pandocStrong markdownBold
   hi! link pandocEmphasisInStrong markdownBoldItalic
   " hi! pandocEmphasisInStrong guifg=NONE guibg=NONE guisp=NONE gui=italic,bold
   hi! link pandocAtxHeader mkdHeading
   hi! link pandocAtxStart markdownHeadingDelimter


" -------------- html -------------------------
"  Have to include this otherwise it will be highlighted with TabLineSel
hi! link htmlH1 mkdHeading
hi! link htmlH2 mkdHeading
hi! link htmlH3 mkdHeading
hi! link htmlH4 mkdHeading
hi! link htmlH5 mkdHeading
hi! link htmlH6 mkdHeading

" -------------- LSP ----------------------------
   hi! link LspDiagnosticsDefaultError Error
   hi! link LspDiagnosticsDefaultWarning WarningMsg

" -------------- Git ----------------------------
  hi! link diffAdded DiffAdd
  hi! link diffRemoved DiffDelete
  hi! link diffComment Comment
  hi! link diffChanged DiffChange
