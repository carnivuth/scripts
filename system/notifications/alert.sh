#!/bin/bash

echo "$@" >> /home/matteo/scripts/system/notifications/logs
if [ "$1" != "Spotify" ]; then
    paplay /home/matteo/scripts/system/notifications/notification.wav
fi