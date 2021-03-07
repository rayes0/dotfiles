#!/bin/bash
# toggles herbbar

number=$(herbstclient list_monitors | wc -l)
theme="$(cat /tmp/systheme)"

if pgrep -x herbbar; then
	pkill herbbar
else
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

