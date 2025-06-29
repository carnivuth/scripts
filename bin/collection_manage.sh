#!/bin/bash
source "$HOME/.config/scripts/settings.sh"

declare -A FLAGS
FLAGS[a]='AUDIO_ONLY="-x -f bestaudio"'
FLAGS[c]='SUBS=--embed-subs'
FLAGS[u]='URL=${OPTARG}'
FLAGS[f]='FORMAT="-f "${OPTARG}'
FLAGS[d]='DEST_FOLDER=${OPTARG}'
FLAGS[l]='LINKS_FILE=${OPTARG}'
FLAGS[D]='DEBUG=1'
FLAGS[C]='COLLECTION_DIR=${OPTARG}'
FLAGS_STRING='acf:u:d:l:C:D'

declare -A COMMANDS
COMMANDS[dwl]="download content"
COMMANDS[nv_album]="download audio files from youtube links"
COMMANDS[all_lyrics]="download lyrics from lrclib.net"
COMMANDS[ripcd]="download lyrics from lrclib.net"

# constants
COLLECTION_DIR="$HOME/collection"
BASEURL="https://lrclib.net/api/get?"
LOG_DIR="$SCRIPTS_LOGS_FOLDER/$(basename $0 .sh)"; if test ! -d $LOG_DIR;then mkdir "$LOG_DIR";fi
NOW="$(date +%s)"
YT_DLP_PROGRESS_FILE='/tmp/progress.txt'
NV_ALBUM_DIR="/tmp/nv_album"

function dwl() {
  if [[ -z $DEST_FOLDER ]] || [[ -z $URL ]]; then help; exit 1; fi
  # setting yt-dlp command
  YT_DLP_CMD="yt-dlp \
    --ignore-errors \
    --continue \
    --no-overwrites \
    --download-archive $YT_DLP_PROGRESS_FILE \
    ${AUDIO_ONLY} \
    ${SUBS} \
    ${FORMAT} \
    -P $DEST_FOLDER \
    $URL"

  # printing command for debugging purposes
  if [[ "$DEBUG" == "1" ]]; then echo "running $YT_DLP_CMD"; fi

  # run command
  $YT_DLP_CMD

  # remove progress file
  rm -f "$YT_DLP_PROGRESS_FILE"
}

function nv_album(){

  if [[ -n $LINKS_FILE ]]; then
  cat "$LINKS_FILE" | while read link; do
    echo "downloading $link"
    ($0 dwl -a -d $NV_ALBUM_DIR -u "$link")
  done
  elif [[ -n $URL ]]; then
    ($0 dwl -a -d $NV_ALBUM_DIR -u "$URL")
  fi

}

function all_lyrics(){
  # loop all music files in collection
  find "$COLLECTION_DIR" -regextype posix-egrep -regex ".*\.(m4a|opus|wav)$" | while read file; do
    lyrics "$file"
  done
}

function lyrics(){
  # test if a lyrics file is already downloaded
  if test ! -f "${file%.*}.lrc" && test ! -f "${file%.*}.txt"; then

    echo "processing: $file" | tee -a "$LOG_DIR/log-$NOW"

    # reading metadata from file
    metadata="$(ffprobe -show_entries 'stream_tags : format_tags' "$file" 2>/dev/null)"
    album="$(echo "$metadata" | grep -i 'TAG:album=' | awk -F'=' '{$1="";print $0}' | awk '{$1=$1;print}')";
    title="$(echo "$metadata" | grep -i 'TAG:title=' | awk -F'=' '{$1="";print $0}' | awk '{$1=$1;print}')";
    artist="$(echo "$metadata" | grep -i 'TAG:artist=' | awk -F'=' '{$1="";print $0}' | awk '{$1=$1;print}')";

    # encoding url with parameter
    url_encoded="${BASEURL}artist_name=$(printf "$artist" | jq --slurp --raw-input --raw-output @uri )&track_name=$(printf "$title" | jq --slurp --raw-input --raw-output @uri )&album_name=$(printf "$album" | jq --slurp --raw-input --raw-output @uri)"

    echo "librc url: $url_encoded" | tee -a "$LOG_DIR/log-$NOW"

    # retrieve plain and synced lyrics from lrclib.net
    api_response="$(curl "$url_encoded")"
    echo "api response: $api_response" | tee -a "$LOG_DIR/log-$NOW"

    synced_lyrics=$(echo "$api_response" | jq '.syncedLyrics' -r)
    plain_lyrics=$(echo "$api_response" | jq '.plainLyrics' -r)

    # check if synced lyrics exists and print to file, use plain lyrics as fallback
    if [[ "$synced_lyrics" != 'null' ]];then
      echo "writing synced lyrics in ${file%.*}.lrc" | tee -a "$LOG_DIR/log-$NOW"
      echo "$synced_lyrics"  > "${file%.*}.lrc"
    elif [[ "$plain_lyrics" != 'null' ]];then
      echo "writing plain lyrics in ${file%.*}.txt" | tee -a "$LOG_DIR/log-$NOW"
      echo "$plain_lyrics"  > "${file%.*}.txt"
    fi

  fi
}

function ripcd(){
  mkdir -p "$NV_ALBUM_DIR"
  (
    cd "$NV_ALBUM_DIR"
    cdda2wav -vall cddb=-1 speed=4 -B -D /dev/sr0
  )
}

source "$SCRIPTS_LIB_FOLDER/cli.sh"
