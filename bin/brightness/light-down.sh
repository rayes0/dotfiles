#!/bin/bash
light -U 5
notify-send -h string:x-canonical-private-synchronous:brightness "Brightness" "$(light)%"
