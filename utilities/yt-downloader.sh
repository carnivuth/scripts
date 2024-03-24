#!/bin/bash

# help message 
help_message(){
    echo 'script for downloading playlist from youtube'
    echo 'usage:'
    echo "$0" "dest-folder" "URL" "[-as]"
    echo "parameters:"
    echo "-a audio only, if set the script will download only the audio content of a file"
    echo "-s embed subtitles"
    echo "-f file format to download"
    exit 0
}

if [[ "$1" == "--help" ]]; then
  help_message 
fi

# check for number of parameters
if [[ "$#" -lt 2 ]]; then
  echo "wrong parameters"
  help_message 
  exit 1
fi

# setting variables
DEST_FOLDER="$1"
URL="$2"

shift
shift

# get option parameters
while getopts asf: flag; do
    case "${flag}" in
    a) AUDIO_ONLY="-x -f bestaudio" ;;
    f) FORMAT="-f " ${OPTARG} ;;
    s) SUBS="--embed-subs" ;;
    esac
done

# setting yt-dlp command
YT_DLP_CMD="yt-dlp \
    --ignore-errors \
    --continue \
    --no-overwrites \
    --download-archive progress.txt \
    ${AUDIO_ONLY} \
    ${SUBS} \
    ${FORMAT} \
    -P $DEST_FOLDER \
    $URL"

# printing command for debugging purposes
echo "running $YT_DLP_CMD"

# run command
$YT_DLP_CMD

# remove progress file
rm progress.txt
