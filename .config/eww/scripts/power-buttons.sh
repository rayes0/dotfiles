#!/bin/bash

answer=$(echo -e "no\nyes" | rofi -dmenu -i -no-fixed-num-lines -p "${1^} now?" -theme ~/.config/rofi/confirm.rasi)

[[ ${answer,,} != yes ]] && exit 1

# Change commands in here to match your system
case $1 in
	lock)
		mantablockscreen & ;;
	suspend)
		cmus-remote -u
		mantablockscreen &
		systemctl suspend ;;
	logout)
		pkill -U $(whoami) ;;
	hibernate)
		systemctl hibernate ;;
	reboot)
		systemctl reboot ;;
esac

