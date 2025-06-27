#!/bin/bash
source "$HOME/.config/scripts/settings.sh"

COLLECTION_DIR="$HOME/collection"
BASEURL="https://lrclib.net/api/get?"
LOG_DIR="$SCRIPTS_LOGS_FOLDER/$(basename $0 .sh)"; if test ! -d $LOG_DIR;then mkdir "$LOG_DIR";fi
NOW="$(date +%s)"

# loop all music files in collection
find "$COLLECTION_DIR" -regextype posix-egrep -regex ".*\.(m4a|opus|wav)$" | while read file; do

  # test if a lyrics file is already downloaded
  if test ! -f "${file%.*}.lrc" && test ! -f "${file%.*}.txt"; then

    echo "processing: $file" | tee -a "$LOG_DIR/processed-file-$NOW"

    # reading metadata from file
    metadata="$(ffmpeg -i "$file" -f ffmetadata 2>&1)"
    album="$(echo "$metadata" | grep 'ALBUM ' | awk -F':' '{$1="";print $0}' | awk '{$1=$1;print}')";
    title="$(echo "$metadata" | grep 'TITLE ' | awk -F':' '{$1="";print $0}' | awk '{$1=$1;print}')";
    artist="$(echo "$metadata" | grep 'ARTIST ' | awk -F':' '{$1="";print $0}' | awk '{$1=$1;print}')";
    duration="$(echo "$metadata" | grep 'Duration ' | awk -F' ' '{print $2}' | awk -F ',' '{print $1}')";

    # encoding url with parameter
    url_encoded="${BASEURL}artist_name=$(printf "$artist" | jq --slurp --raw-input --raw-output @uri )&track_name=$(printf "$title" | jq --slurp --raw-input --raw-output @uri )&album_name=$(printf "$album" | jq --slurp --raw-input --raw-output @uri)"

    echo "librc url: $url_encoded" | tee -a "$LOG_DIR/urls-$NOW"

    # retrieve lyrics and print to file inside collection
    curl "$url_encoded" | jq '.syncedLyrics' -r > "${file%.*}.lrc"
  fi
done
