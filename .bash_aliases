# Git aliases
alias add='git add .'
alias br="git branch"
alias brv="git branch -vv"
alias ci="git commit"
alias co="git checkout"
if [[ $OSTYPE == linux* ]]; then
    alias prune='git remote prune origin'
elif [[ $OSTYPE == darwin* ]]; then
    alias pr="git remote prune origin"
fi
alias mg="git merge"
alias mgd='git merge develop'
function cip() {
    if [[ -z "$1" ]]; then
        ci -a && git push
    else
        git add . && ci -m "$1" && git push
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
function dev() {
    # git pulls develop if no argument is specified; if there's an argument, bonus merges develop into the branch specified
    co develop && git pull
    if ! [[ -z "$1" ]]; then
        co $1 && git merge develop
        if [[ "$2" == "-p" ]]; then
            git push
        fi
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
function br_new () {
    if [[ -z "$1" ]]; then
        echo "Please specify a new branch name."
    else
        if [[ -z "$2" ]]; then
            dev && co -b $1
        else
            co $2 && co -b $1
        fi
    fi
}

# rm aliases cuz goddamn
alias rm="rm -i"
alias srm="srm -i"

# ls aliases
alias ll="ls -ahl"
alias l="ls -AF"

# This is for work at Radweb. Once I'm outta this place then just delete this
# Opens the debugging menu on the test Android phone
alias debug_android_menu="adb -s ce031713c113b91501 shell input keyevent 82"
alias debug_android_start="react-native run-android --deviceId ce031713c113b91501"
