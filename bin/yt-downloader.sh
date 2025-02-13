#!/bin/bash
source "$HOME/.config/scripts/settings.sh"

declare -A FLAGS
FLAGS[a]='AUDIO_ONLY="-x -f bestaudio"'
FLAGS[c]='SUBS=--embed-subs'
FLAGS[u]='URL=${OPTARG}'
FLAGS[f]='FORMAT="-f "${OPTARG}'
FLAGS[d]='DEST_FOLDER=${OPTARG}'
FLAGS[D]='DEBUG=1'
FLAGS_STRING='acf:u:d:D'

declare -A COMMANDS
COMMANDS[dwl]="download content"
YT_DLP_PROGRESS_FILE='/tmp/progress.txt'

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
source "$SCRIPTS_LIB_FOLDER/cli.sh"
