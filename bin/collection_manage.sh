#!/bin/bash
source "$HOME/.config/scripts/settings.sh"

declare -A FLAGS
FLAGS[a]='AUDIO_ONLY=""'
FLAGS[u]='URL=${OPTARG}'
FLAGS[d]='DEVICE=${OPTARG}'
FLAGS_STRING='au:d:'

declare -A COMMANDS
COMMANDS[download]="download album from youtube playlist link and import inside beet collection"
COMMANDS[ripcd]="rip a cd and import inside beet collection"

# download only audio files default yes
AUDIO_ONLY="-x"

# path for temporary files download
NEW_ALBUM_PATH="/tmp/$(basename "$0" .sh)/$(uuidgen)"; if [[ ! -d "$NEW_ALBUM_PATH" ]]; then mkdir -p "$NEW_ALBUM_PATH"; fi
echo "$NEW_ALBUM_PATH"

YT_DLP_PROGRESS_FILE="$NEW_ALBUM_PATH/yt_dlp_progress.txt"

# device to read for cd ripping
DEVICE='/dev/sr0'

function download() {

  # check on url parameter
  if [[ -z $URL ]]; then echo "URL variable not set, use -u option"; help; exit 1; fi

  YT_DLP_CMD="yt-dlp \
    --ignore-errors \
    --continue \
    --no-overwrites \
    --download-archive $YT_DLP_PROGRESS_FILE \
    $AUDIO_ONLY \
    -f bestaudio \
    -P $NEW_ALBUM_PATH \
    $URL"

  echo "$YT_DLP_CMD"

  $YT_DLP_CMD

  echo "beet -v import $NEW_ALBUM_PATH"
  beet -v import "$NEW_ALBUM_PATH"
}

function ripcd(){
  if [[ -z $DEVICE ]]; then echo "DEVICE variable not set, use -d option"; help; exit 1; fi
  (
    cd "$NEW_ALBUM_PATH"
    echo "cdda2wav -vall cddb=-1 speed=4 -B -D $DEVICE"
    cdda2wav -vall cddb=-1 speed=4 -B -D "$DEVICE"
  )

  echo "beet -v import $NEW_ALBUM_PATH"
  beet -v import "$NEW_ALBUM_PATH"
}

source "$SCRIPTS_LIB_FOLDER/cli.sh"
