" Vim color file Disco
" Maintainer: [jsit] <jay@jaysitter.com>
" Last Change:  
" URL: http://jaysitter.com
" Description: A full set of 1-, 8-, 16-, 88-, 256-, and GUI-color-compatible colors.

" We need to use :h color-nr numbers for cterm, in case we are on a low-color
" terminal
let s:color_map = {
	\'Black'       : 0,
	\'DarkRed'     : 1,
	\'DarkGreen'   : 2,
	\'DarkYellow'  : 3,
	\'DarkBlue'    : 4,
	\'DarkMagenta' : 5,
	\'DarkCyan'    : 6,
	\'LightGray'   : 7,
	\'DarkGray'    : 8,
	\'Red'         : 9,
	\'Green'       : 10,
	\'Yellow'      : 11,
	\'Blue'        : 12,
	\'Magenta'     : 13,
	\'Cyan'        : 14,
	\'White'       : 15,
\}

" Sets the highlighting for the given group. {{{
" From github.com/jsit/vim-tomorrow-theme
" Originally by Chris Kempson and contributors
fun! <SID>set_colors(group, fg, bg, attr)

	if !empty(a:fg)
		if type(a:fg) == 1 " If a:bg is a string, look it up for cterm
			exec "hi " . a:group . " guifg=" . a:fg . " ctermfg=" . get(s:color_map, a:fg)
		else
			exec "hi " . a:group . " guifg=" . a:fg . " ctermfg=" . a:fg
		endif
	endif

	if !empty(a:bg)
		if type(a:bg) == 1 && a:bg != 'NONE' " If a:bg is a string, look it up for cterm
			exec "hi " . a:group . " guibg=" .  a:bg . " ctermbg=" . get(s:color_map, a:bg)
		else
			exec "hi " . a:group . " guibg=" . a:bg . " ctermbg=" . a:bg
		endif
	endif

	if a:attr != ""
		exec "hi " . a:group . " gui=" . a:attr . " cterm=" . a:attr . " term=" . a:attr
	endif

endfun
" }}}



hi clear

if exists("syntax_on")
	syntax reset
endif

let g:colors_name = "disco"

" Check to see if we can do colors 8-15
if has('gui_running') || (&t_Co > 8 && (!exists('g:disco_nobright') || g:disco_nobright != 1))
	let s:gt_eight = 1
else
	let s:gt_eight = 0
endif

" Check to see if we can do italic
if (&t_ZH != '' && &t_ZH != '[7m')
	let s:italic = 1
else
	let s:italic = 0
endif



" Define our colors based on the background setting {{{
if &background == "dark" && s:gt_eight

	let s:dim          = 'DarkGray'
	let s:dimtwo       = 'LightGray'

	let s:bg           = 'Black'
	let s:fg           = 'White'

else

	let s:fg           = 'Black'

	if s:gt_eight
		let s:bg           = 'White'
		let s:dim          = 'LightGray'
		let s:dimtwo       = 'DarkGray'
	else
		let s:bg           = 'NONE'
		let s:dim          = 'LightGray'
		let s:dimtwo       = 'LightGray'
	endif

endif



if &background == "dark" && s:gt_eight && (!exists('g:disco_fg_dark') || g:disco_fg_dark != 1)

	let s:red          = 'Red'
	let s:green        = 'Green'
	let s:yellow       = 'Yellow'
	let s:blue         = 'Blue'
	let s:magenta      = 'Magenta'
	let s:cyan         = 'Cyan'

	let s:dimred       = 'DarkRed'
	let s:dimgreen     = 'DarkGreen'
	let s:dimyellow    = 'DarkYellow'
	let s:dimblue      = 'DarkBlue'
	let s:dimmagenta   = 'DarkMagenta'
	let s:dimcyan      = 'DarkCyan'

	let s:brightyellow = 'Yellow'

else

	let s:red          = 'DarkRed'
	let s:green        = 'DarkGreen'
	let s:yellow       = 'DarkYellow'
	let s:blue         = 'DarkBlue'
	let s:magenta      = 'DarkMagenta'
	let s:cyan         = 'DarkCyan'

	if s:gt_eight

		let s:dimred       = 'Red'
		let s:dimgreen     = 'Green'
		let s:dimyellow    = 'Yellow'
		let s:dimblue      = 'Blue'
		let s:dimmagenta   = 'Magenta'
		let s:dimcyan      = 'Cyan'

		let s:brightyellow = 'Yellow'

	else

		let s:dimred       = s:red
		let s:dimgreen     = s:green
		let s:dimyellow    = s:yellow
		let s:dimblue      = s:blue
		let s:dimmagenta   = s:magenta
		let s:dimcyan      = s:cyan

		let s:brightyellow = s:yellow

	endif
endif

" Use something other than red if user has asked to use red only for errors
if exists('g:disco_red_error_only') && g:disco_red_error_only == 1
	let s:truered = s:red
	let s:red     = s:dimcyan
	let s:dimred = s:dimcyan
else
	let s:truered = s:red
	let s:red     = s:red
	let s:dimred = s:dimred
endif
" }}}

if exists('g:disco_color_map')
	for [s:key, s:val] in items(g:disco_color_map)
		execute 'let s:' . s:key . ' = "' . s:val . '"'
	endfor
endif



" Highlight Groups (:h highlight-groups) {{{

if s:dimtwo != s:dim " Needs to be different from Comment
	call <SID>set_colors("ColorColumn"  , "" , s:dim , "")
	call <SID>set_colors("CursorColumn" , "" , s:dim , "")
	if s:gt_eight " Only turn off bold if we have enough colors
		call <SID>set_colors("CursorLine" , "" , s:dim , "NONE")
	else
		call <SID>set_colors("CursorLine" , "" , s:dim , "")
	endif
else
	call <SID>set_colors("ColorColumn"  , "NONE" , "NONE" , "")
	call <SID>set_colors("CursorColumn" , "NONE" , "NONE" , "")
	call <SID>set_colors("CursorLine"   , ""     , s:dim  , "")
endif

call <SID>set_colors("Conceal"  , ""     , "NONE" , "")
call <SID>set_colors("Cursor"   , "NONE" , "NONE" , "reverse")
call <SID>set_colors("CursorIM" , ""     , ""     , "")

call <SID>set_colors("CursorLineNr" , "NONE" , s:dim      , "")
call <SID>set_colors("Directory"    , s:blue , ""         , "")
call <SID>set_colors("DiffAdd"      , s:dimgreen, "NONE", "")
call <SID>set_colors("DiffDelete"   , s:dimred,   "NONE", "")
call <SID>set_colors("DiffChange"   , s:dimcyan, "NONE", "")
call <SID>set_colors("DiffText"     , s:magenta, "NONE", "")
hi link EndOfBuffer NonText
call <SID>set_colors("ErrorMsg"     , s:fg     , s:truered      , "")

if s:dimtwo != s:dim " Needs to be different from SignColumn
	call <SID>set_colors("VertSplit" , s:dimtwo , s:dimtwo , "NONE")
else
	call <SID>set_colors("VertSplit" , s:fg     , s:fg , "reverse")
endif

if s:dimtwo != s:dim
	call <SID>set_colors("Folded"     , s:dimtwo , s:dim    , "")
	call <SID>set_colors("FoldColumn" , s:dimtwo , s:dim    , "")
	call <SID>set_colors("SignColumn" , s:dimtwo , s:dim    , "")
else
	call <SID>set_colors("Folded"     , "NONE"   , s:dimtwo , "")
	call <SID>set_colors("FoldColumn" , "NONE"   , s:dimtwo , "")
	call <SID>set_colors("SignColumn" , "NONE"   , s:dimtwo , "")
endif

call <SID>set_colors("IncSearch"  , s:brightyellow , "Black" , "reverse")
call <SID>set_colors("LineNr"     , s:dim          , ""      , "")
call <SID>set_colors("MatchParen" , ""             , "NONE"  , "underline,bold")
call <SID>set_colors("ModeMsg"    , s:green        , ""      , "")
call <SID>set_colors("MoreMsg"    , s:green        , ""      , "")
call <SID>set_colors("NonText"    , s:dim          , ""      , "")

if &background == "dark" && has('gui_running')
	call <SID>set_colors("Normal" , "White" , "Black" , "")
else
	call <SID>set_colors("Normal" , ""      , ""      , "")
endif

call <SID>set_colors("InfoPopup", s:fg, s:dim, "")

call <SID>set_colors("PMenu"        , s:fg           , s:dim          , "")

if s:dimtwo != s:dim
	call <SID>set_colors("PMenuSel" , s:dim , s:dimtwo , "")
else
	call <SID>set_colors("PMenuSel" , s:dim , s:fg     , "")
endif

call <SID>set_colors("PMenuSbar"        , s:fg       , s:dim          , "")
call <SID>set_colors("PMenuThumb"       , s:fg       , s:dim          , "")
call <SID>set_colors("Question"         , s:green    , ""             , "")
call <SID>set_colors("Search"           , s:brightyellow, "Black", "reverse")
call <SID>set_colors("SpecialKey"       , s:dim      , ""             , "")
call <SID>set_colors("SpellBad"         , s:dimred   , s:fg           , "reverse")
call <SID>set_colors("SpellCap"         , ""         , s:truered          , "reverse")
call <SID>set_colors("SpellLocal"       , ""         , s:truered          , "reverse")
call <SID>set_colors("SpellRare"        , s:dimred   , s:fg           , "reverse")
call <SID>set_colors("StatusLine"       , ""         , ""             , "reverse")
call <SID>set_colors("StatusLineNC"     , s:dim      , ""             , "")
call <SID>set_colors("StatusLineTerm"   , s:green    , "NONE"         , "reverse")
call <SID>set_colors("StatusLineTermNC" , s:dimgreen , "NONE"         , "reverse")
call <SID>set_colors("TabLine"          , s:fg       , s:dim          , "NONE")
call <SID>set_colors("TabLineFill"      , s:dim      , s:dimtwo       , "")
call <SID>set_colors("TabLineSel"       , ""         , ""             , "NONE")
call <SID>set_colors("Title"            , s:magenta     , ""             , "")
call <SID>set_colors("Visual"           , ""         , s:dim          , "")
call <SID>set_colors("VisualNOS"        , s:dim      , ""             , "")
call <SID>set_colors("WarningMsg"       , s:truered      , "NONE"             , "")
call <SID>set_colors("WildMenu"         , s:green    , s:dim          , "")

call <SID>set_colors("Underlined" , ""     , ""       , "underline")
call <SID>set_colors("Ignore"     , s:dim  , ""       , "")
call <SID>set_colors("Error"      , s:truered  , "White"  , "reverse")
if (s:italic)
	call <SID>set_colors("Todo"       , s:yellow   , "NONE" , "reverse,italic")
else
	call <SID>set_colors("Todo"       , s:yellow   , "NONE" , "reverse")
endif

" End Highlight Groups }}}



" Group Names (:h group-name) {{{

if (s:italic)
	call <SID>set_colors("Comment", s:dimtwo, "", "italic")
else
	call <SID>set_colors("Comment", s:dimtwo, "", "")
endif

call <SID>set_colors("Constant", s:green, "", "")
hi link String    Constant
hi link Character Constant
hi link Number    Constant
hi link Boolean   Constant
hi link Float     Constant

if s:gt_eight " Only turn off bold if we have enough colors
	call <SID>set_colors("Identifier", s:cyan, "", "NONE")
else
	call <SID>set_colors("Identifier", s:cyan, "", "")
endif
hi link Function Identifier

call <SID>set_colors("Statement", s:magenta, "", "")
hi link Conditional Statement
hi link Repeat      Statement
hi link Label       Statement
hi link Operator    Statement
hi link Keyword     Statement
hi link Exception   Statement

call <SID>set_colors("PreProc", s:blue, "", "")
hi link Include   PreProc
hi link Define    PreProc
hi link Macro     PreProc
hi link PreCondit PreProc

call <SID>set_colors("Type", s:yellow, "", "")
hi link StorageClass Type
hi link Structure    Type
hi link Typedef      Type

call <SID>set_colors("Special", s:red, "", "")
hi link SpecialChar    Special
hi link Tag            Special
hi link Delimiter      Special
hi link SpecialComment Special
hi link Debug          Special

" End Group Names }}}







" Clean up
delf <SID>set_colors
unlet s:dim s:dimtwo s:bg s:fg s:blue s:yellow s:red s:green s:cyan s:magenta s:brightyellow s:dimred s:dimgreen s:dimcyan s:truered

" ex: set noexpandtab nolist foldmethod=marker:
