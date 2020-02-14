#!/usr/bin/bash
BASE=~/.mine_dotfiles
OS=$(uname -s)
ARC=$(uname -m)
DIR=$(pwd)
USERNAME=Sim
EMAIL=me@zhongyuen.dev

# Allows mv-ing dotfiles
shopt -s dotglob

# Move this entire folder to ~/.mine_dotfiles if it isn't there already
if [[ -e $DIR ]]; then
  mkdir $BASE
fi

if [[ $DIR != $BASE ]]; then
  mv $DIR/* $BASE/
fi

cd $BASE

sudo echo

# Making symlinks
ln -nfs "$BASE/bash_aliases/aliases" ~/.bash_aliases
case $OS in
  [lL]inux* )
    ln -nfs "$BASE/bash_profile/profile_linux" ~/.bash_profile
    ;;
  [dD]arwin* )
    ln -nfs "$BASE/bash_profile/profile_mac" ~/.bash_profile
    ;;
esac
# ln -nfs "$BASE/.bashrc" ~/.bashrc # Eh
ln -nfs "$BASE/gitignore" ~/.gitignore
chmod u+x $BASE/bash_profile/scripts/*

echo "Stuff moved to $BASE, and symlinks all made"

# Check if git's installed
echo "Checking if git's installed..."
if ! [ -x "`command -v git`" ]; then
  echo "Installing git..."
  sudo apt install -y git
fi

# Check if vim's installed
echo "Checking if vim's installed..."
if ! [ -x "`command -v vim`" ]; then
  echo "Installing vim..."
  sudo apt install -y vim
fi

# Check if Pip's installed
if ! [ -x "`command -v pip3`" ]; then
  echo "Installing pip3..."
    sudo apt install -y python3-pip
fi

# Setting git stuff
read -p "Set git username to: ($USERNAME)" name
if [[ -z "$name" ]]; then
  git config --global user.name $USERNAME
else
  git config --global user.name $name
fi
read -p "Set git email to: ($EMAIL)" email
if [[ -z "$email" ]]; then
  git config --global user.email $EMAIL
else
  git config --global user.email $email
fi
git config --global core.editor 'vim'
git config --global core.excludesfile ~/.gitignore

echo "Git stuff set"

# Awesome Vim Stuff
ln -nfs $BASE/.vim_runtime ~/.vim_runtime
. $BASE/.vim_runtime/install_awesome_vimrc.sh

# Download Node
curl -o- https://raw.githubusercontent.com/creationix/nvm/v0.34.0/install.sh | bash

export NVM_DIR="$HOME/.nvm"
[ -s "$NVM_DIR/nvm.sh" ] && \. "$NVM_DIR/nvm.sh"  # This loads nvm
[ -s "$NVM_DIR/bash_completion" ] && \. "$NVM_DIR/bash_completion"  # This loads nvm bash_completion

if [[ ! -z "`nvm --version`" ]]; then
  nvm install node
else
  echo "NVM couldn't be run for some reason. Check it's installation, then run this file again."
fi

# Source dotfiles
read -p "\033[0;33mSource .bash_profile and .bash_aliases? [Yn]\033[0m" ans
if [[ "$ans" =~ ^[nN]$ ]]; then
  echo "Not sourcing."
else
  . ~/.bash_profile
fi

# Prompt to remove installation directory
if [[ $BASE != $DIR ]]; then
  read -p "\033[0;33mRemove $DIR? [yN]\033[0m" remove
  case $remove in
    [yY] )
      rm -rf $DIR
    ;;
    [nN] | * )
      echo -e "\033[0;33mNot removing $DIR\033[0m"
    ;;
  esac
fi

shopt -u dotglob
