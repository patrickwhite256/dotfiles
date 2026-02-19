# shellcheck shell=bash
# Print the current date.

TMUX_POWERLINE_SEG_DATE_FORMAT="${TMUX_POWERLINE_SEG_DATE_FORMAT:-%F}"

generate_segmentrc() {
	read -r -d '' rccontents <<EORC
wow
EORC
	echo "$rccontents"
}

run_segment() {
    printf "\uf1eb "
    if [ `uname -s` == "Darwin" ]; then
    # rip airport OSX 14.4
    # rip networksetup OSX 15.0
        ipconfig getsummary en0 | awk -F ' SSID : '  '/ SSID : / {print $2}'
    else
        echo $(iwgetid -r)
    fi
	return 0
}
