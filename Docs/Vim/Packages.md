Taken from https://shapeshed.com/vim-packages/

# Check if Vim Version Supports Packages
1. Go into Vim
1. `:echo has('packages')`
1. See if it prints `1`

# Before Installing Package
1. Locate `.vim` folder (E.g.: `~/.vim`. Should have it aliased to `~/.mine_dotfiles/vim`)
1. `mkdir ~/.vim/pack/mine/{start,opt}`
  - `start` loads on Vim start. `opt` loads when you call `:packadd <package>`

# Installing Package
```bash
cd ~/.mine_dotfiles
git submodule init
git submodule add <repo> ~/.mine_dotfiles/vim/pack/mine/{start,opt}/<package>
git add .gitmodules ~/.mine_dotfiles/vim/pack/mine/{start,opt}/<package>
ci -nm "Add Stuff"
```

# Updating Packages
```bash
git submodule update --remote --merge
ci
```

# Remove A Package
```bash
git submodule deinit ~/.mine_dotfiles/vim/pack/mine/{start,opt}/<package>
git rm ~/.mine_dotfiles/vim/pack/mine/{start,opt}/<package>
rm -rf ~/.mine_dotfiles/.git/modules/vim/pack/mine/{start,opt}/<package>
ci
```
