#!/bin/bash

#import files
source "$HOME/.config/settings.sh"

# print help
if [[ "$1" == "--help" ]]; then
    echo "small script to convert video to gif with ffmpeg"
    echo "parameters: src-file "
    exit 0
fi

# exit if wrong parameters
if [[ "$#" -ne 1 ]]; then
    echo "wrong parameters, parameters are:"
    echo "src-file"
    exit 1
fi

SRC_FILE="$1"
OUT_FILE="$(basename "$SRC_FILE" | cut -d"." -f1|  awk  '{$1=$1};1')"


if [[ ! -f "$SRC_FILE" ]]; then
    echo "first parameter must be a file"
    exit 1
fi

# run ffmpeg
ffmpeg -i "$1" -v quiet -y -stats -vf "fps=10,scale=640:-1:flags=lanczos,split[s0][s1];[s0]palettegen[p];[s1][p]paletteuse" -loop 0 "$OUT_FILE-$(date '+%s')".gif
