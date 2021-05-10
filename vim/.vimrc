" =============================
"       Vim Configuration
" =============================

" Show line numbers
set rnu
set number

" Set into visual mode whenever select something with the mouse
set mouse=v
" Always shot the statusline
set laststatus=2

" Searching configure
set hlsearch
set showmatch
set ignorecase

" Enable vim syntax colors option
syntax on
colorscheme torte
"colorscheme custom_1

set guifont=Monospace:h30

set encoding=utf-8
set fileencoding=utf-8

" Vsplit to right, split to down
set splitright
set splitbelow

" Use vim clipboard as host clipboard
set clipboard=unnamed
set showcmd
set wildmenu

" See the tabs in your code
set list listchars=tab:>-,trail:·
set autoindent

" My indentation
:set tabstop=4
:set shiftwidth=4
:set softtabstop=4
:set expandtab


" ==============================
"       Key-mapping
" =============================

""" Move between tabs
"" Move to right tab
map <A-Right> gt
"" Move to left tab
map <A-Left> gT

map <Space> <Leader>
nnoremap <Leader>j <C-w><left>
nnoremap <Leader>ñ <C-w><right>
nnoremap <Leader>k <C-w><down>
nnoremap <Leader>l <C-w><up>

"" Direction keys adapted to spanish keyboard
nnoremap j h
nnoremap k j
nnoremap l k
nnoremap ñ l

nnoremap <C-w>j <C-w>h
nnoremap <C-w>k <C-w>j
nnoremap <C-w>l <C-w>k
nnoremap <C-w>ñ <C-w>l

vnoremap j h
vnoremap k j
vnoremap l k
vnoremap ñ l

" Using Leader to save, quit and save and quit
map <Leader>q <Esc>:q<CR>
map <Leader>w <Esc>:w<CR>
map <Leader>wq <Esc>:wq<CR>
map <Leader>wqa <Esc>:wqa<CR>

" NERDTree
map <C-n> :NERDTreeToggle<CR>

set pastetoggle=<f5>

" Autoindent entire document
map <F7> mzgg=G`z

" Change between tabs and spaces
nmap <F9> mz:execute TabSwap()<CR>'z

" =============================
"     Usefull key-mapping
" =============================


" ========= General ===========
imap ;{  {}<left><CR><CR><up><TAB>
imap ;(  ()<left>

"========== Java =============
imap ;so System.out.println();<left><left>


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
