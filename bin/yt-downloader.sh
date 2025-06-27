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
FLAGS_STRING='acf:u:d:l:D'

declare -A COMMANDS
COMMANDS[dwl]="download content"
COMMANDS[nv_album]="download multiple contents"
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

  if [[ -z $LINKS_FILE ]]; then help; exit 1; fi
  cat "$LINKS_FILE" | while read link; do
    echo "downloading $link"
    ($0 dwl -a -d $NV_ALBUM_DIR -u "$link")
  done
}

source "$SCRIPTS_LIB_FOLDER/cli.sh"
