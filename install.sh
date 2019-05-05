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
wzsh=$(which zsh)

function install_package()
{
    echo "Want to install $1, yes or no?"
    read user_ask
    if [ $user_ask == "yes" ]; then
        sudo apt-get install $1
    elif [ $user_ask == "no" ]; then
        echo "$1 not installed"
    fi
}

function check_diff()
{
    result=$(diff $1 $2)

    if [ $? -eq 0 ];then
        echo -e "${GREEN}Current local configuration and repo configuration are the same${NC}"
    else
        echo -e "${RED}Current local configuration and repo configuration are different${NC}"
        echo "Want to overwrite with repo configuration, yes or no?"
        read user_ask
        if [ $user_ask == "yes" ]; then
            return 2
        elif [ $user_ask == "no" ]; then
            return 3
        fi
    fi
}


if [ $REPO_HOME != $REPO_PWD ]; then
    echo -e "${RED}To install dotfiles this repo must be in $REPO_HOME${NC}"
    exit 0
fi

# ====================================================
#               Vim configuration
# ====================================================
if [ ! -z $wvim ]; then
    echo ""
    echo "Checking vim configuration..."
    if [ -e $HOME/.vimrc ]; then
        echo -n "  There is a current vim configuration: "
        check_diff $HOME/.vimrc $REPO_HOME/vim/.vimrc
        if [ $? -eq "2" ]; then
            rm $HOME/.vimrc
            ln -s $REPO_HOME/vim/.vimrc    $HOME/.vimrc
            echo "---- tmux configuration installed ----"
        elif [ $? -eq "3" ]; then
            echo "---- tmux configuration not installed ----"
        fi
    else
        ln -s $REPO_HOME/vim/.vimrc     $HOME/.vimrc
        mkdir $HOME/.vim/colors
        ln -s $REPO_HOME/colorschemes/custom_1.vim     $HOME/.vim/colors/custom_1.vim
        echo "---- Vim configuration installed ----"
    fi

else
    install_package vim
    ln -s $REPO_HOME/vim/.vimrc   $HOME/.vimrc
    echo "---- VIM configuration installed ----"
fi

# ====================================================
#               TMUX configuration
# ====================================================
if [ ! -z $wtmux ]; then
    echo ""
    echo "Checking tmux configuration..."
    if [ -e $HOME/.tmux.conf ]; then
        echo -n "  There is a current tmux configuration: "
        check_diff $HOME/.tmux.conf $REPO_HOME/tmux/.tmux.conf
        if [ $? -eq "2" ]; then
            rm $HOME/.tmux.conf
            ln -s $REPO_HOME/tmux/.tmux.conf    $HOME/.tmux.conf
            echo "---- tmux configuration installed ----"
        elif [ $? -eq "3" ]; then
            echo "---- tmux configuration not installed ----"
        fi
    else
        ln -s $REPO_HOME/tmux/.tmux.conf     $HOME/.tmux.conf
        echo "---- tmux configuration installed ----"
    fi
else
    install_package tmux
    ln -s $REPO_HOME/tmux/.tmux.conf   $HOME/.tmux.conf
    echo "---- tmux configuration installed ----"
fi

# ====================================================
#               NeoVim configuration
# ====================================================
if [ ! -z $wnvim ]; then
    echo ""
    echo "Checking NeoVim configuration..."
    if [ -e $HOME/.config/nvim/init.vim ]; then
        echo -n "  There is a current Neovim configuration: "
        check_diff $HOME/.config/nvim/init.vim  $REPO_HOME/neovim/init.vim
        if [ $? -eq "2" ]; then
            rm $HOME/.config/nvim/init.vim
            ln -s $REPO_HOME/neovim/init.vim    $HOME/.config/nvim/init.vim
            echo "---- NeoVim configuration installed ----"
        elif [ $? -eq "3" ]; then
            echo "---- NeoVim configuration not installed ----"
        fi
    else
        mkdir $HOME/.config/nvim
        ln -s $REPO_HOME/neovim/init.vim     $HOME/.config/nvim/init.vim
        echo "---- NeoVim configuration installed ----"
    fi
else
    install_package neovim
    ln -s $REPO_HOME/neovim/init.vim     $HOME/.config/nvim/init.vim
    echo "---- NeoVim configuration installed ----"
fi

# ====================================================
#               ZSH configuration
# ====================================================
if [ ! -z $wzsh ]; then
    echo ""
    echo "Checking ZSH configuration..."
    if [ -e $HOME/.zshrc ]; then
        echo -n "  There is a current ZSH configuration: "
        check_diff $HOME/.zshrc $REPO_HOME/zsh/.zshrc
        if [ $? -eq "2" ]; then
            rm $HOME/.zshrc
            ln -s $REPO_HOME/zsh/.zshrc    $HOME/.zshrc
            echo "---- ZSH configuration installed ----"
        elif [ $? -eq "3" ]; then
            echo "---- ZSH configuration not installed ----"
        fi

    else
        ln -s $REPO_HOME/zsh/.zshrc    $HOME/.zshrc
        echo "---- ZSH configuration installed ----"
    fi
else
    install_package zsh
    ###### instal if installation success also install oh-my-zsh
    ln -s $REPO_HOME/zsh/.zshrc     $HOME/.zshrc
    echo "---- ZSH configuration installed ----"
fi

echo ""
