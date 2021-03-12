" LILYPOND

filetype off
set runtimepath+=~/.local/lilypond/usr/share/lilypond/current/vim/
filetype on
syntax on

let g:pdf_viewer = 'zathura'

let g:file = expand('%:p')
let g:out = "/tmp/" . expand('%:t:r')
let g:pdf = "/tmp/" . expand('%:t:r') . ".pdf"

function! LilypondPreview()
    " compile the pdf from this file, then start the pdf viewer "
    silent execute '!lilypond' '-o' g:out g:file 
    silent execute '!' g:pdf_viewer g:pdf '&>/dev/null &'
endfunction

silent call LilypondPreview()

" on exit, remove the pdf as it is no longer needed "
autocmd VimLeave *.ly execute '!rm' g:pdf

" when saving, also recompile the pdf (this should update the viewer automatically) "
autocmd BufWritePost *.ly execute '!lilypond' '-o' g:out g:file

nmap <C-p> :call LilypondPreview()<CR>
