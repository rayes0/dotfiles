#!/usr/bin/env bash

rofi_command="rofi -theme ~/.config/rofi/powermenu.rasi -m -4"

# Options
shutdown="襤"
reboot="ﰇ"
#lock=""
suspend="⏾"
logout=""
hibernate="鈴"

user=$(whoami)

# Variable passed to rofi
options="$shutdown\n$reboot\n$suspend\n$hibernate\n$logout"

chosen="$(echo -e "$options" | $rofi_command -dmenu -selected-row 2)"

case $chosen in
    $shutdown)
		answer=$(echo -e "no\nyes" | rofi -dmenu -i -no-fixed-num-lines -p "襤 Shutdown now?" -theme ~/.config/rofi/confirm.rasi)
		;;
    $reboot)
		answer=$(echo -e "no\nyes" | rofi -dmenu -i -no-fixed-num-lines -p "ﰇ Reboot now?" -theme ~/.config/rofi/confirm.rasi)
        ;;
#    $lock)
#        ;;
    $hibernate)
		answer=$(echo -e "no\nyes" | rofi -dmenu -i -no-fixed-num-lines -p "鈴  Hibernate now?" -theme ~/.config/rofi/confirm.rasi)
		;;
    $suspend)
		answer=$(echo -e "no\nyes" | rofi -dmenu -i -no-fixed-num-lines -p "⏾ Suspend now?" -theme ~/.config/rofi/confirm.rasi)
        ;;
    $logout)
		answer=$(echo -e "no\nyes" | rofi -dmenu -i -no-fixed-num-lines -p "  Logout now?" -theme ~/.config/rofi/confirm.rasi)
        ;;
esac

[[ ${answer,,} != yes ]] && exit 1

# XXX
### Modify to your system ###
case $chosen in
    $shutdown)
        systemctl poweroff
        ;;
    $reboot)
        systemctl reboot
        ;;
#    $lock)
#	mantablockscreen
#        ;;
    $hibernate)
	systemctl hibernate
	;;
    $suspend)
        cmus-remote -u
        amixer set Master mute
		~/bin/lock &
        systemctl suspend
        ;;
    $logout)
		pkill herbbar coffeebar lemonbar
		pkill eww start-eww
        pkill -KILL -U $user
        ;;
esac
