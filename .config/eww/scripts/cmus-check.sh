#!/bin/bash
# This is only run when the eww window is open

cmus_stats="$(cmus-remote -Q)" || exit 0
#status="$(echo "$cmus_stats" | grep "status " | cut -d' ' -f2)"

changetomin() { printf "%d:%02d" "$((10#$1 / 60))" "$((10#$1 % 60))"; }

pos="$(echo "$cmus_stats" | grep "position" | cut -d' ' -f2)"
eww update mus_position_min="$(changetomin "$pos")" &
echo "$pos"
