#!/bin/bash

echo "$@" >> /home/matteo/scripts/system/notifications/logs
if [ "$1" != "Spotify" ]; then
	if [ "$1"!= "networkmanager-dmenu" ]; then
    paplay /home/matteo/scripts/system/notifications/notification.wav
fi
fi
