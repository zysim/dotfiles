#!/usr/bin/bash
Y='\033[1;33m'
NC='\033[0m'

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
    alias prune='git remote prune origin'
elif [[ $OSTYPE == darwin* ]]; then
    alias pr="git remote prune origin"
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

# Shorthand to checkout to a new branch from another
function cob() {
    if [[ -z "$1" ]]; then
        echo "Please specify a new branch name."
    else
        if [[ -z "$2" ]]; then
            co develop && pull && co -b $1
        else
            co $2 && co -b $1
        fi
    fi
}

# Commits and pushes at once
function cip() {
    if [[ -z "$1" ]]; then
        ci -a && push
    else
        ci -a -m "$1" && push
    fi
}

function co() {
    if [ $# -eq 0 ]; then
        git checkout $(git branch | pick)
    else
        git checkout "$@"
    fi
}

function dev() {
    local current_branch
    if ! [[ "$1" =~ ^- ]]; then
        if [[ -z "$1" ]]; then
            # Use the current branch to co to
            current_branch=$(git_current_branch)
        else
            # Use the user-supplied branch to co to
            current_branch=$1
        fi
        if [[ $(git_current_branch) == "develop" ]]; then
            echo -e "${Y}Already on develop. Pulling...${NC}"
            pull
        else
            co develop && pull && co $current_branch && mgd
        fi
        if [[ "$2" == "-p" ]]; then
            push
        fi
    elif [[ "$1" == -p ]]; then
        current_branch=$(git_current_branch)
        co develop && pull && co $current_branch && mgd && push
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
    if [[ $ans =~ "[yY]" ]]; then
        rm -rf node_modules && npm i
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
