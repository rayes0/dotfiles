#!/bin/bash
# toggles herbbar and changes some settings to provide notifications for barless mode
# This resets when hlwm is restarted

number=$(herbstclient list_monitors | wc -l)
theme="$(cat /tmp/systheme)"
mod=Mod4

if pgrep -x herbbar >/dev/null 2>&1; then
    # barless mode
	pkill herbbar
    herbstclient keybind $mod-Up spawn bash -c '~/bin/volume/vol-up.sh'
    herbstclient keybind $mod-Down spawn bash -c '~/bin/volume/vol-down.sh'
else
    # normal mode
    herbstclient keybind $mod-Up spawn sh -c 'pactl set-sink-volume @DEFAULT_SINK@ +2%; kill -s USR1 $(cat ${XDG_RUNTIME_DIR}/herbbar.lock); kill -s USR1 $(cat ${XDG_RUNTIME_DIR}/herbbar1.lock); kill -s USR1 $(cat ${XDG_RUNTIME_DIR}/eww-wrapper.lock); killall -s USR1 volume.sh'
    herbstclient keybind $mod-Down spawn sh -c 'pactl set-sink-volume @DEFAULT_SINK@ -2%; kill -s USR1 $(cat ${XDG_RUNTIME_DIR}/herbbar.lock); kill -s USR1 $(cat ${XDG_RUNTIME_DIR}/herbbar2.lock); kill -s USR1 $(cat ${XDG_RUNTIME_DIR}/eww-wrapper.lock); killall -s USR1 volume.sh'
	case $theme in
		light)
			case $number in
				2)
					~/bin/hlwm/herbbar | lemonbar -n bar -B \#2a2a2a -F \#bebebe -f 'SF Mono:size=10.8' -f 'Victor Mono:style=Italic:size=10.8' -f 'Victor Mono:style=SemiBold Italic:size=10.8' -f 'Noto Serif CJK JP:style=SemiBold:size=10' -f 'Noto Sans CJK JP:size=10' -g 1920x30+0+0 | sh &
					~/bin/hlwm/herbbar 2 | lemonbar -n bar -B \#2a2a2a -F \#bebebe -f 'SF Mono:size=10.8' -f 'Victor Mono:style=Italic:size=10.8' -f 'Victor Mono:style=SemiBold Italic:size=10.8' -f 'Noto Serif CJK JP:style=SemiBold:size=10' -f 'Noto Sans CJK JP:size=10' -g 1920x30+1920+0 | sh & ;;
				1|*)
					~/bin/hlwm/herbbar | lemonbar -n bar -B \#2a2a2a -F \#bebebe -f 'SF Mono:size=10.8' -f 'Victor Mono:style=Italic:size=10.8' -f 'Victor Mono:style=SemiBold Italic:size=10.8' -f 'Noto Serif CJK JP:style=SemiBold:size=10' -f 'Noto Sans CJK JP:size=10' -g 1920x30+0+0 | sh & ;;
			esac
			;;
		dark|*)
			case $number in
				2)
					~/bin/hlwm/herbbar | lemonbar -n bar -B \#ede6e3 -F \#6c605a -f 'SF Mono:size=10.8' -f 'Victor Mono:style=Italic:size=10.8' -f 'Victor Mono:style=SemiBold Italic:size=10.8' -f 'Noto Serif CJK JP:style=SemiBold:size=10' -f 'Noto Sans CJK JP:size=10' -g 1920x30+0+0 | sh &
					~/bin/hlwm/herbbar 2 | lemonbar -n bar -B \#ede6e3 -F \#6c605a -f 'SF Mono:size=10.8' -f 'Victor Mono:style=Italic:size=10.8' -f 'Victor Mono:style=SemiBold Italic:size=10.8' -f 'Noto Serif CJK JP:style=SemiBold:size=10' -f 'Noto Sans CJK JP:size=10' -g 1920x30+1920+0 | sh & ;;
				1|*)
					~/bin/hlwm/herbbar | lemonbar -n bar -B \#ede6e3 -F \#6c605a -f 'SF Mono:size=10.8' -f 'Victor Mono:style=Italic:size=10.8' -f 'Victor Mono:style=SemiBold Italic:size=10.8' -f 'Noto Serif CJK JP:style=SemiBold:size=10' -f 'Noto Sans CJK JP:size=10' -g 1920x30+0+0 | sh & ;;
			esac
		;;
	esac
fi

