#!/bin/bash
# Moves currently selected window to a workspace, then switches to that workspace
# Requires one argument of which workspace to move to

workspace=$(expr $1 - 1)
window=$(xdotool getactivewindow)

wmctrl -i -t $workspace -r "$(printf 0x%x $window)"
xdotool set_desktop $workspace
xdotool windowfocus $window
