#!/bin/bash
source "$HOME/.config/scripts/settings.sh"
source "$SCRIPTS_LIB_FOLDER/notify.sh"

APP_NAME="Battery manager"
APP_ICON="/usr/share/icons/Papirus/16x16/apps/slimbookbattery.svg"
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
            notify "critical" "the system battery has reach the $BATTERY_LIMIT%"
            NOTIFY=FALSE
            fi
        fi
    fi
    # check for battery status changes
    if [ "$STATE" != "discharging" ] && [ "$PREC_STATE" != "$STATE" ] && [ "$STATE" != "fully-charged" ]; then

        notify "normal" "system is charging"
    fi
    PREC_STATE=$STATE

done
