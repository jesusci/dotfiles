#!/bin/bash

REPO_PWD=$(pwd)
PRECONF=$REPO_PWD/prev_conf

source $REPO_PWD/utils/print_options.sh
source $REPO_PWD/vim/setup

ARCH=$(uname)

wnvim=$(which nvim)
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

    elif [ $1 == "nvim" ]; then
        cp $HOME/.config/nvim/init.vim $PRECONF/.config/nvim/init.vim
        rm $HOME/.config/nvim/init.vim

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
    clear
    print_warning "Want to install $1, yes or no?"
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
            print_error "TODO: logic to install all the packages"
        fi

    elif [ $user_ask == "no" ]; then
        print_error "$1 not installed"
    fi
}

function check_diff()
{
    result=$(diff $1 $2)

    if [ $? -eq 0 ];then
        print_info "Current local configuration and repo configuration are the same"
    else
        print_error "Current local configuration and repo configuration are different"
        print_warning "Want to overwrite with repo configuration, yes or no?"
        read user_ask
        if [ $user_ask == "yes" ]; then
            return 2
        elif [ $user_ask == "no" ]; then
            return 3
        fi
    fi
}

function install_nvim()
{
    # ====================================================
    #               NeoVim configuration
    # ====================================================
    if [ ! -z $wnvim ]; then
        echo ""
        print_warning "Checking NeoVim configuration..."
        if [ -e $HOME/.config/nvim/init.vim ]; then
            print_warning "  There is a current NeoVim configuration: "
            check_diff $HOME/.config/nvim/init.vim $REPO_PWD/neovim/init.vim
            if [ $? -eq "2" ]; then
                save_prev_conf neovim
                ln -s $REPO_PWD/neovim/init.vim   $HOME/.config/nvim/init.vim
                print_info "---- NeoVim configuration installed ----"
            elif [ $? -eq "3" ]; then
                print_error "---- NeoVim configuration not installed ----"
            fi
        else
            ln -s $REPO_PWD/neovim/init.vim   $HOME/.config/nvim/init.vim
            print_info "---- NeoVim configuration installed ----"
        fi

    else
        print_warning "NeoVim not installed"
        install_package neovim
        ln -s $REPO_PWD/neovim/init.vim   $HOME/.config/nvim/init.vim
        print_info "---- NeoVim configuration installed ----"
    fi
}

function install_vim()
{
    # ====================================================
    #               Vim configuration
    # ====================================================

    REPO_PATH=$REPO_PWD/vim
    HOME_PATH=$HOME/.vim

    if [ ! -z $wvim ]; then
        echo ""
        print_warning "Checking vim configuration..."
        if [ -e $HOME_PATH/vimrc ]; then
            print_warning "\tThere is a current vim configuration:"
            check_diff $HOME_PATH/vimrc $REPO_PATH/vimrc
            if [ $? -eq "2" ]; then
                save_prev_conf vim
                copy_vim_files
                print_info "---- Vim configuration installed ----"
            elif [ $? -eq "3" ]; then
                print_error "---- Vim configuration not installed ----"
            fi
        else
            ln -s $REPO_PATH $HOME_PATH
            print_info "---- Vim configuration installed ----"
        fi

    else
        print_warning "Vim not installed"
        install_package vim
        copy_vim_files
        print_info "---- Vim configuration installed ----"
    fi
}

function install_tmux()
{
    # ====================================================
    #               TMUX configuration
    # ====================================================
    if [ ! -z $wtmux ]; then
        echo ""
        print_warning "Checking tmux configuration..."
        if [ -e $HOME/.tmux.conf ]; then
            print_warning "  There is a current tmux configuration: "
            check_diff $HOME/.tmux.conf $REPO_PWD/tmux/.tmux.conf
            if [ $? -eq "2" ]; then
                save_prev_conf tmux
                ln -s $REPO_PWD/tmux/.tmux.conf    $HOME/.tmux.conf
                print_info "---- tmux configuration installed ----"
            elif [ $? -eq "3" ]; then
                print_error "---- tmux configuration not installed ----"
            fi
        else
            ln -s $REPO_PWD/tmux/.tmux.conf     $HOME/.tmux.conf
            print_info "---- tmux configuration installed ----"
        fi
    else
        install_package tmux
        ln -s $REPO_PWD/tmux/.tmux.conf   $HOME/.tmux.conf
        print_info "---- tmux configuration installed ----"
    fi
}

function install_zsh()
{
    # ====================================================
    #               ZSH configuration
    # ====================================================
    if [ ! -z $wzsh ]; then
        echo ""
        print_warning "Checking ZSH configuration..."
        if [ -e $HOME/.zshrc ]; then
            print_warning "  There is a current ZSH configuration: "
            check_diff $HOME/.zshrc $REPO_PWD/zsh/.zshrc
            if [ $? -eq "2" ]; then
                save_prev_conf zsh
                ln -s $REPO_PWD/zsh/.zshrc    $HOME/.zshrc
                source $HOME/.zshrc
                print_info "---- ZSH configuration installed ----"
            elif [ $? -eq "3" ]; then
                print_error "---- ZSH configuration not installed ----"
            fi

        else
            ln -s $REPO_PWD/zsh/.zshrc    $HOME/.zshrc
            print_info "---- ZSH configuration installed ----"
        fi
    else
        install_package zsh
        ###### install if installation success also install oh-my-zsh
        rm $HOME/.zshrc
        ln -s $REPO_PWD/zsh/.zshrc     $HOME/.zshrc
        source $HOME/.zshrc
        print_info "---- ZSH configuration installed ----"
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
                print_info "---- GIT configuration installed ----"
            elif [ $? -eq "3" ]; then
                print_error "---- GIT configuration not installed ----"
            fi

        else
            ln -s $REPO_PWD/.gitconfig    $HOME/.gitconfig
            print_info "---- GIT configuration installed ---"
        fi
    else
        install_package git
        rm $HOME/.gitconfig
        ln -s $REPO_PWD/.gitconfig     $HOME/.gitconfig
        print_info "---- GIT configuration installed ----"
    fi
}

GLOBALMODE=$1

if [ "$GLOBALMODE" == "" ] || [ "$GLOBALMODE" == "standard" ];then

    clear
    print_warning "Want to install vim or neovim, vim|neovim?"
    read user_ask

    if [ "$user_ask" == "" ] || [ "$user_ask" == "vim" ] ; then
        install_vim
    elif [ "$user_ask" == "neovim" ] ; then
        install_nvim
    else
        print_error "Option: $user_ask not recognized"
        exit 1
    fi
    install_tmux
    install_zsh
    install_git
elif [ "$GLOBALMODE" == "vim" ] || [ "$GLOBALMODE" == "tmux" ] || [ "$GLOBALMODE" == "nvim" ];then
    install_$GLOBALMODE
fi

echo ""
