" =============================
"       Vim Configuration
" =============================

"Show line numbers
set number

"Set into visual mode whenever select something with the mouse
set mouse=v

"Enable vim syntax colors option
syntax on
colorscheme torte
set guifont=Monospace:h30

" See the tabs in your code
set list listchars=tab:>-,trail:·
set autoindent

" My indentation
:set tabstop=4
:set shiftwidth=4
:set softtabstop=4
:set expandtab


" ==========================
"       Key-mapping
" ==========================

""" Move between tabs
"" Move to right tab
map <A-Right> gt
"" Move to left tab
map <A-Left> gT

"Autoindent entire document
map <F7> mzgg=G`z

set pastetoggle=<f5>

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
    execute mycommand
endfunction
