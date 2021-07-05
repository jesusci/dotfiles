#!/bin/bash

REPO_PWD=$(pwd)
source $REPO_PWD/utils/install_repo_conf.sh

function uninstall_package()
{
    print_warning "Uninstalling package $1"
    if [ $ARCH == "Linux" ]; then
        if [ $1 == "vim" ]; then
            rm $HOME/.vim* &>/dev/null
        elif [ $1 == "zsh" ]; then
            rm $HOME/.zsh* &>/dev/null
            rm -rf $HOME/.oh-my* &>/dev/null
        elif [ $1 == "tmux" ]; then
            rm $HOME/.tmux.conf* &>/dev/null
        elif [ $1 == "git" ]; then
            rm $HOME/.git* &>/dev/null
        fi
        sudo apt-get remove $1 -y &>/dev/null
        print_info "Package $1 uninstalled"
    elif [ $ARCH == "Darwin" ]; then
        brew uninstall $1 -f
    fi
}

function sanitice_conf()
{
    if [ ! -z $wvim ]; then
        print_warning "Saniticing vim"
        save_prev_conf vim
        uninstall_package vim
        wvim=""
        install_vim
    fi
    if [ ! -z $wtmux ]; then
        print_warning "Saniticing tmux"
        save_prev_conf tmux
        uninstall_package tmux
        wtmux=""
        install_tmux
    fi
    if [ ! -z $wzsh ]; then
        print_warning "Saniticing zsh"
        save_prev_conf zsh
        uninstall_package zsh
        wzsh=""
        install_zsh
    fi
    if [ ! -z $git ]; then
        print_warning "Saniticing git"
        save_prev_conf git
        uninstall_package git
        wgit=""
        install_git
    fi
}

GLOBALMODE=$1
print_info "Fixing configuration"
sanitice_conf

echo ""
