#!/bin/bash

##### Colours
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[0;33m'
BLUE='\033[0;34m'
NC='\033[0m'

function print_with_color()
{
    COLOUR=$1
    MSG=$2
    echo -e "${COLOUR} $MSG ${NC}"
}

function print_green()
{
    MSG=$1
    echo -e "${GREEN} $MSG ${NC}"
}

function print_red()
{
    MSG=$1
    echo -e "${RED} $MSG ${NC}"
}

function print_yellow(){
    MSG=$1
    echo -e "${YELLOW} $MSG ${NC}"
}
