#!/bin/bash
source "$HOME/.config/scripts/settings.sh"

# device to read for cd ripping
DEVICE='/dev/sr0'

# path to beets collection directory
COLLECTION_DIR="$HOME/collection"

# download only audio files default yes
AUDIO_ONLY="-x"

# enable beet import
BEET_IMPORT="TRUE"

# path for temporary files download
NEW_ALBUM_PATH="/tmp/$(basename "$0" .sh)/$(uuidgen)"; if [[ ! -d "$NEW_ALBUM_PATH" ]]; then mkdir -p "$NEW_ALBUM_PATH"; fi

YT_DLP_PROGRESS_FILE="$NEW_ALBUM_PATH/yt_dlp_progress.txt"

declare -A FLAGS
FLAGS[a]='AUDIO_ONLY=""'
FLAGS[b]='BEET_IMPORT="FALSE"'
FLAGS[u]='URL=${OPTARG}'
FLAGS[p]='PROXY="--proxy ${OPTARG}"'
FLAGS[d]='DEVICE=${OPTARG}'
FLAGS[C]='COLLECTION_DIR=${OPTARG}'

declare -A FLAGS_DESCRIPTIONS
FLAGS_DESCRIPTIONS[a]='disable audio only downloads'
FLAGS_DESCRIPTIONS[u]='url of the playlist to download'
FLAGS_DESCRIPTIONS[b]='disable import with beets'
FLAGS_DESCRIPTIONS[p]='proxy server for tracks download es socks5://localhost:40034'
FLAGS_DESCRIPTIONS[d]="device to read when ripping cds, default $DEVICE"
FLAGS_DESCRIPTIONS[C]="Beets collection directory, default $COLLECTION_DIR"

FLAGS_STRING='bap:u:C:d:'

declare -A COMMANDS
COMMANDS[download]="download album from youtube playlist link and import inside beet collection"
COMMANDS[ripcd]="rip a cd and import inside beet collection"

function download() {

  # check on url parameter
  if [[ -z $URL ]]; then echo "URL variable not set, use -u option"; help; exit 1; fi
  if [[ -z $COLLECTION_DIR ]]; then echo "COLLECTION_DIR variable not set, use -C option"; help; exit 1; fi
  if [[ ! -e "$COLLECTION_DIR/library.db" ]];then  echo "beet database $COLLECTION_DIR/library.db does not exists, maybe collection folder is not mounted"; exit 1; fi

  YT_DLP_CMD="yt-dlp \
    --ignore-errors \
    --continue \
    --no-overwrites \
    --download-archive $YT_DLP_PROGRESS_FILE \
    $PROXY \
    $AUDIO_ONLY \
    -f bestaudio \
    -P $NEW_ALBUM_PATH \
    $URL"

  echo "$YT_DLP_CMD"

  $YT_DLP_CMD

  if [[ "$BEET_IMPORT" == 'TRUE' ]]; then
    echo "beet -d $COLLECTION_DIR -v import $NEW_ALBUM_PATH"
    beet -d $COLLECTION_DIR -v import "$NEW_ALBUM_PATH"
  fi
}

function ripcd(){
  if [[ -z $DEVICE ]]; then echo "DEVICE variable not set, use -d option"; help; exit 1; fi
  if [[ -z $COLLECTION_DIR ]]; then echo "COLLECTION_DIR variable not set, use -C option"; help; exit 1; fi
  if [[ ! -e "$COLLECTION_DIR/library.db" ]];then  echo "beet database $COLLECTION_DIR/library.db does not exists, maybe collection folder is not mounted"; exit 1; fi

  (
    cd "$NEW_ALBUM_PATH"
    echo "cdda2wav -vall cddb=-1 speed=4 -B -D $DEVICE"
    cdda2wav -vall cddb=-1 speed=4 -B -D "$DEVICE"
  )

  if [[ "$BEET_IMPORT" == 'TRUE' ]]; then
    echo "beet -d $COLLECTION_DIR -v import $NEW_ALBUM_PATH"
    beet -d $COLLECTION_DIR -v import "$NEW_ALBUM_PATH"
  fi
}

source "$SCRIPTS_LIB_FOLDER/cli.sh"
