#!/bin/bash
# Tmux rofi script

sessions="$(tmux list-session -F '#S #{?session_attached,(attached),(detached)}')"
choices="New session
Kill session
$sessions"

selected="$( echo "$choices" | rofi -i -dmenu -theme chooser.rasi -p "Tmux > ")"

case "$selected" in
	'New session')
		name="$(rofi -theme chooser.rasi -dmenu -p "Enter name > ")"
		[[ -z "$name" ]] && exit 0
		urxvtc -e tmux new-session -s "$name" &
		;;
	'Kill session')
		chosen="$(echo "$(tmux list-session -F '#S')" | rofi -theme chooser.rasi -dmenu -i -p "Kill session > ")"
		[[ -z "$chosen" ]] && exit 0
		confirm="$(echo -e "yes\nno" | rofi -theme confirm.rasi -dmenu -i -p "Kill ${chosen}? ")"
		[[ "$confirm" == "yes" ]] && tmux kill-session -t "$chosen"
		;;
	'')
		exit 0 ;;
	*)
		selected="${selected/ (attached)/}"
		selected="${selected/ (detached)/}"
		urxvtc -hold -e tmux attach -t "${selected}" &
		;;
esac

