#!/bin/bash
if [[ "$1" == "--help" ]]; then
    echo 'script for downloading playlist from youtube'
    echo 'usage:'
    echo "$0" "dest-folder" "URL" "[-a]"
    echo "parameters:"
    echo "-a audio only, if set the script will download only the audio content of a file"
    exit 0
fi

# check for number of parameters
if [[ "$#" -lt 2 ]]; then
    echo "wrong parameters"
    exit 1
fi

# setting variables
DEST_FOLDER="$1"
URL="$2"

shift
shift

# get option parameters
while getopts a: flag; do
    case "${flag}" in
    a) AUDIO_ONLY="-x -f bestaudio" ;;
    esac
done

# setting pyt-dlp command
YT_DLP_CMD="yt-dlp \
    --ignore-errors \
    --continue \
    --no-overwrites \
    --download-archive progress.txt \
    ${AUDIO_ONLY} \
    -P $DEST_FOLDER \
    $URL"

# printing command for debugging purposes
echo "running $YT_DLP_CMD"

# run command
$YT_DLP_CMD

# remove progress file
rm progress.txt
