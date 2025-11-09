#!/bin/bash
source "$HOME/.config/scripts/settings.sh"

# get tracks from playlist
QUERY_TRACKS_FROM_PLAYLIST="https://$SUBSONIC_API_ENDPOINT/getPlaylist?v=$SUBSONIC_CLIENT_VERSION&c=$SUBSONIC_CLIENT_NAME&f=json&id="
# get tracks from album
QUERY_TRACKS_FROM_ALBUM="https://$SUBSONIC_API_ENDPOINT/getAlbum?v=$SUBSONIC_CLIENT_VERSION&c=$SUBSONIC_CLIENT_NAME&f=json&id="
# get albums from artist
QUERY_ALBUM_FROM_ARTIST="https://$SUBSONIC_API_ENDPOINT/getArtist?v=$SUBSONIC_CLIENT_VERSION&c=$SUBSONIC_CLIENT_NAME&f=json&id="
# list artists
QUERY_LIST_ARTISTS="https://$SUBSONIC_API_ENDPOINT/getArtists?size=500&type=random&v=$SUBSONIC_CLIENT_VERSION&c=$SUBSONIC_CLIENT_NAME&f=json"
# list albums
QUERY_LIST_ALBUMS="https://$SUBSONIC_API_ENDPOINT/getAlbumList?size=500&type=random&v=$SUBSONIC_CLIENT_VERSION&c=$SUBSONIC_CLIENT_NAME&f=json"
# list playlists
QUERY_LIST_PLAYLISTS="https://$SUBSONIC_API_ENDPOINT/getPlaylists?&v=$SUBSONIC_CLIENT_VERSION&c=$SUBSONIC_CLIENT_NAME&f=json"
# list tracks
QUERY_LIST_TRACKS="https://$SUBSONIC_API_ENDPOINT/getRandomSongs?size=500&v=$SUBSONIC_CLIENT_VERSION&c=$SUBSONIC_CLIENT_NAME&f=json"

function get_tracks(){
    curl -L -u $SUBSONIC_USERNAME:$SUBSONIC_PASSWORD "$QUERY_LIST_TRACKS" | jq -r '."subsonic-response".randomSongs.song[] | "\( .id)|\(.title)"'
}

function get_artists(){
  curl -L -u $SUBSONIC_USERNAME:$SUBSONIC_PASSWORD "$QUERY_LIST_ARTISTS"  | jq -r '."subsonic-response".artists.index[].artist[] | "\( .id)|\(.name)"'
}

function get_albums(){
  curl -L -u $SUBSONIC_USERNAME:$SUBSONIC_PASSWORD "$QUERY_LIST_ALBUMS" | jq -r '."subsonic-response".albumList.album[] | "\( .id)|\(.title)"'
}

function get_playlists(){
  curl -L -u $SUBSONIC_USERNAME:$SUBSONIC_PASSWORD "$QUERY_LIST_PLAYLISTS"  | jq -r '."subsonic-response".playlists.playlist[] | "\( .id)|\(.name)"'
}

function get_tracks_from_album(){
  album="$1"
  curl -L -u $SUBSONIC_USERNAME:$SUBSONIC_PASSWORD "$QUERY_TRACKS_FROM_ALBUM$album" | jq -r '."subsonic-response".album.song[].id'
}

function get_albums_from_artist(){
  artist="$1"
  curl -L -u $SUBSONIC_USERNAME:$SUBSONIC_PASSWORD "$QUERY_ALBUM_FROM_ARTIST$artist" | jq -r '."subsonic-response".artist.album[].id'
}

function get_tracks_from_playlist(){
  playlist="$1"
  curl -L -u $SUBSONIC_USERNAME:$SUBSONIC_PASSWORD "$QUERY_TRACKS_FROM_PLAYLIST$playlist" | jq -r '."subsonic-response".playlist.entry[].id'
}

function get_tracks_from_artist(){
  artist="$1"
  get_albums_from_artist $artist | while read id; do
    get_tracks_from_album "$id"
  done
}
