#!/bin/bash
if [[ "$#" -ne 2 ]]; then echo "not enough arguments"; exit 1;fi

for file in $1/*; do
    filename="$(echo $file| rev | cut -d'/' -f1 |rev)"
    ffmpeg -i "$file" "$2/""$(echo $filename | rev | cut -d'.' -f2| rev)".mp4
done
