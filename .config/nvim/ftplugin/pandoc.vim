let g:pandoc#filetypes#pandoc_markdown = 0
let g:pandoc#folding#fold_yaml = 1
let g:pandoc#syntax#conceal#blacklist = ["dashes", "atx"]
"autocmd FileType pandoc call Pandoc()
"autocmd FileType pandoc set signcolumn=yes:2

setlocal spell spelllang=en_ca
Goyo 120
let g:pdf_viewer = 'zathura'

let g:file = expand('%:p')
let g:pdf = "/tmp/" . expand('%:t:r') . ".pdf"

function NotesPreview()
    " compile the pdf from this file, then start the pdf viewer "
    silent execute '!pandoc' '-f markdown' '--filter pandoc-crossref' g:file '-o' g:pdf
    silent execute '!' g:pdf_viewer g:pdf '&>/dev/null &'
endfunction

"call NotesPreview()

" when saving, also recompile the pdf (this should update the viewer automatically) "
autocmd BufWritePost *.mdown execute '!pandoc' '-f markdown' '--filter pandoc-crossref' g:file '-o' g:pdf

autocmd VimLeave *.mdown execute '!rm' g:pdf

nmap <C-p> :call NotesPreview()<CR>
nmap <buffer><silent> <leader>p :call mdip#MarkdownClipboardImage()<CR>

" there are some defaults for image directory and image name, you can change them
" let g:mdip_imgdir = 'img'
" let g:mdip_imgname = 'image'
