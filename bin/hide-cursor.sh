#!/bin/bash

VALUE=$(cat /tmp/hide-cursor)

if pgrep -f xbanish >/dev/null 2>&1 && [[ $VALUE -eq 0 ]]; then
    pkill xbanish
elif [[ $VALUE -eq 0 ]]; then
    echo "1" > /tmp/hide-cursor
    xbanish -d -s -t 1000
else
    echo "0" > /tmp/hide-cursor
    xbanish -d -s -t 1
fi
