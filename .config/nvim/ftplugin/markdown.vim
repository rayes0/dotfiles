SoftPencil
setlocal spell spelllang=en_ca
Goyo 120

inoremap . .<C-g>u
inoremap ! !<C-g>u
inoremap ? ?<C-g>u
inoremap : :<C-g>u

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

cd %:p:h
