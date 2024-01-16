dep_check() {
    # TODO:
    # check for presence of either "dkpg-query" or "rpm"
    # args = dependencies
    # dep_check git libtool
    # returns 0 on success, 1 on failure
    for dep in $@; do
        if [ $(rpm -q $dep 2>/dev/null | grep -c "not installed") -ne 0 ]; then
        # if [ $(dpkg-query -W -f='${Status}' $dep 2>/dev/null | grep -c "ok installed") -eq 0 ]; then
            red "$dep not found."
            return 1
        fi
    done

    return 0
}

cyan " - pick"
if [ -s ~/bin/pick ]; then
    cyan "  - Found ~/bin/pick already, skipping"
else
    # dep_check git autoconf automake cmake g++
    dep_check git autoconf automake cmake gcc-c++
    if [ $? -ne 0 ]; then
        red "  - Dependencies not met, skipping install"
    else
        (
            set -e
            wget https://github.com/mptre/pick/releases/download/v$PICK_VER/pick-$PICK_VER.tar.gz
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
    # dep_check git libtool autoconf automake cmake g++ pkg-config unzip libmsgpack-dev libuv-dev libluajit-5.1-dev
    dep_check ninja-build libtool autoconf automake cmake gcc gcc-c++ make pkgconfig unzip patch gettext
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
    # dep_check automake pkg-config libpcre3-dev zlib1g-dev liblzma-dev
    dep_check pkgconfig automake gcc zlib-devel pcre-devel xz-devel
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

cyan " - diff-so-fancy"
if [ -s ~/bin/diff-so-fancy ]; then
    cyan "  - Found ~/bin/diff-so-fancy already, skipping"
else
    (
        set -e
        git clone https://github.com/so-fancy/diff-so-fancy.git
        cd diff-so-fancy
        cp -r diff-so-fancy libexec third_party/diff-highlight/diff-highlight ~/bin
        chmod +x ~/bin/diff-highlight
        cd ..
        rm -rf diff-so-fancy
    ) >$root_dir/logs/diff-so-fancy 2>&1
    if [ "$?" -ne 0 ]; then
        red " - Something went wrong. Check logs/diff-so-fancy"
    else
        green "  - Success!"
    fi
fi

