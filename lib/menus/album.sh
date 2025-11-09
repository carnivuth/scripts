#!/usr/bin/bash
source "$HOME/.config/scripts/settings.sh"
source "$SCRIPTS_LIB_FOLDER/control_mpv.sh"

list_album(){
  curl -L -u $SUBSONIC_USERNAME:$SUBSONIC_PASSWORD "https://$SUBSONIC_API_ENDPOINT/getAlbumList?size=500&type=random&v=$SUBSONIC_CLIENT_VERSION&c=$SUBSONIC_CLIENT_NAME&f=json" | jq -r '."subsonic-response".albumList.album[] | "\( .id)|\(.title)"' |  sed 's/^/album:/g'
}

run_album(){
  first="TRUE"
  echo "$1" | awk -F'|' '{print $1, $2}' | (
    read id title
    # get tracks in album
    curl -L -u $SUBSONIC_USERNAME:$SUBSONIC_PASSWORD "https://$SUBSONIC_API_ENDPOINT/getMusicDirectory?id=$id&v=$SUBSONIC_CLIENT_VERSION&c=$SUBSONIC_CLIENT_NAME&f=json" | jq -r '."subsonic-response".directory.child[].id' | while read track_id;do
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
