#!/bin/bash

# Get number of quotes and pick one
number="$(jq 'max_by(.id) | .id' ~/.config/eww/quotes.json)"
id=$((1 + $RANDOM % $number))

#full="$(jq ".[] | select(.id==$id)" ~/.config/eww/quotes.json)"

countdown() {
	min=15
	while [ $min -gt 0 ]; do
		eww update quote-time="$min"
		sleep 60
		: $((min--))
	done

}

eww update quote-text="$(jq --raw-output ".[] | select(.id==$id) | .text" ~/.config/eww/quotes.json)" &
eww update quote-author="$(jq --raw-output ".[] | select(.id==$id) | .author" ~/.config/eww/quotes.json)" &
eww update quote-title="$(jq --raw-output ".[] | select(.id==$id) | .title" ~/.config/eww/quotes.json)" &
eww update quote-number="$id / $number" &

countdown

# Restart on exit
exec "$(readlink -f "$0")"

