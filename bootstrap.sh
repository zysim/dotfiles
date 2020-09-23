#!/usr/bin/bash
BASE=~/.mine_dotfiles
OS=
ARC=$(uname -m)
DIR=$(pwd)
GIT_USERNAME=Sim
GIT_EMAIL=me@zhongyuen.dev

# Allows mv-ing dotfiles
shopt -s dotglob

# Know which OS we're on
if [[ $(uname -s) =~ "[lL]inux*" ]]; then
  OS="linux"
elif [[ $(uname -s) =~ "[dD]arwin*" ]]; then
  OS="mac"
else
  OS="other"
fi

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
  linux )
    ln -nfs "$BASE/bash_profile/profile_linux" ~/.bash_profile
    ;;
  mac )
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

# Check if fzf's installed (for Macs only)
if [[ $OS == mac && ! -x "`command -v fzf`" ]]; then
  echo "Installing fzf..."
  brew install fzf
fi

set_git () {
  read -p "Set git $1 to: (default: $2)" value
  if [[ -z $value ]]; then
    git config --global "user.$1" $2
  else
    git config --global "user.$1" $value
    echo -e "\033[0;33mGit $1 set to \"$value\".\033[0m"
  fi
}

check_git () {
  # Don't declare and init local variable in the same line.
  # See: https://www.tldp.org/LDP/abs/html/localvar.html
  local git_config_value
  git_config_value=$(git config --get --global "user.$1" &> /dev/null)

  if [[ $? -eq 0 ]]; then
    read -p "Git $1 \"$git_config_value\" already exists. Keep $1? [Yn]" keep

    case $keep in
      [nN] )
        set_git $1 $2
      ;;
      * )
        echo -e "\033[0;33mGit $2 shall remain as \"$git_config_value\".\033[0m"
      ;;
    esac
  else
    set_git $1 $2
  fi
}

# Setting git stuff
check_git name $GIT_USERNAME
check_git email $GIT_EMAIL

git config --global core.editor 'vim'
git config --global core.excludesfile ~/.gitignore

echo "Git stuff set"

# Awesome Vim Stuff
ln -nfs $BASE/.vim_runtime ~/.vim_runtime
. $BASE/.vim_runtime/install_awesome_vimrc.sh

# Check if curl's installed
if ! [ -x "`command -v curl`" ]; then
  echo "Installing curl..."
    sudo apt install -y curl
fi

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
read -p "Source .bash_profile and .bash_aliases? [Yn]" ans
if [[ $ans =~ ^[nN]$ ]]; then
  echo -e "\033[0;33mNot sourcing.\033[0m"
else
  . ~/.bash_profile
fi

# Prompt to remove installation directory
if [[ $BASE != $DIR ]]; then
  read -p "Remove $DIR? [yN]" remove
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
