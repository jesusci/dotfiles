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

function install_youcomplete_me()
{
    $REPO_HOME/vim/pack/test/start/YouCompleteMe/install.sh
}

GLOBALMODE=$1
install_youcomplete_me

echo ""