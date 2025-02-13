#!/bin/bash
source "$HOME/.config/scripts/settings.sh"

declare -A FLAGS
FLAGS[t]='TITLE_PROGRAM=${OPTARG}'
FLAGS[a]='ARTIST_PROGRAM=${OPTARG}'
FLAGS[l]='ALBUM_PROGRAM=${OPTARG}'
FLAGS[f]='FILE_FORMAT=${OPTARG}'
FLAGS[s]='SRC_FOLDER=${OPTARG}'
FLAGS[d]='DEST_FOLDER=${OPTARG}'
FLAGS_STRING='t:a:l:f:s:d:'

declare -A COMMANDS
COMMANDS[apply]="apply metadata given the parameters"
function apply(){

  # check for folder parameters and exit if absent
  if [[ -z $SRC_FOLDER ]] || [[ -z $DEST_FOLDER ]]; then help; exit 1; fi

  # check the src folder existance
  if [[ ! -d "$SRC_FOLDER" ]]; then echo "first parameter must be a folder"; exit 1; fi

  # create folder if dosent exist
  if [[ ! -d "$DEST_FOLDER" ]]; then mkdir "$DEST_FOLDER"; fi

  # set default file format to opus if no format is provided
  if [[ -z $FILE_FORMAT  ]]; then FILE_FORMAT='opus'; fi

  # main loop
  for file in "$SRC_FOLDER"/*.$FILE_FORMAT; do

      # get name file
      name= ${file%.*}

      # get metadata values from names
      if [[ "$ARTIST_PROGRAM" != '' ]]; then
        ARTIST="$(echo $name | awk -f "$ARTIST_PROGRAM")"

      fi
      if [[ "$ALBUM_PROGRAM" != '' ]]; then
        ALBUM="$(echo $name | awk -f "$ALBUM_PROGRAM")"
      fi
      if [[ "$TITLE_PROGRAM" != '' ]]; then
        TITLE="$(echo $name | awk -f "$TITLE_PROGRAM" )"
      fi

      echo -e " processing $name file with\n TITLE:$TITLE\n ALBUM:$ALBUM\n ARTIST:$ARTIST"

      # ffmpeg decoding
      ffmpeg -y -v quiet -stats -i "$file" -acodec copy \
        -metadata album="$ALBUM" \
        -metadata title="$TITLE" \
        -map 0:0 -metadata:s:a:0 title="$TITLE" \
        -metadata Title="$TITLE" \
        -metadata artist="$ARTIST" \
        "$DEST_FOLDER"/"$TITLE.$FILE_FORMAT"

      done
  }

source "$SCRIPTS_LIB_FOLDER/cli.sh"
