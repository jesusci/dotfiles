" ===========================
"       Templates
" ==========================
"""" Templates for python
function PySKL()
    :read ~/.vim/templates/skeleton.py
endfunction

function PyClassSKL()
    :read ~/.vim/templates/class_skeleton.py
endfunction

"""" Templates for c
function CSKL()
    :read ~/.vim/templates/skeleton.c
endfunction

function CClassSKL()
    :read ~/.vim/templates/class_skeleton.c
endfunction

"""" Templates for RobotFramework
function RFSKL()
    :read ~/.vim/templates/skeleton.robot
endfunction


" ===========================
"       My functions
" ===========================

"""" Search word in choosen lines
function SearchIn(ms,me,mw)
    let mystart = a:ms
    let myend = a:me
    let myword = a:mw
    let mycommand = "\/\\%>msl\\%<melmw"
    let mycommand = substitute(mycommand, "ms", mystart, "")
    let mycommand = substitute(mycommand, "me", myend, "")
    let mycommand = substitute(mycommand, "mw", myword, "")
    echo mycommand
    execute mycommand
endfunction

"""" Search and replace a word in choosen lines
function ReplaceIn(ms,me,mfw,mtw)
    let mystart = a:ms
    let myend = a:me
    let myfromword = a:mfw
    let mytoword = a:mtw
    let mycommand = ":ms,mes/mfw/mtw/g"
    let mycommand = substitute(mycommand, "ms", mystart, "")
    let mycommand = substitute(mycommand, "me", myend, "")
    let mycommand = substitute(mycommand, "mfw", myfromword, "")
    let mycommand = substitute(mycommand, "mtw", mytoword, "")
    echo mycommand
    execute mycommand
endfunction

"""" Search and replace a word in a file
function ReplaceAll(mfw,mtw)
    let myfromword = a:mfw
    let mytoword = a:mtw
    let mycommand = ":%s/mfw/mtw/gc"
    let mycommand = substitute(mycommand, "mfw", myfromword, "")
    let mycommand = substitute(mycommand, "mtw", mytoword, "")
    echo mycommand
    execute mycommand
endfunction

"""" Swap between tabs and spaces
function TabSwap()
    if &expandtab
        set shiftwidth=8
        set softtabstop=0
        set noexpandtab
    else
        set shiftwidth=4
        set softtabstop=4
        set expandtab
    endif
endfunction

" Rename tabs to show tab number.
" (Based on http://stackoverflow.com/questions/5927952/whats-implementation-of-vims-default-tabline-function)
if exists("+showtabline")
    function! MyTabLine()
        let s = ''
        let wn = ''
        let t = tabpagenr()
        let i = 1
        while i <= tabpagenr('$')
            let buflist = tabpagebuflist(i)
            let winnr = tabpagewinnr(i)
            let s .= '%' . i . 'T'
            let s .= (i == t ? '%1*' : '%2*')
            let s .= ' '
            let wn = tabpagewinnr(i,'$')

            let s .= '%#TabNum#'
            let s .= i
            " let s .= '%*'
            let s .= (i == t ? '%#TabLineSel#' : '%#TabLine#')
            let bufnr = buflist[winnr - 1]
            let file = bufname(bufnr)
            let buftype = getbufvar(bufnr, 'buftype')
            if buftype == 'nofile'
                if file =~ '\/.'
                    let file = substitute(file, '.*\/\ze.', '', '')
                endif
            else
                let file = fnamemodify(file, ':p:t')
            endif
            if file == ''
                let file = '[No Name]'
            endif
            let s .= ' ' . file . ' '
            let i = i + 1
        endwhile
        let s .= '%T%#TabLineFill#%='
        let s .= (tabpagenr('$') > 1 ? '%999XX' : 'X')
        return s
    endfunction
    set stal=2
    set tabline=%!MyTabLine()
    set showtabline=1
    highlight link TabNum Special
endif
