## source system file
#. /etc/X11/xinit/xinitrc
for file in /etc/X11/xinit/xinitrc.d/*; do
  . $file
done

# [ -x "$DBUS_SESSION_BUS_ADDRESS" ] && eval `dbus-launch --sh-syntax --exit-with-session`
# systemctl --user import-environment DISPLAY XAUTHORITY
# 
# if command -v dbus-update-activation-environment >/dev/null 2>&1; then
#   dbus-update-activation-environment DISPLAY XAUTHORITY
# fi
# 
# [ -x /usr/bin/xhost ] && [ -x /usr/bin/id ] && xhost +si:localuser:`id -un` >& /dev/null
# 
# # export XDG_DATA_DIRS="/home/rayes/.local/share/:${XDG_DATA_DIRS}"
# # 
xrdb ~/.xrsrcs

export XDG_RUNTIME_DIR=$(mktemp -d /tmp/$(id -u)-runtime-dir.XXX)
# lxpolkit &
dunst &
# # greenclip daemon &
# easystroke enable &
# # xss-lock --quiet --transfer-sleep-lock -- "$HOME/bin/lock" &
# # xset s 4800
# # # ~/builds/picom/build/src/picom --experimental-backends &
# # # xautolock -time 8 -locker "xset s activate" -secure -detectsleep &
# # # xautolock-selective &
# # 
# # ibus-daemon -drxR &
# # export XMODIFIERS=@im=ibus
# # export GTK_IM_MODULE=ibus
# # export QT_IM_MODULE=ibus
# # 
# # #fcitx -D &
# # #export XMODIFIERS=@im=fcitx
# # #export GTK_IM_MODULE=fcitx
# # #export QT_IM_MODULE=fcitx
# # 
# # # Map caps lock to escape
# # #xcape -e '#66=Escape'
# 
# stalonetray --background '#ede6e3' --geometry 1x1 --icon-size 64 --vertical --window-type dock &
# 
# setxkbmap -device "$(xinput | grep 'AT Translated Set 2' | cut -d'=' -f 2 | cut -d'	' -f1)" -layout us -option ctrl:nocaps
# # xmodmap ~/.Xmodmap
# 
# # Set key delay and repeat rate. defaults are delay: 660ms, repeat: 25Hz
# xset r rate 180 100
xset r rate 250 80

# ~/.fehbg
 
# exec xmonad
# exec dbus-run-session "$HOME/.cache/xmonad/xmonad-x86_64-linux"
exec dbus-launch --exit-with-session "$HOME/.cache/xmonad/xmonad-x86_64-linux"

