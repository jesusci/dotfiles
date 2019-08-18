#!/bin/bash

NARGS=$#

if [ "$NARGS" -eq 0 ]; then
    echo "Usage 1: \"$0 install standard\" to install repo configuration standard"
    echo "Usage 1: \"$0 install vim\" to install only vim configuration"
    echo "Usage 2: \"$0 recover\" to recover previous configuration"
    echo "Usage 3: \"$0 save\" to save actual configuration"
    exit 1
else
    if [ "$1" != "install" ] && [ "$1" != "recover" ] && [ "$1" != "save" ]; then
        echo "Invalid argument $1"
        exit 1
    fi
fi

REPO_HOME="$HOME/dotfiles"
REPO_PWD=$(pwd)
PRECONF=$REPO_HOME/prev_conf

##### Colours
RED='\033[0;31m'
GREEN='\033[0;32m'
NC='\033[0m'

if [ $REPO_HOME != $REPO_PWD ]; then
    echo -e "${RED}To install dotfiles this repo must be in $REPO_HOME${NC}"
    exit 0
fi

GLOBALMODE=$1

if [ $GLOBALMODE == "install" ]; then
    INSTALLMODE=$2
    if [ "$INSTALLMODE" != "" ]; then
        if [ "$INSTALLMODE" == "standard" ]; then
            $REPO_HOME/install_repo_conf.sh standard
        elif [ "$INSTALLMODE" == "vim" ];then
            $REPO_HOME/install_repo_conf.sh vim
        fi
    else
        $REPO_HOME/install_repo_conf.sh
    fi
elif [ $GLOBALMODE == "save" ]; then
    echo "logic to save"
elif [ $GLOBALMODE == "recover" ]; then
    echo "logic to recover"
fi

exit 1
