#!/bin/bash
source "$HOME/.config/scripts/settings.sh"
source "$SCRIPTS_LIB_FOLDER/notify.sh"

APP_NAME="News"
APP_ICON="/usr/share/icons/Papirus/32x32/apps/internet-news-reader.svg"

# refresh newsboat
newsboat -x reload
unread_count="$(newsboat -x print-unread | awk '{print $1}')"
echo "unread count $unread_count"

# check if there are unread news
if [[ "$unread_count" -gt 0 ]]; then
  notify "normal" "There are $unread_count unread news"
    date="$(date)"
    echo "sent notification at $date"
fi
