#!/bin/bash
REPO_HOME="$HOME/dotfiles"
REPO_PWD=$(pwd)

isvim=$(which vim)

if [ $REPO_HOME != $REPO_PWD ]; then
    echo "To install dotfiles this repo must be in $REPO_HOME"
    exit 0
fi

# ====================================================
#               Vim configuration
# ====================================================

#### Check if vim is installed
if [ -n $isvim ]; then
    echo "Checking vim configuration..."
    if [ -e $HOME/.vimrc ]; then
        echo -n "  There is a current vim configuration: "
        result=$(diff $HOME/.vimrc $REPO_HOME/vim/.vimrc)

        if [ $? -eq 0 ];then
            echo "Current local configuration and repo configuration are equals"
        else
            echo "Current local configuration and repo configuration are different"
        fi

    else
        ln -s $REPO_HOME/vim/.vimrc     $HOME/.vimrc
        echo "---- Vim configuration installed ----"
    fi
fi
