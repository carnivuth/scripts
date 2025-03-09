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
APP_ICON="/usr/share/icons/Papirus/32x32/apps/document-viewer.svg"

function run(){

  if [[ -z $DIRECTORY ]]; then echo "set DIRECTORY with -d option";exit 1; fi
  if [[ ! -d "$DIRECTORY" ]]; then echo "$DIRECTORY is not a DIRECTORY";exit 1; fi

  declare -A DIRS
  DIRS[png]="images"
  DIRS[jpg]="images"
  DIRS[tar]="compressed"
  DIRS[gz]="compressed"
  DIRS[zip]="compressed"
  DIRS[pdf]="documents"
  DIRS[docx]="documents"
  DIRS[txt]="documents"

  for file in $DIRECTORY/* ; do
    if [[ -f "$file" ]]; then

      filename="$(basename "$file")"
      extension="${filename##*.}"
      dest_dir=${DIRS[$extension]}

      if [[ -n $dest_dir ]]; then
        mkdir -p "$DIRECTORY/$dest_dir"
        echo "moving $file in $DIRECTORY/$dest_dir"
        mv "$file" "$DIRECTORY/$dest_dir"
      fi
    fi
  done
}

function watch(){

  if [[ -z $DIRECTORY ]]; then echo "set DIRECTORY with -d option";exit 1; fi
  if [[ ! -d "$DIRECTORY" ]]; then echo "$DIRECTORY is not a DIRECTORY";exit 1; fi

  echo "started watching for changes in $DIRECTORY"
  inotifywait -e create -m "$DIRECTORY" | while read directory filename; do
    if run; then
      notify -u "normal"  "reorganized $DIRECTORY"
    fi
  done
}

source "$SCRIPTS_LIB_FOLDER/cli.sh"
