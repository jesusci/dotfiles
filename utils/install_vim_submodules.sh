#!/bin/bash

REPO_PWD=$(pwd)

function install_youcomplete_me()
{
    $REPO_PWD/vim/pack/test/start/YouCompleteMe/install.sh
}

git submodule update --init --recursive
install_youcomplete_me

echo ""
