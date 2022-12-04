#!/bin/bash
# Show main status notification with time and date, and a couple status items

# day_time="$(date "+%I:%M %p   •   %a, %b %d")"

bat_stat="$(cat /sys/class/power_supply/BAT0/status)"
if [[ $bat_stat == "Discharging" ]]; then
  battery="$(cat /sys/class/power_supply/BAT0/capacity)% (discharging | $(upower -i /org/freedesktop/UPower/devices/battery_BAT0 | grep "time to empty" | cut -f2 -d':' | xargs) left)"
else
  battery="$(cat /sys/class/power_supply/BAT0/capacity)% ($bat_stat)"
fi

cpu="$(cat /sys/devices/system/cpu/cpu0/cpufreq/scaling_governor)"

networks="$(nmcli --terse --fields NAME con show --active | grep -v virbr0 | grep -v tun0 | grep -v wg-mullvad | grep -v wgivpn | grep -v proton0 | sed ':a;N;$!ba;s/\n/, /g')"
[[ -z "$networks" ]] && networks="none"

if [[ "$(mullvad status)" == **Connected** ]]; then
  vpn="$(mullvad status | sed 's/Tunnel status: Connected to //g')"
elif [[ "$(ivpn status)" == **": CONNECTED"** ]]; then
  vpn="ivpn"
elif [[ "$(doas protonvpn s)" == **Connected** ]]; then
  vpn="protonvpn"
else
  vpn="disconnected"
fi

if [[ "$(rfkill list | grep -E "hci0: Bluetooth|tpacpi_bluetooth_sw: Bluetooth" -A1 | tail -n1 | xargs)" == "Soft blocked: yes" ]]; then
  bluetooth="off"
else
  bluetooth="on"
fi

# bluetooth="$(rfkill list | grep -E "hci0: Bluetooth|tpacpi_bluetooth_sw: Bluetooth" -A1 | tail -n1 | xargs)"

if [[ "$(rfkill list | grep "phy0: Wireless LAN" -A1 | tail -n1 | xargs)" == "Soft blocked: yes" ]]; then
  wifi="off"
else
  wifi="on"
fi

cur_sink="$(pactl info | grep -Po '(?<=Default Sink: ).*')"
sink_data="$(pactl list sinks | grep -B2 -A12 "Name: $cur_sink")"
port="$(pactl list sinks | grep -B2 -A83 "Name: $cur_sink" | grep "Active Port: " | cut -d: -f2 | sed 's/\[Out\]//g' | xargs)"
vol="$(echo "$sink_data" | grep "Volume: front-left" | cut -d/ -f2 | xargs)"
mute="$(echo "$sink_data" | grep "Mute: " | cut -d: -f2 | xargs)"
if [[ $mute == yes ]]; then
	vollabel="$vol (muted)"
else
	vollabel="$vol"
fi

bg="\"#938680\""
fg="\"#ede6e3\""
onbg="\"#6c605a\""

# bg="\"#ede6e3\""
# fg="\"#6c605a\""
mono="face=\"SFMono\""

date="<span weight=\"bold\">$(date "+%a, %b %d")</span>
<span size=\"xx-large\" weight=\"bold\" $mono>$(date "+%I:%M")</span><span weight=\"bold\"> $(date "+%p")</span>"

if [[ $(cat /sys/class/power_supply/BAT0/capacity) -le 20 ]]; then
  bat_lab="<span foreground=${fg} background=\"\#8a5958\" weight=\"bold\">  bat  </span>"
else
  case $bat_stat in
    "Charging") bat_lab="<span foreground=${fg} background=\"\#a09c80\" weight=\"bold\">  bat  </span>" ;;
    "Not charging") bat_lab="<span foreground=${fg} background=${bg} weight=\"bold\">  bat  </span>" ;;
    "Discharging") bat_lab="<span foreground=${fg} background=\"\#ce9c85\" weight=\"bold\">  bat  </span>" ;;
                   esac
fi

if [[ $bluetooth == "on" ]]; then
  bth_lab="<span foreground=${fg} background=${onbg} weight=\"bold\">   ᛒ </span>"
else
  bth_lab="<span foreground=${fg} background=${bg} weight=\"bold\">   ᛒ </span>"
fi
if [[ $wifi == "on" ]]; then
  wifi_lab="<span foreground=${fg} background=${onbg} weight=\"bold\">  wifi  </span>"
else
  wifi_lab="<span foreground=${fg} background=${bg} weight=\"bold\">  wifi  </span>"
fi
if [[ $cpu == "performance" ]]; then
  cpu_lab="<span foreground=${fg} background=${onbg} weight=\"bold\">  cpu  </span>"
else
  cpu_lab="<span foreground=${fg} background=${bg} weight=\"bold\">  cpu  </span>"
fi
if [[ $vpn =~ WireGuard\ .* ]]; then
  vpn_lab="<span foreground=${fg} background=${onbg} weight=\"bold\">  vpn  </span>"
else
  vpn_lab="<span foreground=${fg} background=${bg} weight=\"bold\">  vpn  </span>"
fi

notify-send -i time -h string:x-canonical-private-synchronous:status " " \
            "$date
$bat_lab   $battery
<span foreground=${fg} background=${bg} weight=\"bold\">  net  </span>   $networks
$wifi_lab   ${wifi}\t  $bth_lab  ${bluetooth}
$cpu_lab   ${cpu}
$vpn_lab   ${vpn}
<span foreground=${fg} background=${bg} weight=\"bold\">  vol   </span>   $vollabel [$port]"

