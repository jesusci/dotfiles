" =================================
"           Vim Configuration
" =================================
set number  "show line number 
set title
set cursorline
set ruler

set spelllang=en,es

set termguicolors
set background=dark
colorscheme torte

"Enable vim syntax colors option
syntax on
set guifont=Monospace:h30

" See the tabs in your code
set list listchars=tab:>-,trail:·
set autoindent

" My indentation
:set tabstop=4
:set shiftwidth=4
:set softtabstop=4
:set expandtab

" ===========================
"
" ===========================
imap ;{  {}<left><CR><CR><up><TAB>
imap ;(  ()<left>

" =============================
"       My functions
" =============================

" Swap between tabs and spaces
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

nmap <F9> mz:execute TabSwap()<CR>'z
