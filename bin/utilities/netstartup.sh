#!/bin/bash

start_programs() {
	urxvt -e weechat &
	ankisync &
	#virsh start fedora32 &
	#virt-viewer fedora32 &
	#sleep 5
	#whalebird &
}

if [[ $(protonvpn status) == *"Status:       Connected"* ]];then
	start_programs
else
	vpn.sh &
	wait
	start_programs
fi
