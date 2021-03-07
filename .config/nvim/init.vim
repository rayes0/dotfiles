set nocompatible
filetype on
filetype indent on
filetype plugin on
filetype plugin indent on
syntax on

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
"Plug 'rayes0/blossom.vim'
Plug 'dbeniamine/todo.txt-vim'
Plug 'vim-voom/VOoM'

call plug#end()

set laststatus=1

set tabstop=4
set shiftwidth=4

inoremap \ \<C-N>

map <F10> :echo "hi<" . synIDattr(synID(line("."),col("."),1),"name") . '> trans<'
\ . synIDattr(synID(line("."),col("."),0),"name") . "> lo<"
\ . synIDattr(synIDtrans(synID(line("."),col("."),1)),"name") . ">"<CR>

" TABLINE

set tabline=%!MyTabLine()

function MyTabLine()
	let s = ''
	for i in range(tabpagenr('$'))
		" select the highlighting
		if i + 1 == tabpagenr()
			let s .= '%#TabLineSel#'
		else
			let s .= '%#TabLine#'
    	endif

    	" set the tab page number (for mouse clicks)
    	let s .= '%' . (i + 1) . 'T' 

    	" the label is made by MyTabLabel()
    	let s .= ' %{MyTabLabel(' . (i + 1) . ')} '
  	endfor

  	" after the last tab fill with TabLineFill and reset tab page nr
  	let s .= '%#TabLineFill#%T'

  	" right-align the label to close the current tab page
  	if tabpagenr('$') > 1 
    	let s .= '%=%#TabLine#%999XClose '
  	endif

  	return s
endfunction

function MyTabLabel(n)
	let buflist = tabpagebuflist(a:n)
	let winnr = tabpagewinnr(a:n)
	let label =  bufname(buflist[winnr - 1]) 
	return fnamemodify(label, ":t") 
endfunction


" STATUSLINE

"set statusline=
"set statusline+=%2*%{toupper(g:currentmode[mode()])}
"set statusline+=%=
"set statusline+=%5*\ %v:%l\/%L
"set statusline+=%4*\ %Y%4*
"
"let g:currentmode = {
"            \ 'n'  : 'normal',
"            \ 'no' : 'n-op',
"            \ 'v'  : 'visual',
"            \ 'V'  : 'line',
"            \ '' : 'block',
"            \ 's'  : 'selection',
"            \ 'S'  : 'line select',
"            \ '' : 'block select',
"            \ 'i'  : 'insert',
"            \ 'R'  : 'replace',
"            \ 'Rv' : 'visual replace',
"            \ 'c'  : 'command',
"            \ 'cv' : 'vim execute',
"            \ 'ce' : 'execute',
"            \ 'r'  : 'prompt',
"            \ 'rm' : 'more',
"            \ 'r?' : 'confirm',
"            \ '!'  : 'shell',
"            \ 't'  : 'terminal'
"                   \}
"

" PLUGIN SETTINGS

let g:limelight_conceal_ctermfg = '240'

let g:templates_directory = '~/.config/nvim/templates'

nnoremap <F4> :NERDTreeToggle<CR>

set completeopt=menuone,noinsert

augroup pandocnotes
	autocmd BufNewFile,BufRead *.mdown set filetype=markdown.pandoc
	autocmd BufNewFile *.mdown r ~/.config/nvim/templates/template.mdown | set expandtab
	"autocmd FileType pandoc set signcolumn=yes:2
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

" TODO SETTINGS
let g:TodoTxtForceDoneName='done.txt'

" Use todo#Complete as the omni complete function for todo files
au filetype todo setlocal omnifunc=todo#Complete

" Auto complete projects
au filetype todo imap <buffer> + +<C-X><C-O>

" Auto complete contexts
au filetype todo imap <buffer> @ @<C-X><C-O>

" let g:Todo_fold_char='@'


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

" Pandoc-markdown
let g:pandoc#filetypes#pandoc_markdown = 0
let g:pandoc#folding#fold_yaml = 1
let g:pandoc#syntax#conceal#blacklist = ["dashes", "atx"]

" Set colorscheme at end to prevent pandoc from overriding
set termguicolors
colorscheme blossom
" colorscheme sayo
