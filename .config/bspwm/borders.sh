#!/bin/sh
#
#   double borders
#

outer='0x2a2a2a'   # outer
inner1='0x565050'  # focused
inner2='0x3a3a3a'  # normal

targets() {
	case $1 in
		focused) bspc query -N -n .local.focused.\!fullscreen;;
		normal)  bspc query -N -n .local.\!focused.\!fullscreen;;
		active) bspc query -N -n .active.\!focused.\!fullscreen
	esac
}

draw() { chwb2 -I "$i" -O "$o" -i "2" -o "15" $@ 2> /dev/null; }

# initial draw, and then subscribe to events
{ echo; bspc subscribe node_geometry node_focus; } |
	while read -r _; do
		i=$inner1 o=$outer draw "$(targets focused)"
		i=$inner2 o=$outer draw "$(targets  normal)"
		i=$inner2 o=$outer draw "$(targets  active)"		
	done
