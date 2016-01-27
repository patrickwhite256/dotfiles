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

check_virtualenv

source ~/.bash_aliases
# Reset
Color_Off='\e[0m'       # Text Reset

# Regular Colors
Red="\e[0;31m"         # Red
Green="\e[0;32m"        # Green

branch_color() {
  if git diff --quiet 2>/dev/null >&2;
  then
    color=$Green
  else
    color=$Red
  fi
  echo -ne $color
}

PS1="$PS1\[\$(branch_color)\]\$(__git_ps1)\[\e[0m\] \$ "
