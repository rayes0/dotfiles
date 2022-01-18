#!/bin/bash
# get workspace status via wmctrl and send it in a notif
# deps: bash 4+, xprop, wmctrl

check_ws() {
  current_id=$(xprop -root -notype _NET_CURRENT_DESKTOP | cut -d'=' -f2 | xargs)
  IFS=', ' read -ra names <<< "$(xprop -root -notype _NET_DESKTOP_NAMES | cut -d'=' -f2 | xargs)"
  current_name="${names[current_id]}"
  readarray -t has_windows_id <<< "$(wmctrl -l | cut -d' ' -f3)"
  echo "${has_windows_id[@]}"

  has_windows=()
  for i in "${has_windows_id[@]}"; do
    has_windows+=("${names[i]}")
  done
  # echo "${has_windows[@]}"

  notif_string=""
  for w in "${names[@]}"; do
    if [ "$w" == "$current_name" ]; then
      notif_string+=" <b>${w}</b> "
    elif [[ " ${has_windows[*]} " =~ " ${w} " ]]; then
      notif_string+=" $w "
    fi
  done
}

check_ws
dunstify -p -i xpad -h string:x-canonical-private-synchronous:barless-info "Workspaces" "$notif_string"

# query() {
#   watch -tn 0.2 'xprop -root -notype _NET_CURRENT_DESKTOP' &
#   while sleep 0.2; 
#   wpid=$!
#   echo $wpid
#   sleep 7
#   kill $wpid
# }

# check_ws
# id1=$(dunstify -p -i xpad -h string:x-canonical-private-synchronous:barless-info "Workspaces" "$notif_string")

# while read -r; do
#   check_ws
#   id2=$(dunstify -p -i xpad -h string:x-canonical-private-synchronous:barless-info "Workspaces" "$notif_string")
# done < <(query)

# [ -n "$id1" ] && dunstify -C "$id1"
# [ -n "$id2" ] && dunstify -C "$id2"
