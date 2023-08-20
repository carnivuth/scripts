#!/bin/bash
if [[ "$1" == "--help" ]]; then
    echo 'parameters FILE START FINISH'
    exit 0
fi
if [[ "$#" -ne 3 ]]; then
    echo "wrong parameters"
    echo 'parameters FILE START FINISH'
    exit 1
fi
FILENAME="$(echo $1 | rev | cut -d"/" -f1 |cut -d"." -f2-| rev)"
EXTENSION="$(echo $1 | rev | cut -d"." -f1 | rev)"
ffmpeg -i "$1"  -ss "$2" -to "$3" -c:v copy -c:a copy "$FILENAME-cutted.$EXTENSION"