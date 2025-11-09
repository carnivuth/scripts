#!/usr/bin/bash
source "$HOME/.config/scripts/settings.sh"
source "$SCRIPTS_LIB_FOLDER/control_mpv.sh"
source "$SCRIPTS_LIB_FOLDER/subsonic_client.sh"

list_track(){
  get_tracks | sed 's/^/track:/g'
}

run_track(){
  echo "$1" | awk -F'|' '{print $1, $2}' | (
    read id title
    replace_track_on_mpv "https://$SUBSONIC_USERNAME:$SUBSONIC_PASSWORD@$SUBSONIC_API_ENDPOINT/stream?id=$id&v=$SUBSONIC_CLIENT_VERSION&c=$SUBSONIC_CLIENT_NAME"
  )
}
