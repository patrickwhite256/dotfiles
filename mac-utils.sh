cyan " - brew"
which brew > /dev/null
if [ $? -eq 0 ]; then
    cyan - "  - Homebrew already installed, skipping"
else
    /usr/bin/ruby -e "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/master/install)"
fi

# brew: tree, neovim/neovim/neovim, the_silver_searcher, wget, coreutils, tmux, jq
BASEUTILS=(tree wget coreutils tmux jq)
cyan " - base utils"
for util in ${BASEUTILS[@]}
do
    cyan "  - $util"
    if [ -n "$(brew ls --versions $util)" ]; then
        cyan "   - $util already installed, skipping"
    else
        brew install $util
    fi
done

cyan " - neovim"
if [ -n "$(brew ls --versions neovim)" ]; then
    cyan "   - neovim already installed, skipping"
else
    brew install neovim/neovim/neovim
    ln -s $(which nvim) ~/bin/vim
fi

cyan " - ag"
if [ -n "$(brew ls --versions the_silver_searcher)" ]; then
    cyan "   - ag already installed, skipping"
else
    brew install the_silver_searcher
fi

cyan " - pick"
if [ -s ~/bin/pick ]; then
    cyan "  - Found ~/bin/pick already, skipping"
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

cyan " - diff-so-fancy"
if [ -n "$(brew ls --versions diff-so-fancy)" ]; then
    cyan "   - diff-so-fancy already installed, skipping"
else
    brew install diff-so-fancy
fi
