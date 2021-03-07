#!/bin/bash
# Gets weather from wttr.in

eww update retry_status="..."

# Check connection
if ! ping -q -c 1 -W 1 wttr.in >/dev/null; then
	eww update whenconnected="false"
	eww update whennotconnected="true"
	eww update weather_lastcheck="$(date '+%I:%M %p')"
	eww update retry_status="Failed!"
	sleep 3
	eww update retry_status="Click to retry"
	exit 1
fi

source ~/.config/eww/eww-prefs

weather_raw="$(curl wttr.in/${weather_location:-Calgary}?format=j1 2> /dev/null)"

weather_current="$(echo "$weather_raw" | jq --raw-output '.current_condition | .[0]')"
weather_area="$(echo "$weather_raw" | jq --raw-output '.nearest_area | .[0]')"
weather_sun="$(echo "$weather_raw" | jq --raw-output '.weather | .[0].astronomy | .[0]')"

desc="$(echo "$weather_current" | jq --raw-output '.weatherDesc | .[0].value')"

if [[ "$temp_units" == "F" ]]; then
	temp="$(echo "$weather_current" | jq --raw-output '.temp_F')°F"
	feel_temp="$(echo "$weather_current" | jq --raw-output '.FeelsLikeF')°F"
else
	temp="$(echo "$weather_current" | jq --raw-output '.temp_C')°C"
	feel_temp="$(echo "$weather_current" | jq --raw-output '.FeelsLikeC')°C"
fi

if [[ "$wind_units" == "miles" ]]; then
	wind="$(echo "$weather_current" | jq --raw-output '.windspeedMiles')mi"
else
	wind="$(echo "$weather_current" | jq --raw-output '.windspeedKmph')km/h"
fi
wind_dir="$(echo "$weather_current" | jq --raw-output '.winddir16Point')"

area="$(echo "$weather_area" | jq --raw-output '.areaName | .[0].value')"
country="$(echo "$weather_area" | jq --raw-output '.country | .[0].value')"

sunrise="$(echo "$weather_sun" | jq --raw-output '.sunrise')"
sunset="$(echo "$weather_sun" | jq --raw-output '.sunset')"

shopt -s nocasematch
# Order matters for these
case "$desc" in
	*snow*)
		case "$desc" in
			*heavy*)
				icon="" ;;
			*drifting*)
				icon="" ;;
			*)
				icon="" ;;
		esac
		;;
	*blizzard*)
		icon="流" ;;
	*sleet*)
		icon="" ;;
	*rain*|*drizzle*)
		case "$desc" in 
			*thunder*)
				icon="" ;;
			*patchy*)
				icon="" ;;
			*)
				icon="" ;;
		esac
		;;
	'Sunny')
		icon="" ;;
	'Partly cloudy')
		#icon="" ;;
		icon="杖" ;;
	'Very Cloudy'|'Cloudy'|'Overcast')
		icon="" ;;
	'Clear')
		icon="" ;;
	*fog*|*mist*)
		icon="" ;;
	*fair*)
		icon="" ;;
	*)
		icon="" ;;
esac

eww update weather_icon="$icon" &
eww update weather_desc="$desc" &
eww update weather_temp="$temp" &
eww update weather_ftemp="$feel_temp" &

eww update weather_wind="$wind $wind_dir" &

eww update weather_area="$area" &
eww update weather_country="$country" &

eww update weather_sunrise="$sunrise" &
eww update weather_sunset="$sunset" &

eww update weather_lastcheck="$(date '+%I:%M %p')" &
wait
eww update whenconnected="true" &
eww update whennotconnected="false" &
