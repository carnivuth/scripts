#!/usr/bin/env bash
# get_weather.sh
source "$HOME/.config/settings.sh"

# get data from wttr
text=$(curl -s "https://wttr.in/$WEATHER_LOCATION?d&format=3")

if [[ $? == 0 ]]; then
    #text=$(echo "$text" | sed -E "s/\s+/ /g")
    tooltip=$(curl -s "https://wttr.in/$WEATHER_LOCATION?format=4")
    if [[ $? == 0 ]]; then
        #tooltip=$(echo "$tooltip" | sed -E "s/\s+/ /g")
        echo "{\"text\":\"$text\", \"tooltip\":\"$tooltip\"}"
        exit
    fi
fi
