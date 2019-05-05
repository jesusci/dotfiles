" Maintainer:   Jesus

hi clear
if exists("syntax_on")
  syntax reset
endif
let g:colors_name = "custom_1"

"""""""" Comment Colour
highlight Comment       ctermfg=56                                      guifg=#5f00d7

highlight Constant      ctermfg=14          cterm=none      guifg=#00ffff                   gui=none
highlight Identifier    ctermfg=6           guifg=#00c0c0
highlight Statement     ctermfg=3           cterm=bold      guifg=#c0c000                   gui=bold
highlight PreProc       ctermfg=10          guifg=#00ff00
highlight Type          ctermfg=2           guifg=#00c000
highlight Special       ctermfg=12                          guifg=#0000ff
highlight Error         ctermbg=9                           guibg=#ff0000
highlight Todo          ctermfg=4           ctermbg=3       guifg=#000080       guibg=#c0c000
highlight Directory     ctermfg=2                                       guifg=#00c000
highlight StatusLine    ctermfg=11      ctermbg=12      cterm=none      guifg=#ffff00       guibg=#0000ff   gui=none



highlight Search        ctermbg=3                                                           guibg=#c0c000

"""""""" Selected text in visual mode
highlight Visual  guifg=White guibg=LightBlue gui=none

highlight LineNr ctermfg=186   guifg=#d7d787

highlight Normal ctermfg=grey ctermbg=darkblue

highlight NonText ctermfg=grey ctermbg=darkblue
