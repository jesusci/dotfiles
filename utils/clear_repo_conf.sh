#!/bin/bash

REPO_HOME="$HOME/dotfiles"
REPO_PWD=$(pwd)
PRECONF=$REPO_HOME/prev_conf

if [ $REPO_HOME != $REPO_PWD ]; then
    echo -e "${RED}To install dotfiles this repo must be in $REPO_HOME${NC}"
    exit 0
fi

##### Colours
RED='\033[0;31m'
GREEN='\033[0;32m'
NC='\033[0m'

ARCH=$(uname)

wvim=$(which vim)
wtmux=$(which tmux)
wzsh=$(which zsh)
wgit=$(which git)

if [ ! -d "$PRECONF" ]; then
    mkdir $PRECONF
fi

function save_prev_conf()
{
    if [ ! -d "$PRECONF/$1" ]; then
        mkdir $PRECONF/$1
    fi

    if [ $1 == "vim" ]; then
        cp $HOME/.vimrc $PRECONF/vim/.vimrc
        rm $HOME/.vimrc
        cp -r $HOME/.vim $PRECONF/vim/.vim
        rm -rf $HOME/.vim

    elif [ $1 == "tmux" ]; then
        cp $HOME/.tmux.conf $PRECONF/tmux/.tmux.conf
        rm $HOME/.tmux.conf

    elif [ $1 == "zsh" ]; then
        cp $HOME/.zshrc $PRECONF/zsh/.zshrc
        rm $HOME/.zshrc

    elif [ $1 == "git" ]; then
        cp $HOME/.gitconfig $PRECONF/.gitconfig
        rm $HOME/.gitconfig
    fi
}

function install_package()
{
    echo "Want to install $1, yes or no?"
    read user_ask

    if [ $user_ask == "yes" ]; then

        if [ $ARCH == "Linux" ]; then
            sudo apt-get install $1 -y

        elif [ $ARCH == "Darwin" ]; then
            brew install $1
        fi


        if [ $1 == "zsh" ]; then
            chsh -s /usr/bin/zsh
            wget https://github.com/robbyrussell/oh-my-zsh/raw/master/tools/install.sh -O - | zsh
        fi

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
        #TODO loop until user_ask was "yes" or "no"
        if [ $user_ask == "yes" ]; then
            return 2
        elif [ $user_ask == "no" ]; then
            return 3
        fi
    fi
}

function install_vim()
{

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
                save_prev_conf vim
                ln -s $REPO_HOME/vim/.vimrc    $HOME/.vimrc
                echo "---- vim configuration installed ----"
            elif [ $? -eq "3" ]; then
                echo "---- vim configuration not installed ----"
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
}

function install_tmux()
{
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
                save_prev_conf tmux
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
}

function install_zsh()
{
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
                save_prev_conf zsh
                ln -s $REPO_HOME/zsh/.zshrc    $HOME/.zshrc
                source $HOME/.zshrc
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
        ###### install if installation success also install oh-my-zsh
        rm $HOME/.zshrc
        ln -s $REPO_HOME/zsh/.zshrc     $HOME/.zshrc
        source $HOME/.zshrc
        echo "---- ZSH configuration installed ----"
    fi
}

function install_git()
{
    # ====================================================
    #               GIT configuration
    # ====================================================
    if [ ! -z $wgit ]; then
        echo ""
        echo "Checking GIT configuration..."
        if [ -e $HOME/.gitconfig ]; then
            echo -n "  There is a current GIT configuration: "
            check_diff $HOME/.gitconfig $REPO_HOME/.gitconfig
            if [ $? -eq "2" ]; then
                save_prev_conf git
                ln -s $REPO_HOME/.gitconfig    $HOME/.gitconfig
                echo "---- GIT configuration installed ----"
            elif [ $? -eq "3" ]; then
                echo "---- GIT configuration not installed ----"
            fi

        else
            ln -s $REPO_HOME/.gitconfig    $HOME/.gitconfig
            echo "---- GIT configuration installed ----"
        fi
    else
        install_package git
        rm $HOME/.gitconfig
        ln -s $REPO_HOME/.gitconfig     $HOME/.gitconfig
        echo "---- GIT configuration installed ----"
    fi
}

GLOBALMODE=$1

if [ "$GLOBALMODE" == "standard" ];then
    install_vim
    install_tmux
    install_zsh
    install_git
elif [ "$GLOBALMODE" == "vim" ];then
    install_vim
fi

echo ""
