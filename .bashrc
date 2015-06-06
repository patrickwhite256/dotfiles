VIRTUALENVWRAPPER_PYTHON=/usr/bin/python3
PATH=$PATH:/home/patrick/workspace/llvm/build/Release/bin
source /usr/local/bin/virtualenvwrapper.sh

check_virtualenv() {
    if [ -e .venv ]; then
        env=$(cat .venv)
        echo "Working on ${env}"
        workon $env
        VENV_ROOT=$(pwd)
    elif [ -n "$VENV_ROOT" ]; then
        if [ "$(pwd)" != *"$VENV_ROOT"* ]; then
            deactivate
            unset VENV_ROOT
        fi
    fi
}

venv_cd() {
    builtin cd "$@" && check_virtualenv
}

# almost entirely stolen from @ke2mcbri
hpick() {
    if [ -z $@ ]; then
        CMD=$(history | grep -v hpick | tr -s ' ' | cut -d' ' -f3- | uniq | pick)
    else
        CMD=$(history | grep -v hpick | grep $@ | tr -s ' ' | cut -d' ' -f3- | uniq | pick)
    fi
    echo "$CMD"
    history -s "$CMD"
    eval "$CMD"
}

check_virtualenv

source ~/.bash_aliases
