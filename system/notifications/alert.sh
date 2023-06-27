#!/bin/bash

echo "$@" >> "$HOME"/scripts/system/notifications/logs
if [ "$1" != "Spotify" ]; then
	if [ "$1" != "networkmanager-dmenu" ]; then
    cvlc --play-and-exit "$HOME"/scripts/system/notifications/notification.wav
fi
fi
