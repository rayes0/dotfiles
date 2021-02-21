#!/bin/bash
# toggles herbbar

number=$(herbstclient list_monitors | wc -l)

if pgrep -x herbbar; then
	pkill herbbar
else
	case $number in
		1)
			herbbar | lemonbar -n bar -B \#a5ede6e3 -F \#6c605a -f 'SF Mono:size=11' -f 'Noto Serif CJK JP:style=SemiBold:size=10' -f 'Noto Sans CJK JP:size=10' -g 1920x30+0+0 | sh & ;;
		2)
			herbbar | lemonbar -n bar -B \#a5ede6e3 -F \#6c605a -f 'SF Mono:size=11' -f 'Noto Serif CJK JP:style=SemiBold:size=10' -f 'Noto Sans CJK JP:size=10' -g 1920x30+0+0 | sh &
			herbbar 2 | lemonbar -n bar -B \#a5ede6e3 -F \#6c605a -f 'SF Mono:size=11' -f 'Noto Serif CJK JP:style=SemiBold:size=10' -f 'Noto Sans CJK JP:size=10' -g 1920x30+1920+0 | sh & ;;
		*)
			herbbar | lemonbar -n bar -B \#a5ede6e3 -F \#6c605a -f 'SF Mono:size=11' -f 'Noto Serif CJK JP:style=SemiBold:size=10' -f 'Noto Sans CJK JP:size=10' -g 1920x30+0+0 | sh & ;;
	esac
fi

