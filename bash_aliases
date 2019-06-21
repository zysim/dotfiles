#!/usr/bin/bash
# Script colours
NC="\033[0m"
R="\033[0;31m"
G="\033[0;32m"
Y="\033[0;33m"
B="\033[0;34m"
M="\033[0;35m"
C="\033[0;36m"
LG="\033[0;37m"
LR="\033[0;91m"
LG="\033[0;92m"
LY="\033[0;93m"
LB="\033[0;94m"
LM="\033[0;95m"
LC="\033[0;96m"
W="\033[0;97m"
BR="\033[1;31m"
BG="\033[1;32m"
BY="\033[1;33m"
BB="\033[1;34m"
BM="\033[1;35m"
BC="\033[1;36m"
BLG="\033[1;37m"
BLR="\033[1;91m"
BLG="\033[1;92m"
BLY="\033[1;93m"
BLB="\033[1;94m"
BLM="\033[1;95m"
BLC="\033[1;96m"
BW="\033[1;97m"

# IB aliases
alias ib='cd ~/Documents/Work/InventoryBase'
alias ibr='cd ~/Documents/Work/InventoryBase-Go-RN'

# Git aliases
alias acip='add && cip'
alias add='git add .'
alias br="git branch"
alias brv="git branch -vv"
alias ci="git commit"
alias git_current_branch='git rev-parse --abbrev-ref HEAD'
alias lg="git log --graph --pretty=format:'%C(red)%h%Cgreen%d%Creset %s %C(blue) %an, %ar%Creset'"
alias mg="git merge"
alias mgd="mg develop"
if [[ $OSTYPE == linux* ]]; then
    alias prune='git remote prune origin && dg'
elif [[ $OSTYPE == darwin* ]]; then
    alias pr='git remote prune origin && dg'
fi
alias ss='git status -sb'

# Git functions
function acidevp() {
    if [ -n "$1" ]; then
        add && ci -m "$1" && dev -p
    else
        add && ci && dev -p
    fi
}

function bdm() {
    read -p "Deletes all branches that have been merged with master & develop. Proceed? [Y/n]" ans
    if [[ $ans =~ "[yY]" ]] || [[ -z $ans ]]; then
        git branch --merged | egrep -v "(^\*|master|dev)" | xargs git branch -d
        echo "Complete!"
    else
        echo "Aborting..."
    fi
}

# Commits and pushes at once
function cip() {
    if [[ -z "$1" ]]; then
        ci && push
    else
        ci -m "$1" && push
    fi
}

function co() {
    if [ $# -eq 0 ]; then
        git checkout $(git branch | pick)
    else
        git checkout "$@"
    fi
}

# Shorthand to checkout to a new branch from another
function cob() {
    if [[ -z "$1" ]]; then
        echo "Please specify a new branch name."
    else
        if [[ -z "$2" ]]; then
            co develop && co -b $1
        else
            co $2 && co -b $1
        fi
    fi
}

function del() {
    local current_branch=$(git_current_branch)
    if ! [[ $current_branch =~ (master|develop) ]]; then
        br -D $current_branch
    else
        echo -e "${LR}Currently on $current_branch. Not deleting this.${NC}"
    fi
}

function dev() {
    local current_branch
    local create_new_branch
    if ! [[ "$1" =~ ^- ]]; then
        if [[ -z "$1" ]]; then
            # Use the current branch to co to
            current_branch=$(git_current_branch)
        else
            # Check if it's a new branch
            git rev-parse --verify $1 &>/dev/null
            if [[ $? == 0 ]]; then
                # Create a new branch
                create_new_branch=0
            else
                # Use the user-supplied branch to co to
                create_new_branch=1
            fi
            current_branch=$1
        fi
        co develop && pull
        if [[ $create_new_branch == 1 ]]; then
            echo -e "${BY}New branch $1 specified. Creating new branch...${NC}"
            co -b $1 && mgd
        elif [[ $current_branch != "develop" ]]; then
            co $current_branch && mgd
        fi
        if [[ "$2" == "-p" ]]; then
            push
        fi
    elif [[ "$1" == -p ]]; then
        current_branch=$(git_current_branch)
        co develop && pull && co $current_branch && mgd && push
    fi
}

# Delete local branches which remotes have been deleted
function dg() {
    git branch -v \
    | grep -E '\[gone\]' \
    | cut -c 3- \
    | perl -lane 'print m/^\w+?\b/g' \
    | xargs git branch -D
}

function nuke_node() {
    echo "You're here:"
    pwd
    if ! [[ -d node_modules ]]; then
        echo 'node_modules not found in this directory. Aborting.'
        exit 1
    fi
    read -p "You sure you want to nuke node_modules? [y/N]" ans
    if [[ $ans =~ [yY] ]]; then
        rm -rf node_modules
        if [[ $(pwd) =~ InventoryBase-Go-RN$ ]]; then
            yarn
        else
            npm i
        fi
    elif [[ -z $ans ]]; then
        echo 'N received. Not nuking.'
    else
        echo "$ans received. Not nuking."
    fi
}

function pull() {
    git fetch origin && git rebase -p origin/$(git_current_branch)
}

function push() {
    git push origin HEAD:$(git_current_branch)
}

# rm aliases cuz goddamn
alias rm="rm -i"
alias srm="srm -i"

# ls aliases
alias ll="ls -ahl"
alias l="ls -AF"

# Tablet aliases
function fuckin_pen() {
    id=$(xsetwacom --list devices | perl -nle 'print $1 if /id: (\d{2})\s+type: STYLUS/')
    xsetwacom set $id MapToOutput 'HDMI-2'
}

# This is for work at Radweb. Once I'm outta this place then just delete this
# Opens the debugging menu on the test Android phone
alias debug_android_menu="adb shell input keyevent 82 && clear"
alias debug_android_start="react-native run-android --deviceId D1AGAS3780905879"
alias debug_android_reverse="adb -s D1AGAS3780905879 reverse tcp:8081 tcp:8081"
