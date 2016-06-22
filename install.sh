#!/bin/bash

# I thought about using puppet or chef or something, but that seems like
# an insanely heavy dependency for something this small.

PICK_VER=1.3.0
mkdir -p logs

green(){
    echo -e "\e[0;32m$@\e[0m"
}

cyan(){
    echo -e "\e[0;36m$@\e[0m"
}

cyanbold(){
    echo -e "\e[1;36m$@\e[0m"
}

red(){
    echo -e "\e[0;31m$@\e[0m"
}

dep_check() {
    # args = dependencies
    # dep_check git libtool
    # returns 0 on success, 1 on failure
    for dep in $@; do
        if [ $(dpkg-query -W -f='${Status}' $dep 2>/dev/null | grep -c "ok installed") -eq 0 ]; then
            red "$dep not found."
            return 1
        fi
    done

    return 0
}

dep_check git
if [ $? -ne 0 ]; then
    red "git not installed. exiting."
fi

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
echo

root_dir=$(pwd)

cyanbold "Installing utilities"
mkdir -p ~/lib
mkdir -p ~/bin
cyan " - pick"
if [ -s ~/bin/pick ]; then
    cyan "  - Found ~/bin/pick already, skipping"
else
    dep_check git autoconf automake cmake g++
    if [ $? -ne 0 ]; then
        red "  - Dependencies not met, skipping install"
    else
        (
            set -e
            wget https://github.com/thoughtbot/pick/releases/download/v$PICK_VER/pick-$PICK_VER.tar.gz
            tar xzvf pick-$PICK_VER.tar.gz
            mkdir -p ~/lib/pick
            cd pick-$PICK_VER
            ./configure --prefix=$HOME/lib/pick
            make
            make install

            cd $root_dir
            rm pick-$PICK_VER.tar.gz
            rm -r pick-$PICK_VER
            ln -s $HOME/lib/pick/bin/pick ~/bin/pick
        ) > $root_dir/logs/pick 2>&1
        # http://unix.stackexchange.com/questions/65532/why-does-set-e-not-work-inside
        if [ "$?" -ne 0 ]; then
            red " - Something went wrong. Check logs/pick."
        else
            green "  - Success!"
        fi
    fi
fi

cyan " - neovim"
if [ -s ~/bin/vim ]; then
    cyan "  - Found ~/bin/vim already, skipping"
else
    dep_check git libtool autoconf automake cmake g++ pkg-config unzip libmsgpack-dev libuv-dev libluajit-5.1-dev
    if [ $? -ne 0 ]; then
        red "  - Dependencies not met, skipping install"
    else
        cyan "  - This may take a while. For progress, tail $root_dir/logs/neovim."
        (
            set -e
            git clone https://github.com/neovim/neovim.git
            mkdir -p ~/lib/neovim
            cd neovim
            make CMAKE_EXTRA_FLAGS="-DCMAKE_INSTALL_PREFIX:PATH=$HOME/lib/neovim"
            make install

            cd $root_dir
            rm -rf neovim
            ln -s $HOME/lib/neovim/bin/nvim ~/bin/vim
            mkdir -p ${XDG_CONFIG_HOME:=$HOME/.config}
            ln -s ~/.vim $XDG_CONFIG_HOME/nvim
            ln -s ~/.vimrc $XDG_CONFIG_HOME/nvim/init.vim
        ) >$root_dir/logs/neovim 2>&1
        if [ "$?" -ne 0 ]; then
            red " - Something went wrong. Check logs/neovim."
        else
            green "  - Success!"
        fi
    fi
fi

cyan " - markdown"
if [ -s ~/bin/markdown ]; then
    cyan "  - Found ~/bin/markdown already, skipping"
else
    (
        set -e
        wget http://daringfireball.net/projects/downloads/Markdown_1.0.1.zip
        unzip Markdown_1.0.1.zip
        rm Markdown_1.0.1.zip
        mv Markdown_1.0.1 ~/lib/markdown
        ln -s ~/lib/markdown/Markdown.pl ~/bin/markdown
    ) >$root_dir/logs/markdown 2>&1
    if [ "$?" -ne 0 ]; then
        red " - Something went wrong. Check logs/markdown"
    else
        green "  - Success!"
    fi
fi

cyan " - ag"
if [ -s ~/bin/ag ]; then
    cyan "  - Found ~/bin/ag already, skipping"
else
    dep_check automake pkg-config libpcre3-dev zlib1g-dev liblzma-dev
    if [ $? -ne 0 ]; then
        red "  - Dependencies not met, skipping install"
    else
        (
            set -e
            git clone https://github.com/ggreer/the_silver_searcher.git
            cd the_silver_searcher
            ./build.sh --prefix=$HOME/lib/tss
            make install
            cd $root_dir
            rm -rf the_silver_searcher
            ln -s ~/lib/tss/bin/ag ~/bin/ag
        ) >$root_dir/logs/ag 2>&1
        if [ "$?" -ne 0 ]; then
            red " - Something went wrong. Check logs/ag"
        else
            green "  - Success!"
        fi
    fi
fi

echo

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
