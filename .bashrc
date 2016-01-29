# TODO:
# - limit length of PWD in PS1

if [ -e $HOME/.bashrc.local ]; then
    source $HOME/.bashrc.local
fi
if [ -e /usr/local/bin/virtualenvwrapper.sh ]; then
    source /usr/local/bin/virtualenvwrapper.sh
    VIRTUALENVWRAPPER_PYTHON=/usr/bin/python3
fi
PATH=$PATH:/home/patrick/workspace/llvm/build/Release/bin:$HOME/bin
export EDITOR=vim

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

# Assumption is you've already set up ssh configs such that you can just
# type "ssh server" but it doesn't feel like home
# This changes that
make-it-feel-like-home() {
    server=$1
    if [ -z "$server" ]; then
        echo "Usage: make-it-feel-like-home SERVER"
        return
    fi
    dotfiles_dir=$(dirname $(readlink $HOME/.bashrc))
    scp -r $dotfiles_dir $server:~/dotfiles
    ssh $server "cd ~/dotfiles && make"
}

check_virtualenv

source ~/.bash_aliases
# Reset
rst='\e[0m'             # Text Reset

# Regular Colors
red="\e[0;31m"          # Red
gre="\e[0;32m"          # Green
bcya="\e[1;36m"         # Cyan (bold)
byel="\e[1;33m"         # Yellow (bold)
bblu="\033[1;34m"         # Blue (bold)

branch_color() {
  if git diff --quiet 2>/dev/null >&2;
  then
    color=$gre
  else
    color=$red
  fi
  echo -ne $color
}

if [ -z "$SSH_TTY" ]; then
    NOT_SSH=1
fi

host_color() {
    if [ -z "$NOT_SSH" ]; then
        echo -ne $bcya
    else
        return
    fi
}

git_color_pwd() {
    ROOT=$(basename $(git rev-parse --show-toplevel 2>/dev/null) 2>/dev/null)
    ALT_PWD=${PWD/#$HOME/\~}
    if [ -z $ROOT ]; then
        echo -ne $bblu$ALT_PWD
        return
    fi
    echo -ne "$bblu${ALT_PWD/$ROOT/$byel$ROOT$bblu}"
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
    echo -n ${ALT_PWD##*$ROOT}
}

# debian chroot
PS1="${debian_chroot:+($debian_chroot)}"
# user@host
PS1="$PS1\[\033[01;32m\]\u@\[\$(host_color)\]\h\[\033[00m\]"
# working dir
PS1="$PS1:\[$bblu\]\$(git_pwd_prefix)\[$byel\]\$(git_pwd_root)\[$bblu\]\$(git_pwd_postfix)"
#PS1="$PS1:\[\033[01;34m\]\w\[\\033[0m\]" # BOOOOORIIING
# git
PS1="$PS1\[\$(branch_color)\]\$(__git_ps1)\[\e[0m\] \$ "
