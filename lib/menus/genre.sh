
#!/usr/bin/bash
source "$HOME/.config/scripts/settings.sh"
source "$SCRIPTS_LIB_FOLDER/control_mpv.sh"
source "$SCRIPTS_LIB_FOLDER/subsonic_client.sh"

list_genre(){
  get_genres |  sed 's/^/genre:/g'
}

run_genre(){
  first="TRUE"
  echo "$1" |  (
    read name
    get_tracks_from_genre "$name" | while read track_id; do

    # play tracks
    if [[ $first == "TRUE" ]]; then
      replace_track_on_mpv "https://$SUBSONIC_USERNAME:$SUBSONIC_PASSWORD@$SUBSONIC_API_ENDPOINT/stream?id=$track_id&v=$SUBSONIC_CLIENT_VERSION&c=$SUBSONIC_CLIENT_NAME"
      first=FALSE
    else
      append_track_on_mpv "https://$SUBSONIC_USERNAME:$SUBSONIC_PASSWORD@$SUBSONIC_API_ENDPOINT/stream?id=$track_id&v=$SUBSONIC_CLIENT_VERSION&c=$SUBSONIC_CLIENT_NAME"
    fi
    done
  )
}
