#!/bin/bash
# Show main status notification with time and date, and a couple status itemr

day_time="$(date "+%I:%M %p • %a, %b %d")"
battery="$(cat /sys/class/power_supply/BAT0/capacity)% ($(cat /sys/class/power_supply/BAT0/status))"

networks="$(nmcli --terse --fields NAME con show --active | grep -v virbr0 | grep -v tun0 | grep -v wg-mullvad)"
[[ -z "$networks" ]] && networks="none"

vpn="$(mullvad status | sed 's/Tunnel status: //g')"

bluetooth="$(systemctl status bluetooth | grep 'Active: ' | cut -d':' -f2 | xargs)"

cur_sink="$(pactl info | grep -Po '(?<=Default Sink: ).*')"
port="$(pactl list sinks | grep -A20 -B40 "node.name = \"$cur_sink\"" | grep "Active Port: " | cut -d: -f2 | sed 's/\[Out\]//g' | xargs)"
vol="$(pactl list sinks | grep -A20 -B40 "node.name = \"$cur_sink\"" | grep "Volume: front-left" | cut -d/ -f2 | xargs)"
mute="$(pactl list sinks | grep -A20 -B40 "node.name = \"$cur_sink\"" | grep "Mute: " | cut -d: -f2 | xargs)"
if [[ $mute == yes ]]; then
	vollabel="$vol (muted)"
else
	vollabel="$vol"
fi

notify-send -i calendar -h string:x-canonical-private-synchronous:barless-info "$day_time" "<i>Bat</i>: $battery\n<i>Net</i>: $networks\n<i>Bth:</i> ${bluetooth}\n<i>VPN</i>: ${vpn}\n<i>Vol</i>: $vollabel [$port]"
