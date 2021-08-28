#!/bin/bash

REPO_PWD=$(pwd)

source $REPO_PWD/utils/print_options.sh
function install_youcomplete_me()
{
    clear
    print_warning "Want to install YouCompleteMe plugin? [y/N]"
    read user_ask

    if [ "$user_ask" == "yes" ] || [ "$user_ask" == "y" ] || [ "$user_ask" == "Y" ] ; then
        $REPO_PWD/vim/pack/youcompleteme/start/YouCompleteMe/install.sh
    else
        print_warning "YouCompleteMe plugin not installed"
    fi
}

git submodule update --init --recursive
install_youcomplete_me

echo ""
