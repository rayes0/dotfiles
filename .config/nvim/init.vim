" PLUGINS

call plug#begin('~/.config/nvim/plugged')

Plug 'junegunn/goyo.vim'
Plug 'junegunn/limelight.vim'
Plug 'reedes/vim-pencil'
Plug 'preservim/nerdtree'
Plug 'vim-latex/vim-latex'
Plug 'vim-pandoc/vim-pandoc'
Plug 'vim-pandoc/vim-pandoc-syntax'
Plug 'ferrine/md-img-paste.vim'
Plug 'luffah/vim-zim'
"Plug 'rayes0/blossom.vim'
Plug 'dbeniamine/todo.txt-vim'
"Plug 'vim-voom/VOoM'
"Plug 'neoclide/coc.nvim', {'branch': 'release'}
Plug 'ervandew/supertab'
Plug 'dense-analysis/ale'
"Plug 'Shougo/deoplete.nvim', { 'do': ':UpdateRemotePlugins' }
Plug 'rrethy/vim-hexokinase', { 'do': 'make hexokinase' }

call plug#end()

set nocompatible
filetype on
filetype plugin indent on
syntax on
packloadall

set tabstop=4 shiftwidth=4 softtabstop=4 smarttab autoindent
set wrap breakindent

"set ignorecase
"set smartcase "autoswitch to case-sensitive if capital letters are used

let g:netrw_dirhistmax = 0

au CursorHold * checktime

set completeopt=menuone,noinsert

autocmd BufNewFile,BufRead *.mdown set filetype=pandoc
autocmd BufNewFile *.mdown r ~/.config/nvim/templates/template.mdown | set expandtab
autocmd BufNewFile *.mkdwn r ~/.config/nvim/templates/template.mkdwn

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

set laststatus=1
let s:hidden_all = 0
function! ToggleHiddenAll()
    if s:hidden_all  == 0
        let s:hidden_all = 1
        set noshowmode
        set noruler
        set laststatus=0
        set noshowcmd
    else
        let s:hidden_all = 0
        set showmode
        set ruler
        set laststatus=1
        set showcmd
    endif
endfunction

noremap <C-a> :call ToggleHiddenAll()<CR>

set rulerformat=%25(%)
set rulerformat+=%=
"set rulerformat+=%{&modified?'*':''}
set rulerformat+=\ %v:%l\ ~\ %p%%
set rulerformat+=\ \|\ %Y%*

"set statusline=
"set statusline+=\ %{toupper(g:currentmode[mode()])}
"set statusline+=\ %{&modified?'[+]':''}
"set statusline+=%=
"set statusline+=\ %v:%l\/%L
"set statusline+=\ %Y%4*

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


" PLUGIN SETTINGS

let g:limelight_conceal_ctermfg = '240'
let g:goyo_width = '110'

let g:templates_directory = '~/.config/nvim/templates'

" FOLDING

inoremap <F9> <C-O>za
nnoremap <F9> za
onoremap <F9> <C-C>za
vnoremap <F9> zf

" Set colorscheme at end to prevent pandoc from overriding
set termguicolors
colorscheme blossom
"colorscheme rose-pine-dawn
" colorscheme sayo

" KEYMAPS

" Yank to system clipboard
map <leader>y "+y<CR>
map <leader>p "+p<CR>

nnoremap <silent> <leader><leader> :set hlsearch!<CR>
nnoremap <silent> <leader><leader> :noh<CR>
noremap <silent> <F5> :setlocal spell!<CR>

noremap <C-s> :w<CR>

" scroll window in next frame
nnoremap <silent> <leader>j <c-w>w<c-d><c-w>W
nnoremap <silent> <leader>d <c-w>w<c-u><c-w>W

" Save, restore, and clear sessions
nmap <leader>ss :wa<cr>:mksession! $HOME/.nvimsessions/
nmap <leader>rs :wa<cr>:source $HOME/.nvimsessions/
nmap <leader>ds :!rm -r "$HOME/.nvimsessions/*"

" Open file located in the same directory as the current one
nmap <leader>e :e <c-r>=expand('%:p:h').'/'<cr>

map <silent> <C-l><C-l> :set number! relativenumber!<CR>

noremap <silent> <F4> :NERDTreeToggle<CR> 
noremap <silent> <leader>f :NERDTreeToggle<CR> 
noremap <silent> <leader>g :Goyo<CR> 
noremap <silent> <leader>l :Limelight!!<CR>
