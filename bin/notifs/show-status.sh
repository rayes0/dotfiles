#!/bin/bash
# Show main status notification with time and date, and a couple status itemr

day_time="$(date "+%a, %b %d%n%I:%M %p")"

notify-send -i calendar -h string:x-canonical-private-synchronous:barless-info "$day_time"
