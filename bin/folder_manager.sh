#!/bin/bash
source "$HOME/.config/scripts/settings.sh"
source "$SCRIPTS_LIB_FOLDER/notify.sh"

declare -A FLAGS
FLAGS[d]='DIRECTORY=${OPTARG}'
declare -A FLAGS_DESCRIPTIONS
FLAGS_DESCRIPTIONS[d]='directory to manage'
FLAGS_STRING='d:'

declare -A COMMANDS
COMMANDS[run_all]="run a cleanup operation on a given dir"
COMMANDS[watch]="watch a folder for changes and run cleanup operations"

APP_NAME="Folder manager"
APP_ICON="/usr/share/icons/Papirus/16x16/apps/document-viewer.svg"
# files to avoid touch
UNMANAGED_FILES="part"

function run_all(){

  if [[ -z $DIRECTORY ]]; then echo "set DIRECTORY with -d option";exit 1; fi
  if [[ ! -d "$DIRECTORY" ]]; then echo "$DIRECTORY is not a DIRECTORY";exit 1; fi

  find "$DIRECTORY" -type f | while read file; do
  run "$file"
done
# delete empty folders after cicling all files
find "$DIRECTORY" -type d -empty -delete
}

function run(){

  file="$1"
  if [[ -f "$file" ]]; then
    echo "processing $file"

    filename="$(basename "$file")"
    extension="${filename##*.}"
    dest_dir=$(gio info "$file"  | grep  'standard::content-type'  | awk '{print $2}')

    if [[ -n $dest_dir ]] && ! grep -q "$extension" "$UNMANAGED_FILES"; then
      mkdir -p "$DIRECTORY/$dest_dir"
      echo "moving $file in $DIRECTORY/$dest_dir"
      mv "$file" "$DIRECTORY/$dest_dir" && notify "normal" "moved $file to $dest_dir"
    fi
  fi

}

function watch(){

  if [[ -z $DIRECTORY ]]; then echo "set DIRECTORY with -d option";exit 1; fi
  if [[ ! -d "$DIRECTORY" ]]; then echo "$DIRECTORY is not a DIRECTORY";exit 1; fi

  run_all
  echo "started watching for changes in $DIRECTORY"
  notify "normal" "started watching for changes in $DIRECTORY"
  inotifywait --format '%w %f' -e close_write -m "$DIRECTORY" | while read directory filename; do

  echo "$filename detected change in $DIRECTORY"
  notify "low" "$filename detected change in $DIRECTORY"
  run "$filename"

done
}

source "$SCRIPTS_LIB_FOLDER/cli.sh"
