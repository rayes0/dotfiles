" PLUGINS

call plug#begin('~/.config/nvim/plugged')

" Linting, Completiong, Language packs
Plug 'dense-analysis/ale'
"Plug 'autozimu/LanguageClient-neovim', { 'branch': 'next', 'do': 'bash install.sh' }
"Plug 'Shougo/echodoc.vim'
Plug 'Sheerun/vim-polyglot'
Plug 'Shougo/deoplete.nvim', { 'do': ':UpdateRemotePlugins' }
Plug 'deoplete-plugins/deoplete-dictionary'
Plug 'wellle/tmux-complete.vim'
Plug 'deoplete-plugins/deoplete-lsp'
"Plug 'nvim-lua/completion-nvim'
Plug 'neovim/nvim-lspconfig'

" Editing
Plug 'reedes/vim-pencil'
Plug 'vim-pandoc/vim-pandoc'
Plug 'vim-pandoc/vim-pandoc-syntax'
Plug 'ferrine/md-img-paste.vim'
Plug 'lervag/vimtex'
Plug 'luffah/vim-zim'
Plug 'tpope/vim-surround'
Plug 'mzlogin/vim-smali'

" Helpful Utilities
Plug 'mattn/webapi-vim'
Plug 'vim-scripts/taglist.vim'
Plug 'preservim/nerdtree'
Plug 'preservim/nerdcommenter'
"Plug 'troydm/shellasync.vim'
"Plug 'vim-voom/VOoM'
Plug 'isa/vim-matchit'
Plug 'rrethy/vim-hexokinase', { 'do': 'make hexokinase' }
Plug 'vim-scripts/taglist.vim'
Plug 'junegunn/vim-easy-align'
"Plug 'glepnir/galaxyline.nvim'
"Plug 'datwaft/bubbly.nvim'
"Plug 'jbyuki/nabla.nvim'

" Themes
Plug 'arzg/vim-substrata'
"Plug 'rayes0/blossom'

" Other Cool Things
Plug 'junegunn/goyo.vim'
"Plug 'kdav5758/TrueZen.nvim'
Plug 'dbeniamine/todo.txt-vim'
Plug 'lukas-reineke/indent-blankline.nvim', { 'branch': 'lua' }
"Plug 'yuttie/comfortable-motion.vim'
call plug#end()

" PLUGIN SETTINGS
"nnoremap <F3> :lua require("nabla").place_inline()<CR>

"let vim.g:bubbly_statusline = {j

let g:indent_blankline_char = '│'
let g:indent_blankline_show_first_indent_level = v:false
let g:indent_blankline_filetype_exclude = ['help', 'man', 'markdown', 'pandoc', 'nerdtree']
let g:indent_blankline_buftype_exclude = ['terminal']

let g:limelight_conceal_ctermfg = '240'
"let g:goyo_width = '110'

let g:templates_directory = '~/.config/nvim/templates'

"let g:ale_linters = {
	"\ 'python': ['pylint'],
	"\ 'vim': ['vint'],
	"\ 'cpp': ['clang'],
	"\ 'c': ['clang']
"\}
let g:ale_linters = {
			\ 'rust': ['analyzer', 'cargo'],
			\}
let g:ale_fixers = {
			\ '*': ['remove_trailing_lines', 'trim_whitespace'],
			\}
let g:ale_lint_on_text_changed = 'never'
let g:ale_hover_cursor = 0
let g:ale_hover_to_preview = 1
let g:ale_floating_preview = 1
let g:ale_hover_to_floating_preview = 1

let hexokinase_ftDisabled = ['pandoc', 'markdown']

let g:tmuxcomplete#trigger = ''


" GENERAL SETTINGS

set termguicolors
colorscheme blossom
"colorscheme rose-pine-dawn
"colorscheme sayo
"colorscheme substrata

set nocompatible
filetype plugin indent on
syntax on
packloadall

set tabstop=4 shiftwidth=4 softtabstop=4 smarttab autoindent
set wrap breakindent

"set ignorecase
"set smartcase "autoswitch to case-sensitive if capital letters are used

let g:netrw_dirhistmax = 0

au CursorHold * checktime

autocmd BufNewFile,BufRead *.mdown set filetype=pandoc
autocmd BufNewFile *.mdown r ~/.config/nvim/templates/template.mdown | set expandtab
autocmd BufNewFile *.mkdwn r ~/.config/nvim/templates/template.mkdwn

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

noremap <silent><C-a> :call ToggleHiddenAll()<CR>

set rulerformat=%20(%)
set rulerformat+=%=
"set rulerformat+=%{&modified?'*':''}
set rulerformat+=\ %v:%l\ ~\ %p%%
set rulerformat+=\ \|\ %Y%*

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


" Completion and LSP
lua require'lspconfig'.rust_analyzer.setup{}
lua require'lspconfig'.bashls.setup{}

set omnifunc=syntaxcomplete#Complete
set completeopt=longest,menuone,noinsert

let g:deoplete#enable_at_startup = 1
"call deoplete#custom#option('auto_complete', 'true')
call deoplete#custom#option('auto_complete_popup', 'manual')
call deoplete#custom#option('auto_complete_delay', '0')
call deoplete#custom#option('camel_case', 'true')
call deoplete#custom#option('ignore_case', 'true')
"call deoplete#custom#option('candidate_marks', [''

call deoplete#custom#option('keyword_patterns', { 
			\ 'pandoc': '\\?[a-zA-Z_]\w*',
			\ 'tex': '\\?[a-zA-Z_]\w*', })

call deoplete#custom#option('sources', { 
			\ '_': [], 
			\ 'pandoc': ['dictionary'], })

call deoplete#custom#var('terminal', 'require_same_tab', v:false)

call deoplete#custom#var('around', {
			\ 'range_above': 20,
			\ 'range_below': 20,
			\ 'mark_above': '↑',
			\ 'mark_below': '↓',
			\ 'mark_changes': '*', })

call deoplete#custom#var('file', { 'enable_slash_completion': v:true, })

call deoplete#custom#filter('converter_reorder_attr', 'attrs_order', {
			\ '_': { 'kind': [
			\			'File',
			\           'lsp',
			\			'dictionary',
			\			'Buffer',
			\		]}})

inoremap <silent><expr> <TAB> 
			\ pumvisible() ? "\<C-n>" :
			\ <SID>check_back_space() ? "\<TAB>" :
			"\ deoplete#manual_complete()
			\ deoplete#complete()
inoremap <silent><expr> <S-TAB>
			\ pumvisible() ? "\<C-p>" :
			\ <SID>check_back_space() ? "\<TAB>" :
			\ deoplete#complete()
inoremap <expr> <CR> pumvisible() ? "\<C-y>" : "\<C-g>u\<CR>"
inoremap <expr><C-g> deoplete#undo_completion()

function! s:check_back_space() abort
   let col = col('.') - 1
   return !col || getline(".")[col - 1] =~ '\s'
endfunction


" FOLDING

inoremap <F9> <C-O>za
nnoremap <F9> za
onoremap <F9> <C-C>za
vnoremap <F9> zf


" KEYMAPS

" Yank and paste to system clipboard
map <leader>y "+y<CR>
map <leader>p "+p<CR>

nnoremap <silent> <leader><leader> :set hlsearch!<CR>
nnoremap <silent> <leader><leader> :noh<CR>
noremap <silent> <F5> :setlocal spell!<CR>

noremap <C-s> :w<CR>
noremap! <C-BS> <C-w>
noremap! <C-h> <C-w>

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
"noremap <silent> <leader>g :Goyo<CR> 
noremap <silent> <F12> :Goyo<CR> 
noremap <silent> <leader>l :Limelight!!<CR>

map <F10> :echo "hi<" . synIDattr(synID(line("."),col("."),1),"name") . '> trans<'
\ . synIDattr(synID(line("."),col("."),0),"name") . "> lo<"
\ . synIDattr(synIDtrans(synID(line("."),col("."),1)),"name") . ">"<CR>

noremap <silent> <F8> :TlistToggle<CR>

noremap <silent> <C-c> :ALEToggle<CR>

" Language settings

" Shell
let g:sh_fold_enabled = 3

" Rust
"let g:rust_conceal = 1
let g:rust_fold = 1
