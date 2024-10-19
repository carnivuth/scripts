#!/bin/bash

source "$HOME/.config/scripts/settings.sh"

 set -x
# setting parameters
NOTIFY="TRUE"
BATTERY_PATH="$(upower -e |grep "$BATTERY_NAME")"

# compute battery state
PREC_STATE="$(echo "$BATTERY_PATH" | grep state |cut -d':' -f2 |xargs)"

#upower -m | grep daemon | while read row; do
upower -m | while read row; do
    # get battery values
    PERCENTAGE="$(upower -i $BATTERY_PATH |grep percentage |cut -d':' -f2 |cut -d '%' -f1 |xargs)"
    STATE="$(upower -i $BATTERY_PATH |grep state |cut -d':' -f2 |xargs)"
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

        notify-send -a "System charging" -u normal "system charging" "system is charging"
    fi
    PREC_STATE=$STATE

done
