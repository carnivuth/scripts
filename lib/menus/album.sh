#!/usr/bin/bash
source "$HOME/.config/scripts/settings.sh"

list_album(){
  curl -L -u $SUBSONIC_USERNAME:$SUBSONIC_PASSWORD "https://$SUBSONIC_API_ENDPOINT/getAlbumList?type=random&v=$SUBSONIC_CLIENT_VERSION&c=$SUBSONIC_CLIENT_NAME&f=json" | jq -r '."subsonic-response".albumList.album[] | "\( .id)|\(.title)"' |  sed 's/^/album:/g'
}

run_album(){
  echo "$1" | awk -F'|' '{print $1, $2}' | (
    read id title
    killall mpv
    # get tracks in album
    curl -L -u $SUBSONIC_USERNAME:$SUBSONIC_PASSWORD "https://$SUBSONIC_API_ENDPOINT/getMusicDirectory?id=$id&v=$SUBSONIC_CLIENT_VERSION&c=$SUBSONIC_CLIENT_NAME&f=json" | jq -r '."subsonic-response".directory.child[].id' | while read track_id;do
    # play tracks
      mpv --vid=no "https://$SUBSONIC_USERNAME:$SUBSONIC_PASSWORD@$SUBSONIC_API_ENDPOINT/stream?id=$track_id&v=$SUBSONIC_CLIENT_VERSION&c=$SUBSONIC_CLIENT_NAME"
    done
  )
}
