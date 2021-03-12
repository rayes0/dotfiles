let g:TodoTxtForceDoneName='done.txt'

" Use todo#Complete as the omni complete function for todo files
setlocal omnifunc=todo#Complete

" Auto complete projects
imap <buffer> + +<C-X><C-O>

" Auto complete contexts
imap <buffer> @ @<C-X><C-O>

" let g:Todo_fold_char='@'

au VimEnter * hi link TodoContext Comment
