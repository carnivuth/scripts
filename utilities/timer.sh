#!/bin/bash
if [[ "$#" != 1 ]]; then
    echo 'usage:'
    echo 'timer.sh minutes'
    exit 1
fi

echo "notify-send -a Alarm 'time for a break' 'time for a break' " | at now +$1 minutes