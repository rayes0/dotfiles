SoftPencil
augroup VimEnter * Goyo 110
setlocal spell spelllang=en_ca

let g:zim_notebook = '~/Notes/Zim'
let g:zim_notebooks_dir = '~/Notes/Zim'
let g:zim_keymapping={
     \ 'continue_list':'<Leader><CR>',
     \ 'jump':'gf',
     \ 'jump_back':'<Leader>G',
     \ 'bold':'<Leader>b',
     \ 'italic':'<Leader>i',
     \ 'highlight':'<Leader>h',
     \ 'strike':'<Leader>s',
     \ 'title':'<Leader>t',
     \ 'header':'<Leader>H',
     \ 'li':'<Leader>l',
     \ 'checkbox':'<Leader>c',
     \ 'checkbox_yes':'<Leader>y',
     \ 'checkbox_no':'<Leader>n',
     \ 'checkbox_moved':'<Leader>>',
     \ 'date':'<Leader>d',
     \ 'datehour':'<Leader>D',
     \ 'showimg': '<F3>',
     \ 'editimg': '<S-F3>',
     \ 'showfile':'<Leader><Tab>',
     \ 'editfile':'<Leader><S-Tab>',
     \ 'nextKeyElement':'<C-Down>',
     \ 'prevKeyElement':'<C-Up>',
     \ 'nextTitle':'<S-Down>',
     \ 'prevTitle':'<S-Up>',
     \}

function ZimLevel()
    if getline(v:lnum) =~ '^= .* =$'
        return ">3"
    endif
    if getline(v:lnum) =~ '^== .* ==$'
        return ">2"
    endif
    if getline(v:lnum) =~ '^=== .* ===$'
        return ">1"
    endif
    if getline(v:lnum) =~ '^==== .* ====$'
        return ">1"
    endif
    if getline(v:lnum) =~ '^===== .* =====$'
        return ">1"
    endif
    if getline(v:lnum) =~ '^====== .* ======$'
        return ">1"
    endif
    if getline(v:lnum) =~ '^Content-Type: .*$' || getline(v:lnum) =~ '^Wiki-Format: .*$' || getline(v:lnum) =~ '^Creation-Date: .*$'
        return "1"
    endif
    if getline(v:lnum) =~ '^$' && getline(v:lnum-1) =~ '^Content-Type: .*$' || getline(v:lnum-1) =~ '^Wiki-Format: .*$' || getline(v:lnum-1) =~ '^Creation-Date: .*$'
        return "0"
    endif
    return "=" 
endfunction

autocmd VimEnter * setlocal foldmethod=expr
autocmd VimEnter * hi link zimHeader Comment
autocmd VimEnter * hi link zimHeaderParam Comment
setlocal foldexpr=ZimLevel()

"syn match zimHeader /^[^:]*:/ contained contains=@NoSpell nextgroup=ZimHeaderParam
"syn match zimHeaderParam /.*/ contained contains=@NoSpell
"syn region zimHeaderRegion
"      \ start=/\%1l^\(Content-Type\|Wiki-Format\|Creation-Date\):\%1l\c/
"      \ end=/\%4l\([A-Z]*:.*\)\?\c/
"      \ contains=zimHeader transparent fold keepend extend
"hi link vimModeline LineNr
