#!/bin/bash
if [ `uname -s` == "Darwin" ]; then
    /System/Library/PrivateFrameworks/Apple80211.framework/Versions/Current/Resources/airport -I | grep ' SSID' | cut -d':' -f2 
else
    echo $(iwgetid -r)
fi
