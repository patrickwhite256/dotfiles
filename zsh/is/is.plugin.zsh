# quick wrapper for ps aux | grep that includes the header
# credit to @svrana

is() {
    if [ -z "$1" ]; then
        return
    fi

    ps aux | head -n1
    ps aux | grep -v grep | grep "$@" -i --color=auto
}
