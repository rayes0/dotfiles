#!/bin/bash

vpn.sh &
wait

if [[ $(protonvpn status) == *"Status:       Connected"* ]];then
	urxvt -e weechat &
	ankisync &
	#virsh start fedora32 &
	#virt-viewer fedora32 &
	#sleep 5
	#whalebird &
fi
