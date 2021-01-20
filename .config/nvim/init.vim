set nocompatible
filetype on
filetype indent on
filetype plugin on
filetype plugin indent on
syntax on

let &t_8f = "\<Esc>[38:2:%lu:%lu:%lum"
let &t_8b = "\<Esc>[48:2:%lu:%lu:%lum"
colorscheme sayo
set laststatus=1

inoremap \ \<C-N>

map <F10> :echo "hi<" . synIDattr(synID(line("."),col("."),1),"name") . '> trans<'
\ . synIDattr(synID(line("."),col("."),0),"name") . "> lo<"
\ . synIDattr(synIDtrans(synID(line("."),col("."),1)),"name") . ">"<CR>

" PLUGINS

" Plugins will be downloaded under the specified directory.
call plug#begin('~/.config/nvim/plugged')

" Declare the list of plugins.
Plug 'junegunn/goyo.vim'
Plug 'junegunn/limelight.vim'
Plug 'reedes/vim-pencil'
Plug 'preservim/nerdtree'
Plug 'vim-latex/vim-latex'
Plug 'vim-pandoc/vim-pandoc'
Plug 'vim-pandoc/vim-pandoc-syntax'
Plug 'ferrine/md-img-paste.vim'
Plug 'jakykong/vim-zim'

call plug#end()

" PLUGIN SETTINGS

let g:limelight_conceal_ctermfg = '240'

let g:templates_directory = '~/.config/nvim/templates'

nnoremap <F4> :NERDTreeToggle<CR>

set completeopt=menuone,noinsert

" Pandoc-markdown
let g:pandoc#filetypes#pandoc_markdown = 0
let g:pandoc#folding#fold_yaml = 1
augroup pandocnotes
	autocmd BufNewFile,BufRead *.mdown set filetype=markdown.pandoc
	autocmd BufNewFile *.mdown r ~/.config/nvim/templates/template.mdown | set expandtab
	autocmd FileType markdown.pandoc call Pandoc_mdown()
	function Pandoc_mdown()
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
		
		call NotesPreview()
		
		" when saving, also recompile the pdf (this should update the viewer automatically) "
		autocmd BufWritePost *.mdown execute '!pandoc' '-f markdown' '--filter pandoc-crossref' g:file '-o' g:pdf
		
		autocmd VimLeave *.mdown execute '!rm' g:pdf

		nmap <C-p> :call NotesPreview()<CR>
	endfunction
	nmap <buffer><silent> <leader>p :call mdip#MarkdownClipboardImage()<CR>
	" there are some defaults for image directory and image name, you can change them
	" let g:mdip_imgdir = 'img'
	" let g:mdip_imgname = 'image'
augroup END
autocmd BufNewFile *.mkdwn r ~/.config/nvim/templates/template.mkdwn

" FOLDING

inoremap <F9> <C-O>za
nnoremap <F9> za
onoremap <F9> <C-C>za
vnoremap <F9> zf

" autocmd BufWinLeave ?* mkview
" autocmd BufWinEnter ?* silent loadview
function MarkdownLevel()
    if getline(v:lnum) =~ '^# .*$'
        return ">1"
    endif
    if getline(v:lnum) =~ '^## .*$'
        return ">2"
    endif
    if getline(v:lnum) =~ '^### .*$'
        return ">3"
    endif
    if getline(v:lnum) =~ '^#### .*$'
        return ">4"
    endif
    if getline(v:lnum) =~ '^##### .*$'
        return ">5"
    endif
    if getline(v:lnum) =~ '^###### .*$'
        return ">6"
    endif
    return "=" 
endfunction
au BufEnter Volume*.md setlocal foldexpr=MarkdownLevel()  
au BufEnter Volume*.md setlocal foldmethod=expr


" LaTeX
set shellslash
let g:tex_flavor='latex'

