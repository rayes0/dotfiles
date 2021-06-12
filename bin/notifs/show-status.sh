#!/bin/bash
# Show main status notification with time and date, and a couple status itemr

day_time="$(date "+%I:%M %p • %a, %b %d")"
battery="$(cat /sys/class/power_supply/BAT0/capacity)% ($(cat /sys/class/power_supply/BAT0/status))"

notify-send -i calendar -h string:x-canonical-private-synchronous:barless-info "$day_time" "Bat: $battery"
