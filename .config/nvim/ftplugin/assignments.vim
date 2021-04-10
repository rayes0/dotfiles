setlocal spell spelllang=en_ca
Goyo 120
		
let g:pdf_viewer = 'zathura'

let g:file = expand('%:p')
let g:pdf = "/tmp/" . expand('%:t:r') . ".pdf"
let g:out = expand('%:p:r')

function NotesPreview()
    " compile the pdf from this file, then start the pdf viewer "
    silent execute '!pandoc' '-f markdown' g:file '-o' g:pdf
    silent execute '!' g:pdf_viewer g:pdf '&>/dev/null &'
endfunction

call NotesPreview()

" when saving, also recompile the pdf (this should update the viewer automatically) "
autocmd! BufWritePost *.mkdwn execute '!pandoc' '-f markdown' g:file '-o' g:pdf

autocmd VimLeave *.mkdwn execute '!rm' g:pdf

nmap <C-p> :call NotesPreview()<CR>

nmap <buffer><silent> <leader>p :call mdip#MarkdownClipboardImage()<CR>
" there are some defaults for image directory and image name, you can change them
" let g:mdip_imgdir = 'img'
" let g:mdip_imgname = 'image'
