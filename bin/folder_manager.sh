#!/bin/bash
source "$HOME/.config/scripts/settings.sh"
source "$SCRIPTS_LIB_FOLDER/notify.sh"

declare -A FLAGS
FLAGS[d]='DIRECTORY=${OPTARG}'
FLAGS_STRING='d:'

declare -A COMMANDS
COMMANDS[run]="run a cleanup operation"
COMMANDS[watch]="watch a folder for changes and run cleanup operations"

APP_NAME="Folder manager"
APP_ICON="/usr/share/icons/Papirus/16x16/apps/document-viewer.svg"

declare -A DIRS
DIRS[png]="images"
DIRS[jpg]="images"
DIRS[tar]="compressed"
DIRS[gz]="compressed"
DIRS[zst]="compressed"
DIRS[zip]="compressed"
DIRS[7z]="compressed"
DIRS[pdf]="documents"
DIRS[docx]="documents"
DIRS[txt]="documents"
DIRS[mp3]="audio"
DIRS[opus]="audio"
DIRS[wav]="audio"
DIRS[torrent]="torrents"

function run(){

  if [[ -z $DIRECTORY ]]; then echo "set DIRECTORY with -d option";exit 1; fi
  if [[ ! -d "$DIRECTORY" ]]; then echo "$DIRECTORY is not a DIRECTORY";exit 1; fi

  for file in $DIRECTORY/* ; do
    if [[ -f "$file" ]]; then

      filename="$(basename "$file")"
      extension="${filename##*.}"
      dest_dir=${DIRS[$extension]}

      if [[ -n $dest_dir ]]; then
        mkdir -p "$DIRECTORY/$dest_dir"
        echo "moving $file in $DIRECTORY/$dest_dir"
        mv "$file" "$DIRECTORY/$dest_dir" && notify "normal" "moved $file to $dest_dir"
      fi
    fi
  done
}

function watch(){

  if [[ -z $DIRECTORY ]]; then echo "set DIRECTORY with -d option";exit 1; fi
  if [[ ! -d "$DIRECTORY" ]]; then echo "$DIRECTORY is not a DIRECTORY";exit 1; fi

  echo "started watching for changes in $DIRECTORY"
  notify "normal" "started watching for changes in $DIRECTORY"
  inotifywait --format '%w %f' -e close_write -m "$DIRECTORY" | while read directory filename; do

    echo "$filename detected change in $DIRECTORY"
    notify "low" "$filename detected change in $DIRECTORY"
    run
  done
}

source "$SCRIPTS_LIB_FOLDER/cli.sh"
