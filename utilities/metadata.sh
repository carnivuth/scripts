#!/bin/bash
# exit if wrong parameters
if [[ "$#" -ne 2 ]]; then
    echo "wrong parameters"
    exit 1
fi

# print parameter list
if [[ "$1" == "--help" ]]; then
    echo "parameters: src-folder dest-folder"
    exit 0
fi

SRC_FOLDER="$1"
DEST_FOLDER="$2"

for FILES in "$SRC_FOLDER"/*.opus; do

    # get name file
    NAME="$(echo $FILES | rev | cut -d"/" -f1 | rev)"

    # get metadata values from names
    #ARTIST="$(echo $NAME|cut -d"-" -f1|cut -d"]" -f2|sed -re 's/^[[:blank:]]+|[[:blank:]]+$//g' -e 's/[[:blank:]]+/ /g')"
    ALBUM="$(echo $NAME | cut -d"-" -f1 | sed -re 's/^[[:blank:]]+|[[:blank:]]+$//g' -e 's/[[:blank:]]+/ /g')"
    TITLE="$(echo $NAME | cut -d"-" -f2 | cut -d '[' -f1 | sed -re 's/^[[:blank:]]+|[[:blank:]]+$//g' -e 's/[[:blank:]]+/ /g')"

    # print logs
    #echo "$TITLE" "separatore" "$NAME" >> "$SRC_FOLDER"/logs
    #echo  "$NAME" "separatore" "$TITLE" "separatore" "$NAME"

    # ffmpeg decoding
    ffmpeg -y -i "$FILES" -acodec copy -metadata album="$ALBUM" -metadata artist="$ARTIST" "$DEST_FOLDER"/"$TITLE".opus 2>>/dev/null >>/dev/null

done
