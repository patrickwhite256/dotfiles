#!/bin/bash

# I thought about using puppet or chef or something, but that seems like
# an insanely heavy dependency for something this small.

PICK_VER=4.0.0
mkdir -p logs

green(){
    printf "\e[0;32m$@\e[0m\n"
}

cyan(){
    printf "\e[0;36m$@\e[0m\n"
}

cyanbold(){
    printf "\e[1;36m$@\e[0m\n"
}

red(){
    printf "\e[0;31m$@\e[0m\n"
}

shopt -s dotglob

cyanbold "Installing dotfiles"
for f in rcs/*
do
    f=$(basename $f)
    cyan " - Installing $f"
    if [ -s ~/$f ]; then
        if [ -h ~/$f ]; then
            cyan "  - Found ~/$f linked already. Skipping."
            continue
        fi
        if [ -s ~/$f.local ]; then
            red "  - Could not install $f; ~/$f and ~/$f.local found"
            continue
        else
            mv -n ~/$f ~/$f.local
        fi
        # TODO: maybe prompt to move?
        cyan "  - Moved existing file ~/$f to ~/$f.local"
    fi
    ln -s $(pwd)/rcs/$f ~/$f
    green "  - Successfully installed $f"
done

# couple additional ones for nvim that aren't in $(HOME)
mkdir -p ~/.config/nvim
declare -A special_symlinks=( [~/.config/nvim/init.vim]=~/.vimrc [~/.config/nvim/coc-settings.json]=$(pwd)/rcs_special/coc-settings.json )

for f in "${!special_symlinks[@]}"; do
    cyan " - Installing $f"
    if [ -s $f ]; then
        if [ -h $f ]; then
            cyan "  - Found $f linked already. Skipping."
            continue
        fi
        if [ -s $f.local ]; then
            red "  - Could not install $f; $f and $f.local found"
            continue
        fi
        # TODO: maybe prompt to move?
        mv -n $f $f.local
        cyan "  - Moved existing file ~/$f to ~/$f.local"
    fi
    ln -s ${special_symlinks[$f]} $f
    green "  - Successfully installed $f"
done

root_dir=$(pwd)

cyanbold "Installing extra lib files"
for f in lib/*
do
    f=$(basename $f)
    cyan " - Installing $f"
    if [ -s ~/lib/$f ]; then
        if [ -h ~/lib/$f ]; then
            cyan "  - Found ~/lib/$f linked already. Skipping."
            continue
        fi
        if [ -s ~/lib/$f.local ]; then
            red "  - Could not install $f; ~/lib/$f and ~/lib/$f.local found"
            continue
        else
            mv -n ~/lib/$f ~/lib/$f.local
        fi
        # TODO: maybe prompt to move?
        cyan "  - Moved existing file ~/lib/$f to ~/lib/$f.local"
    fi
    ln -s $(pwd)/lib/$f ~/lib/$f
    green "  - Successfully installed $f"
done

which git > /dev/null
if [ $? -ne 0 ]; then
    red "git not installed, exiting"
    exit 1
fi
echo

# TODO: fzf, direnv
cyanbold "Installing utilities"
mkdir -p ~/lib
mkdir -p ~/bin
if [ `uname -s` == "Darwin" ]; then
    source mac-utils.sh
else
    source linux-utils.sh
fi
echo

cyan "Installing zgen"
if [ -s ~/.zgen ]; then
    cyan " - zgen found"
else
    git clone https://github.com/tarjoilija/zgen.git "${HOME}/.zgen"
fi

cyanbold "Installing vim plugins"
if [ -s ~/.vim/bundle/Vundle.vim ]; then
    cyan "  - Vundle found"
else
    cyan "  - Installing Vundle"
    mkdir -p ~/.vim/bundle
    git clone https://github.com/VundleVim/Vundle.vim.git ~/.vim/bundle/Vundle.vim
fi
vim +BundleInstall +qall
echo

green "All done!"
