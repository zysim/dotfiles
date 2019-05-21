#!/usr/bin/bash
BASE='~/.mine_dotfiles'
OS=`uname -s`
ARC=`uname -m`
mv `pwd` $BASE
cd $BASE

sudo echo

# Making symlinks
ln -nfs ~/.bash_aliases "$BASE/bash_aliases"
case $BASE in
    linux*     ) ln -nfs "$BASE/bash_profile/profile_linux" ~/.bash_profile;;
    [dD]arwin* ) ln -nfs "$BASE/bash_profile/profile_mac" ~/.bash_profile;;
esac
ln -nfs "$BASE/.bashrc" ~/.bashrc
ln -nfs "$BASE/.gitignore" ~/.gitignore
chmod u+x $BASE/scripts/*

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

# Setting git stuff
read -p 'Set git username to: (Sim)' name
if [[ -z "$name" ]]; then
	git config --global user.name 'Sim'
else
	git config --global user.name $name
fi
read -p "Set git email to: (zhongyuen@radweb.co.uk)" email
if [[ -z "$email" ]]; then
	git config --global user.email 'zhongyuen@radweb.co.uk'
else
	git config --global user.email $email
fi
git config --global core.editor 'vim'
git config --global core.excludesfile '~/.gitignore'

echo "Git stuff set"

# Awesome Vim Stuff
ln -s ~/.vim_runtime "$BASE/.vim_runtime"
. $BASE/.vim_runtime/install_awesome_vimrc.sh

# Download Node
curl -o- https://raw.githubusercontent.com/creationix/nvm/v0.34.0/install.sh | bash
if ! [[ -z "`nvm --version`" ]]; then
	nvm install node
else
	echo "NVM couldn't be run for some reason. Check it's installation, then run this file again."
	exit 1
fi
