#!/bin/bash

# setting parameters
NOTIFY=TRUE
LIMIT=20
while :
do
    PERCENTAGE=$(upower -i $(upower -e |grep BAT1) |grep percentage |cut -d':' -f2 |cut -d '%' -f1 |xargs)
    STATE=$(upower -i $(upower -e |grep BAT1) |grep state |cut -d':' -f2 |xargs)
    if [ "$STATE" == "charging" ]; then 
        NOTIFY=TRUE

    else
        if [[ "$PERCENTAGE" -lt $LIMIT ]]; then 
            if [ "$NOTIFY" == "TRUE" ]; then
            notify-send -a "Low Battery" -u critical "low battery" "the system battery has reach the $LIMIT%"
            NOTIFY=FALSE
            fi
        fi
    fi 
    sleep 10
done
