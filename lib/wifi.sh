#!/bin/bash
if [ `uname -s` == "Darwin" ]; then
# rip airport OSX 14.4
# rip networksetup OSX 15.0
    ipconfig getsummary en0 | awk -F ' SSID : '  '/ SSID : / {print $2}'
else
    echo $(iwgetid -r)
fi
