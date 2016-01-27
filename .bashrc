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
Color_Off='\e[0m'       # Text Reset

# Regular Colors
Red="\e[0;31m"          # Red
Green="\e[0;32m"        # Green
Cyan="\e[1;36m"         # Cyan (bold)

branch_color() {
  if git diff --quiet 2>/dev/null >&2;
  then
    color=$Green
  else
    color=$Red
  fi
  echo -ne $color
}

if [ -z "$SSH_TTY" ]; then
    NOT_SSH=1
fi

host_color() {
    if [ -z "$NOT_SSH" ]; then
        echo -ne $Cyan
    else
        return
    fi
}

# normal - with hax for ssh host colouring
PS1="${debian_chroot:+($debian_chroot)}\[\033[01;32m\]\u@\[\$(host_color)\]\h\[\033[00m\]:\[\033[01;34m\]\w\[\033[00m\]"
# normal with git!
PS1="$PS1\[\$(branch_color)\]\$(__git_ps1)\[\e[0m\] \$ "
