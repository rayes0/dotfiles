current=`light`%

light -A 5
notify-send -h string:x-canonical-private-synchronous:brightness "Brightness Up" "$current"
