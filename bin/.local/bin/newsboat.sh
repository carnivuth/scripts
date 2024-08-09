#!/bin/bash
source "$HOME/.config/scripts/settings.sh"

# refresh newsboat
newsboat -x reload
unread_count=`newsboat -x print-unread | awk '{print $1}'`
echo "unread count $unread_count"

# check if there are unread news
if [[ "$unread_count" -gt 0 ]]; then
    notify-send -a "News" -u normal "Unread news" "there are $unread_count unread news"
    date="$(date)"
    echo "sent notification at $date"
fi
