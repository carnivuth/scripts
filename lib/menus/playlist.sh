#!/usr/bin/bash
source "$HOME/.config/scripts/settings.sh"
source "$SCRIPTS_LIB_FOLDER/control_mpv.sh"

list_playlist(){
  curl -L -u $SUBSONIC_USERNAME:$SUBSONIC_PASSWORD "https://$SUBSONIC_API_ENDPOINT/getPlaylists?&v=$SUBSONIC_CLIENT_VERSION&c=$SUBSONIC_CLIENT_NAME&f=json"  | jq -r '."subsonic-response".playlists.playlist[] | "\( .id)|\(.name)"' |  sed 's/^/playlist:/g'
}

run_playlist(){
  echo "$1" | awk -F'|' '{print $1, $2}' | (
    read id name
    # get tracks in album
    curl -L -u $SUBSONIC_USERNAME:$SUBSONIC_PASSWORD \
      "https://$SUBSONIC_API_ENDPOINT/getPlaylist?id=$id&v=$SUBSONIC_CLIENT_VERSION&c=$SUBSONIC_CLIENT_NAME&f=json" | jq -r '."subsonic-response".playlist.entry[].id' | while read track_id;do
    # play tracks
    append_track_on_mpv "https://$SUBSONIC_USERNAME:$SUBSONIC_PASSWORD@$SUBSONIC_API_ENDPOINT/stream?id=$track_id&v=$SUBSONIC_CLIENT_VERSION&c=$SUBSONIC_CLIENT_NAME"
    done
  )
}
