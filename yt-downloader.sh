#!/bin/bash
if [[ "$1" == "--help" ]]; then
    echo 'parameters dest-folder URL'
fi
yt-dlp --ignore-errors --continue --no-overwrites --download-archive progress.txt -x -P "$HOME/Musica/$1" -f bestaudio  "$2"
