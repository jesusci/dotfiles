#!/bin/bash

REPO_PWD=$(pwd)
PRECONF=$REPO_PWD/prev_conf

source $REPO_PWD/utils/print_options.sh

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
    print_yellow "Want to install $1, yes or no?"
    read user_ask

    if [ $user_ask == "yes" ]; then

        if [ $ARCH == "Linux" ]; then
            if [ $1 == "vim" ]; then
                sudo apt-get install vim-gtk -y
            else
                sudo apt-get install $1 -y
            fi

        elif [ $ARCH == "Darwin" ]; then
            brew install $1
        fi


        if [ $1 == "zsh" ]; then
            chsh -s /usr/bin/zsh
            wget https://github.com/robbyrussell/oh-my-zsh/raw/master/tools/install.sh -O - | zsh
        elif [ $1 == "vim" ]; then
            ##TODO
            print_red "TODO: logic to install all the packages"
        fi

    elif [ $user_ask == "no" ]; then
        print_red "$1 not installed"
    fi
}

function check_diff()
{
    result=$(diff $1 $2)

    if [ $? -eq 0 ];then
        print_green "Current local configuration and repo configuration are the same"
    else
        print_red "Current local configuration and repo configuration are different"
        print_yellow "Want to overwrite with repo configuration, yes or no?"
        read user_ask
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
        print_yellow "Checking vim configuration..."
        if [ -e $HOME/.vimrc ]; then
            print_yellow "  There is a current vim configuration: "
            check_diff $HOME/.vimrc $REPO_PWD/vim/.vimrc
            if [ $? -eq "2" ]; then
                save_prev_conf vim
                ln -s $REPO_PWD/vim/.vimrc    $HOME/.vimrc
                ln -s $REPO_PWD/vim/   $HOME/.vim
                print_green "---- Vim configuration installed ----"
            elif [ $? -eq "3" ]; then
                print_red "---- Vim configuration not installed ----"
            fi
        else
            ln -s $REPO_PWD/vim/.vimrc     $HOME/.vimrc
            ln -s $REPO_PWD/vim/ $HOME/.vim
            print_green "---- Vim configuration installed ----"
        fi

    else
        print_yellow "Vim not installed"
        install_package vim
        ln -s $REPO_PWD/vim/.vimrc   $HOME/.vimrc
        ln -s $REPO_PWD/vim/   $HOME/.vim
        print_green "---- Vim configuration installed ----"
    fi
}

function install_tmux()
{
    # ====================================================
    #               TMUX configuration
    # ====================================================
    if [ ! -z $wtmux ]; then
        echo ""
        print_yellow "Checking tmux configuration..."
        if [ -e $HOME/.tmux.conf ]; then
            print_yellow "  There is a current tmux configuration: "
            check_diff $HOME/.tmux.conf $REPO_PWD/tmux/.tmux.conf
            if [ $? -eq "2" ]; then
                save_prev_conf tmux
                ln -s $REPO_PWD/tmux/.tmux.conf    $HOME/.tmux.conf
                print_green "---- tmux configuration installed ----"
            elif [ $? -eq "3" ]; then
                print_red "---- tmux configuration not installed ----"
            fi
        else
            ln -s $REPO_PWD/tmux/.tmux.conf     $HOME/.tmux.conf
            print_green "---- tmux configuration installed ----"
        fi
    else
        install_package tmux
        ln -s $REPO_PWD/tmux/.tmux.conf   $HOME/.tmux.conf
        print_green "---- tmux configuration installed ----"
    fi
}

function install_zsh()
{
    # ====================================================
    #               ZSH configuration
    # ====================================================
    if [ ! -z $wzsh ]; then
        echo ""
        print_yellow "Checking ZSH configuration..."
        if [ -e $HOME/.zshrc ]; then
            print_yellow "  There is a current ZSH configuration: "
            check_diff $HOME/.zshrc $REPO_PWD/zsh/.zshrc
            if [ $? -eq "2" ]; then
                save_prev_conf zsh
                ln -s $REPO_PWD/zsh/.zshrc    $HOME/.zshrc
                source $HOME/.zshrc
                print_green "---- ZSH configuration installed ----"
            elif [ $? -eq "3" ]; then
                print_red "---- ZSH configuration not installed ----"
            fi

        else
            ln -s $REPO_PWD/zsh/.zshrc    $HOME/.zshrc
            print_green "---- ZSH configuration installed ----"
        fi
    else
        install_package zsh
        ###### install if installation success also install oh-my-zsh
        rm $HOME/.zshrc
        ln -s $REPO_PWD/zsh/.zshrc     $HOME/.zshrc
        source $HOME/.zshrc
        print_green "---- ZSH configuration installed ----"
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
            check_diff $HOME/.gitconfig $REPO_PWD/.gitconfig
            if [ $? -eq "2" ]; then
                save_prev_conf git
                ln -s $REPO_PWD/.gitconfig    $HOME/.gitconfig
                print_green "---- GIT configuration installed ----"
            elif [ $? -eq "3" ]; then
                print_red "---- GIT configuration not installed ----"
            fi

        else
            ln -s $REPO_PWD/.gitconfig    $HOME/.gitconfig
            print_green "---- GIT configuration installed ---"
        fi
    else
        install_package git
        rm $HOME/.gitconfig
        ln -s $REPO_PWD/.gitconfig     $HOME/.gitconfig
        print_green "---- GIT configuration installed ----"
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
