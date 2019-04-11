#!/bin/bash

##### Colours
RED='\033[0;31m'
GREEN='\033[0;32m'
NC='\033[0m'

REPO_HOME="$HOME/dotfiles"
REPO_PWD=$(pwd)

wvim=$(which vim)
wtmux=$(which tmux)
wnvim=$(which nvim)

function check_diff()
{
    result=$(diff $1 $2)

    if [ $? -eq 0 ];then
        echo -e "${GREEN}Current local configuration and repo configuration are the same${NC}"
    else
        echo -e "${RED}Current local configuration and repo configuration are different${NC}"
    fi
}


if [ $REPO_HOME != $REPO_PWD ]; then
    echo -e "${RED}To install dotfiles this repo must be in $REPO_HOME${NC}"
    exit 0
fi

# ====================================================
#               Vim configuration
# ====================================================

#### Check if vim is installed
if [ ! -z $wvim ]; then
    echo ""
    echo "Checking vim configuration..."
    if [ -e $HOME/.vimrc ]; then
        echo -n "  There is a current vim configuration: "
        check_diff $HOME/.vimrc $REPO_HOME/vim/.vimrc
    else
        ln -s $REPO_HOME/vim/.vimrc     $HOME/.vimrc
        echo "---- Vim configuration installed ----"
    fi
fi

# ====================================================
#               TMUX configuration
# ====================================================
#### Check if tmux is installed
if [ ! -z $wtmux ]; then
    echo ""
    echo "Checking tmux configuration..."
    if [ -e $HOME/.tmux.conf ]; then
        echo -n "  There is a current tmux configuration: "
        check_diff $HOME/.tmux.conf $REPO_HOME/tmux/.tmux.conf
    else
        ln -s $REPO_HOME/tmux/.tmux.conf     $HOME/.tmux.conf
        echo "---- TMUX configuration installed ----"
    fi
fi

# ====================================================
#               NeoVim configuration
# ====================================================
#### Check if tmux is installed
if [ ! -z $wnvim ]; then
    echo ""
    echo "Checking NeoVim configuration..."
    if [ -e $HOME/.config/nvim/init.vim ]; then
        echo -n "  There is a current Neovim configuration: "
        check_diff $HOME/.config/nvim/init.vim $REPO_HOME/neovim/init.vim
    else
        ln -s $REPO_HOME/neovim/init.vim     $HOME/.config/nvim/init.vim
        echo "---- NEOVIM configuration installed ----"
    fi
fi

echo ""
