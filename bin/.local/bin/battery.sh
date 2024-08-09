#!/bin/bash

source "$HOME/.config/settings.sh"

# setting parameters
NOTIFY="TRUE"
PREC_STATE="$(upower -i $(upower -e |grep "$BATTERY_NAME") |grep state |cut -d':' -f2 |xargs)"
while :
do
    # get battery values
    PERCENTAGE="$(upower -i $(upower -e |grep "$BATTERY_NAME") |grep percentage |cut -d':' -f2 |cut -d '%' -f1 |xargs)"
    STATE="$(upower -i $(upower -e |grep "$BATTERY_NAME") |grep state |cut -d':' -f2 |xargs)"
    # check for battery status
    if [ "$STATE" == "charging" ]; then
        NOTIFY=TRUE

    else
        # check for battery PERCENTAGE
        if [[ "$PERCENTAGE" -lt $BATTERY_LIMIT ]]; then
            if [ "$NOTIFY" == "TRUE" ]; then
            # send notification
            notify-send -a "Low Battery" -u critical "low battery" "the system battery has reach the $BATTERY_LIMIT%"
            NOTIFY=FALSE
            fi
        fi
    fi
    # check for battery status changes
    if [ "$STATE" != "discharging" ] && [ "$PREC_STATE" != "$STATE" ] && [ "$STATE" != "fully-charged" ]; then

        notify-send -a "System charging" -u normal "system charging" "system is under charge"
    fi
    PREC_STATE=$STATE
    sleep "$BATTERY_SLEEP_TIME"

done
