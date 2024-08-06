#!/bin/bash
if [[ "$1" == "--help" ]]; then echo 'parameters FILE START DURATION'; exit 0; fi
if [[ "$#" -ne 3 ]]; then echo 'parameters FILE START DURATION'; exit 1; fi
if [[ ! -f "$1" ]]; then echo "$1 must be a filename"; exit 1; fi

filename="$(basename "$1" )"
ext="${filename##*.}"
ffmpeg -i "$1"  -ss "$2" -to "$3" -c:v copy -c:a copy "$filename-cutted.$ext"
