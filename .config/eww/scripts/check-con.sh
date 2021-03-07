#!/bin/bash

connections="$(nmcli -f IN-USE,SSID,RATE,SIGNAL,BARS,SECURITY -t dev wifi)"

case $1 in
	active)
		active="$(echo "$connections" | grep '*' | cut -d':' -f2)"
		[[ -z "$active" ]] && active="None"
		echo "$active" ;;
	list)
		list="$(echo "$connections" | cut -d':' -f2)"
		echo "$list" ;;
esac
