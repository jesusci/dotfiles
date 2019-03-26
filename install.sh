#!/bin/bash
REPO_HOME="$HOME/dotfiles"
REPO_PWD=$(pwd)

wvim=$(which vim)
wtmux=$(which tmux)
wnvim=$(which nvim)

if [ $REPO_HOME != $REPO_PWD ]; then
    echo "To install dotfiles this repo must be in $REPO_HOME"
    exit 0
fi

# ====================================================
#               Vim configuration
# ====================================================

#### Check if vim is installed
if [ -n $wvim ]; then
    echo "Checking vim configuration..."
    if [ -e $HOME/.vimrc ]; then
        echo -n "  There is a current vim configuration: "
        result=$(diff $HOME/.vimrc $REPO_HOME/vim/.vimrc)

        if [ $? -eq 0 ];then
            echo "Current local configuration and repo configuration are the same"
        else
            echo "Current local configuration and repo configuration are different"
        fi

    else
        ln -s $REPO_HOME/vim/.vimrc     $HOME/.vimrc
        echo "---- Vim configuration installed ----"
    fi
fi

# ====================================================
#               TMUX configuration
# ====================================================
#### Check if tmux is installed
if [ -n $wtmux ]; then
    echo "Checking tmux configuration..."
    if [ -e $HOME/.tmux.conf ]; then
        echo -n "  There is a current tmux configuration: "
        result=$(diff $HOME/.tmux.conf $REPO_HOME/tmux/.tmux.conf)

        if [ $? -eq 0 ];then
            echo "Current local configuration and repo configuration are the same"
        else
            echo "Current local configuration and repo configuration are different"
        fi

    else
        ln -s $REPO_HOME/tmux/.tmux.conf     $HOME/.tmux.conf
        echo "---- TMUX configuration installed ----"
    fi
fi

# ====================================================
#               NeoVim configuration
# ====================================================
#### Check if tmux is installed
if [ -n $wnvim ]; then
    echo "Checking NeoVim configuration..."
    if [ -e $HOME/.config/nvim/init.vim ]; then
        echo -n "  There is a current Neovim configuration: "
        result=$(diff $HOME/.config/nvim/init.vim $REPO_HOME/neovim/init.vim)

        if [ $? -eq 0 ];then
            echo "Current local configuration and repo configuration are the same"
        else
            echo "Current local configuration and repo configuration are different"
        fi

    else
        ln -s $REPO_HOME/neovim/init.vim     $HOME/.config/nvim/init.vim
        echo "---- NEOVIM configuration installed ----"
    fi
fi
