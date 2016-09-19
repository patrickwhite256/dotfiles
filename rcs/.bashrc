# TODO:
# - limit length of PWD in PS1

if [ -e $HOME/.bashrc.local ]; then
    source $HOME/.bashrc.local
fi

export PATH=$HOME/bin:$PATH:$GOPATH/bin
export GOPATH=$HOME/workspace/go

# if i have a custom build/have neovim, use that
if [[ -s ~/bin/vim ]]; then
    export EDITOR=$HOME/bin/vim
else
    export EDITOR=vim
fi

if [ -z "$SSH_TTY" ]; then
    export NOT_SSH=1
fi

if [ `uname -s` == "Darwin" ]; then
    export IS_MAC=1
fi

source ~/.bash_aliases

check_virtualenv() {
    if [ -e .venv ]; then
        if [ -d .venv ]; then
            echo "Working on .venv"
            source .venv/bin/activate
        else
            env=$(cat .venv)
            echo "Working on ${env}"
            workon $env
        fi
        VENV_ROOT="$(pwd)"
    elif [ -n "$VENV_ROOT" ]; then
        if [[ "$(pwd)" != *"$VENV_ROOT"* ]]; then
            deactivate
            unset VENV_ROOT
        fi
    fi
}

venv_cd() {
    builtin cd "$@" && check_virtualenv
}

# TODO: this is annoying. find some way to save history on pane close.
# preserve history in multiple tmux panes
# export HISTCONTROL=ignoredups:erasedups
# shopt -s histappend
# export PROMPT_COMMAND="history -a; history -c; history -r; $PROMPT_COMMAND"

# almost entirely stolen from @ke2mcbri
hpick() {
    if [ -z $@ ]; then
        CMD=$(history | grep -v hpick | tr -s ' ' | cut -d' ' -f3- | sort | uniq | pick)
    else
        CMD=$(history | grep -v hpick | grep $@ | tr -s ' ' | cut -d' ' -f3- | sort | uniq | pick)
    fi
    echo "$CMD"
    history -s "$CMD"
    eval "$CMD"
}

dog(){
    cat $@ | highlight -O ansi
}

# Assumption is you've already set up ssh configs such that you can just
# type "ssh server" but it doesn't feel like home
# This changes that
make_it_feel_like_home() {
    server=$1
    if [ -z "$server" ]; then
        echo "Usage: make_it_feel_like_home SERVER"
        return
    fi
    dotfiles_dir=$(dirname $(dirname $(readlink $HOME/.bashrc)))
    scp -r $dotfiles_dir $server:~/dotfiles
    ssh $server "cd ~/dotfiles && ./install.sh"
}

set -o vi
bind -m vi-insert "\C-l":clear-screen # why is this not default
bind -m vi-insert "\C-i":complete

# Reset
rst='\e[0m'             # Text Reset

# Regular Colours
red='\e[0;31m'        # Red
gre='\e[0;32m'        # Green

# Bold Colours
bcya='\e[1;36m'       # Cyan (bold)
byel='\e[1;33m'       # Yellow (bold)
bgre='\e[1;32m'       # Green (bold)
bblu='\e[1;34m'       # Blue (bold)

branch_color() {
  if git diff --quiet 2>/dev/null >&2;
  then
    color=$gre
  else
    color=$red
  fi
  echo -ne $color
}

host_color() {
    if [ -z "$NOT_SSH" ]; then
        echo -ne $bcya
    else
        return
    fi
}

check_dotfiles_updates() {
    # cache result for 8 hours
    if [ -e ~/.dotfile_check ]; then
        cur_date=$(date +%s)
        mod_date=$(date +%s -r ~/.dotfile_check)
        if (( $((cur_date - mod_date)) <= 28800 )); then
            return
        fi
    fi
    dotfiles_dir=$(dirname $(dirname $(readlink $HOME/.bashrc)))
    local_head=$(cd $dotfiles_dir && git rev-parse HEAD)
    remote_head=$(cd $dotfiles_dir && git ls-remote origin | head -n 1 | cut -f1)
    if [[ "$local_head" != "$remote_head" ]]; then
        echo -ne "$byel"
        echo -n "Dotfiles are out of date! To upgrade: cd $dotfiles_dir && git pull"
        echo -e "$rst"
    fi
    touch ~/.dotfile_check
}

git_pwd_prefix() {
    ROOT=$(basename $(git rev-parse --show-toplevel 2>/dev/null) 2>/dev/null)
    ALT_PWD=${PWD/#$HOME/\~}
    if [ -z $ROOT ]; then
        echo -n $ALT_PWD
        return
    fi
    echo -n ${ALT_PWD%%$ROOT*}
}

git_pwd_root() {
    ROOT=$(basename $(git rev-parse --show-toplevel 2>/dev/null) 2>/dev/null)
    echo -n $ROOT
}

git_pwd_postfix() {
    ROOT=$(basename $(git rev-parse --show-toplevel 2>/dev/null) 2>/dev/null)
    ALT_PWD=${PWD/#$HOME/\~}
    if [ -z $ROOT ]; then
        return
    fi
    echo -n ${ALT_PWD#*$ROOT}
}

make_it_rainbow() {
    for x in 0 1 4 5 7 8; do
        for i in {30..37}; do
            for a in {40..47}; do
                echo -ne "\e[$x;$i;$a""m\\\e[$x;$i;$a""m\e[0;37;40m ";
            done
            echo
        done
    done
    echo -e "\e[0m"
}

# credit to @svrana
is() {
    if [ -z "$1" ]; then
        return
    fi

    ps aux | head -n1
    ps aux | grep -v grep | grep "$@" -i --color=auto
}

# switch Go projects
sp() {
    projects=$(find $GOPATH/src -maxdepth 3 -mindepth 3 -type d | sed 's_.*src/__')
    if [ -n "$1" ];then
        projects=$(echo "$projects" | grep $1)
    fi
    if [ $(echo "$projects" | wc -l ) == "1" ]; then
        cd $GOPATH/src/$projects
    else
        cd $GOPATH/src/$(echo "$projects" | pick)
    fi
}

bind '"\C-p":"vim +CtrlP\n"'

# debian chroot
PS1="${debian_chroot:+($debian_chroot)}"
# user@host
PS1="$PS1\[$bgre\]\u@\[\$(host_color)\]\h\[$rst\]"
# working dir
PS1="$PS1:\[$bblu\]\$(git_pwd_prefix)\[$byel\]\$(git_pwd_root)\[$bblu\]\$(git_pwd_postfix)"
# git
PS1="$PS1\[\$(branch_color)\]\$(__git_ps1)\[$rst\] \$ "
# enable for boring mode
#PS1="\[$bgre\]\u@\h\[$rst\]:\[$bblu\]\w\[$rst\] \$ "

export PS1

if [ -n "$IS_MAC" ]; then
    alias __git_ps1="git branch 2>/dev/null | grep '*' | sed 's/* \(.*\)/ (\1)/'"
    if [ -e ~/.git-completion.bash ]; then
        source ~/.git-completion.bash
    else
        echo -e "${red}git completion script not installed! Get the latest version from https://github.com/git/git/blob/master/contrib/completion/git-completion.bash$rst"
    fi
fi

check_virtualenv
check_dotfiles_updates
