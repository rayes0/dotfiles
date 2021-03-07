#!/bin/bash
# Temporarily show weather info in place of the cmus widget
# Will be overriden when cmus sends a status change, or when the user clicks the button again

current="$(eww state | grep 'mus_whennotplaying:')"

if [[ "${current/mus_whennotplaying: /}" == "true" ]]; then
	eww update mus_whennotplaying="false" &
	eww update mus_whenplaying="true" &
elif [[ "${current/mus_whennotplaying: /}" == "false" ]]; then
	notify-send weather
	eww update mus_whennotplaying="true" &
	eww update mus_whenplaying="false" &
fi

