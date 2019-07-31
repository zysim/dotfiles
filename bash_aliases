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
alias ib='cd ~/Documents/Work/InventoryBase && nvm use'
alias ibr='cd ~/Documents/Work/InventoryBase-Go-RN && nvm use'

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
    alias prune='git remote prune origin && begone_thots'
elif [[ $OSTYPE == darwin* ]]; then
    alias pr='git remote prune origin && begone_thots'
fi
alias ss='git status -sb'

# Git functions
function acidev() {
    if [ -n "$1" ]; then
        add && ci -m "$1" && dev
    else
        add && ci && dev
    fi
}

function acidevp() {
    if [ -n "$1" ]; then
        acidev $1 && push
    else
        acidev && push
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

# Delete local branches which remotes have been deleted
function begone_thots() {
    git branch -v \
    | grep -E '\[gone\]' \
    | cut -c 3- \
    | perl -lane 'print m/^\w+?\b/g' \
    | xargs git branch -D
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
        dev -s && br -D $current_branch
    else
        echo -e "${LR}Currently on $current_branch. Not deleting this.${NC}"
    fi
}

function dev() {
    if ! [[ "$1" =~ ^- ]]; then
        co develop && pull
        if [[ -z "$1" ]]; then
            co - && git merge develop
        else
            # Check if it's a remote branch
            git rev-parse --verify origin/$1 &>/dev/null
            if [[ $? != 0 ]]; then
                # Check if it's a new branch
                git rev-parse --verify $1 &>/dev/null
                if [[ $? != 0 ]]; then
                    echo -e "${BY}New branch $1 specified. Creating new branch...${NC}"
                    co -b $1
                fi
            else
              co $1 && git merge develop
            fi
        fi
    else
        case $1 in
            "-s")
                co develop && pull
                ;;
            "-h" | *)
                echo "$0 {-h|-s}"
                ;;
        esac
    fi
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
    local current_branch=$(git_current_branch)
    if [[ $current_branch == "develop" ]]; then
        echo -e "${BR}You're currently on develop. We ain't pushin'.${NC}"
    else
        # Check if there's a remote branch
            git rev-parse --verify origin/$current_branch &>/dev/null
            if [[ $? != 0 ]]; then
                git push -u origin $current_branch
            else
                git push
            fi
    fi
}

# Terminal aliases
alias cls='printf "\ec"'
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
alias debug_android_menu="adb shell input keyevent 82 && cls"
alias debug_android_start="react-native run-android --deviceId D1AGAS3780905879 && cls"
alias debug_android_reverse="adb -s D1AGAS3780905879 reverse tcp:8081 tcp:8081 && cls"

alias mkvirtualenv='mkvirtualenv --no-site-packages --distribute'
