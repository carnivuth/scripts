#!/bin/bash
if [[ "$1" == "--help" ]]; then
    echo 'parameters dest-folder URL'
    exit 0
fi
if [[ "$#" -ne 2 ]]; then
    echo "wrong parameters"
    exit 1
fi
yt-dlp --ignore-errors --continue --no-overwrites --download-archive progress.txt -x -P "$1" -f bestaudio "$2"
rm progress.txt
