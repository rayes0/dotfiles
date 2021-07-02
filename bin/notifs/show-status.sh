#!/bin/bash
# Show main status notification with time and date, and a couple status itemr

day_time="$(date "+%I:%M %p • %a, %b %d")"
battery="$(cat /sys/class/power_supply/BAT0/capacity)% ($(cat /sys/class/power_supply/BAT0/status))"

networks="$(nmcli --terse --fields NAME con show --active)"
[[ -z "$networks" ]] && networks="none"

cur_sink="$(pactl info | grep -Po '(?<=Default Sink: ).*')"
port="$(pactl list sinks | grep -A15 "node.name = \"$cur_sink\"" | tail -n1 | cut -d: -f2 | sed 's/\[Out\]//g' | sed 's/ //g')"
vol="$(pactl list sinks | grep -B39 "node.name = \"$cur_sink\"" | head -n1 | cut -d/ -f2 | sed 's/ //g')"
mute="$(pactl list sinks | grep -B40 "node.name = \"$cur_sink\"" | head -n1 | cut -d: -f2 | sed 's/ //g')"
if [[ $mute == yes ]]; then
	vollabel="$vol (muted)"
else
	vollabel="$vol"
fi

notify-send -i calendar -h string:x-canonical-private-synchronous:barless-info "$day_time" "<i>Bat</i>: $battery\n<i>Net</i>: $networks\n<i>Vol</i>: $vollabel [$port]"
