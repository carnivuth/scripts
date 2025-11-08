#!/usr/bin/bash
source "$HOME/.config/scripts/settings.sh"

list_track(){
  curl -L -u $SUBSONIC_USERNAME:$SUBSONIC_PASSWORD "https://$SUBSONIC_API_ENDPOINT/getRandomSongs?size=100&v=$SUBSONIC_CLIENT_VERSION&c=$SUBSONIC_CLIENT_NAME&f=json" | jq -r '."subsonic-response".randomSongs.song[] | "\( .id)|\(.title)"' | sed 's/^/track:/g'
}

run_track(){
  echo "$1" | awk -F'|' '{print $1, $2}' | (
    read id title
    mpv --vid=no "https://$SUBSONIC_USERNAME:$SUBSONIC_PASSWORD@$SUBSONIC_API_ENDPOINT/stream?id=$id&v=$SUBSONIC_CLIENT_VERSION&c=$SUBSONIC_CLIENT_NAME"
  )
}
