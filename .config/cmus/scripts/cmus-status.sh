#!/bin/bash
# Status script for cmus. Mainly sends signals to my bars and eww.

# Update eww
kill -SIGURG $(cat ${XDG_RUNTIME_DIR}/eww-wrapper.lock) &

# These are for updating the song in my status bars. You can delete/comment these if you don't use my bar scripts
killall -SIGUSR1 musicstat.sh &
killall -SIGUSR1 herbbar &
killall -SIGUSR1 coffeebar &
exit 0
