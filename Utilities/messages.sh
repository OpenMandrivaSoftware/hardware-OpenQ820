#!/bin/bash

########################################################################
#
#   Colors
#
########################################################################
UNDER='\033[4m'
RED='\033[1;31m'
GREEN='\033[1;32m'
YELLOW='\033[1;33m'
BLUE='\033[1;34m'
MAGENTA='\033[1;35m'
CYAN='\033[1;36m'
WHITE='\033[1;37m'
ENDCOLOR='\033[0m'

########################################################################
#
#   Helper functions
#
########################################################################
function echo_color()
{
    echo -e "$1 $2 ${ENDCOLOR}"
}

function echo_error()
{
    echo -e "${RED}[Error]:${ENDCOLOR} $1"
}

function echo_warning()
{
    echo -e "${YELLOW}[Warn]:${ENDCOLOR} $1"
}

function echo_info()
{
    echo -e "${GREEN}[Info]:${ENDCOLOR} $1"
}

function echo_red()
{
    echo -e "${RED}$1${ENDCOLOR}"
}

function echo_grn()
{
    echo -e "${GREEN}$1${ENDCOLOR}"
}

function echo_yel()
{
    echo -e "${YELLOW}$1${ENDCOLOR}"
}

function echo_blu()
{
    echo -e "${BLUE}$1${ENDCOLOR}"
}

function echo_mag()
{
    echo -e "${MAGENTA}$1${ENDCOLOR}"
}

function echo_cyn()
{
    echo -e "${CYAN}$1${ENDCOLOR}"
}

function echo_wht()
{
    echo -e "${WHITE}$1${ENDCOLOR}"
}

function echo_review()
{
    echo -e "${MAGENTA} $1" "${CYAN}$2${ENDCOLOR}"
}


# ================================================================
#     Preformated messages
# ================================================================ 
function success(){
    echo -e "${GREEN}****************************************************${ENDCOLOR}"
    echo -e "${GREEN}[SUC] - ${WHITE}$1"
    echo -e "${GREEN}****************************************************${ENDCOLOR}"
}

function fail(){
    echo -e "${RED}****************************************************${ENDCOLOR}"
    echo -e "${RED}[FAL] - $1"
    echo -e "${RED}****************************************************${ENDCOLOR}"
}
function error(){
    echo -e "${RED}****************************************************${ENDCOLOR}"
    echo -e "${RED}[ERR] - ${WHITE}$1"
    echo -e "${RED}****************************************************${ENDCOLOR}"
}
function warning(){
    echo -e "${YELLOW}****************************************************${ENDCOLOR}"
    echo -e "${YELLOW}[WRN] - ${WHITE}$1"
    echo -e "${YELLOW}****************************************************${ENDCOLOR}"
}
function warning2(){
    echo -e "${YELLOW}****************************************************${ENDCOLOR}"
    echo -e "${YELLOW}[WRN] - ${WHITE}$1"
    echo -e "${YELLOW}[WRN] - ${WHITE}$2"
    echo -e "${YELLOW}****************************************************${ENDCOLOR}"
}

function message(){
    echo -e "${CYAN}$1${WHITE}"
}

