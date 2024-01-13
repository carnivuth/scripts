#!/bin/bash

# help
if [[ "$1" == "--help" ]]; then
    echo "small script to convert file formats in batch with ffmpeg"
    echo "parameters: src-folder dest-folder format"
    exit 0
fi
# exit if wrong parameters
if [[ "$#" -ne 3 ]]; then
    echo "wrong parameters, parameters are:"
    echo "src-folder dest-folder format"
    exit 1
fi

SRC_FOLDER="$1"
DEST_FOLDER="$2"
FORMAT="$3"


if [[ ! -d "$SRC_FOLDER" ]]; then
    echo "first parameter must be a folder"
    exit 1
fi

# create folder if dosent exist
if [[ ! -d "$DEST_FOLDER" ]]; then
    mkdir -p "$DEST_FOLDER"
fi

for FILE in $SRC_FOLDER/*; do

    # get name file
    NAME="$(echo $FILE | rev | cut -d"/" -f1 |cut -d"." -f2| rev | awk  '{$1=$1};1')"

    # print
    echo "CONVERTING $NAME TO $FORMAT"
    # encode with ffmpeg
    ffmpeg -v quiet -y -stats -i "$FILE" "$DEST_FOLDER/$NAME.$FORMAT" &
done
