#!/usr/bin/bash
# Initial stuff. Gotta have em here at the start.
if [[ -z $DOTFILE_ROOT ]]; then
    export DOTFILE_ROOT=~/.mine_dotfiles
fi
alias mine="cd ${DOTFILE_ROOT}"
. $DOTFILE_ROOT/alias_functions/colours

# Important. Never delete.
alias please='sudo '

# IB aliases
. $DOTFILE_ROOT/alias_functions/ib

# Git aliases
. $DOTFILE_ROOT/alias_functions/git

# Nuke NPM packages
. $DOTFILE_ROOT/alias_functions/nuke_node

# Terminal aliases
. $DOTFILE_ROOT/alias_functions/terminal

# Etc
. $DOTFILE_ROOT/alias_functions/etc

# ls
. $DOTFILE_ROOT/alias_functions/ls

# Etc
. $DOTFILE_ROOT/alias_functions/etc
