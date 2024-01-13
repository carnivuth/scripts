#!/bin/bash
#import files
source "$HOME/scripts/settings.sh"

# hep
if [[ "$1" == "--help" ]]; then
    echo "small script to edit metadata of audio files with awk and ffmpeg"
    echo "parameters: src-folder dest-folder"
    echo "flags: "
    echo "-t:   awk program file to get title from filename, format -t ''awk program'' "
    echo "-a:   awk program file to get artist from filename -a ''awk program''"
    echo "-l:   awk program file to get album from filename -l ''awk program''"
    echo "-f:   format of audio files"
    echo "some awk program examples:"
    echo "get song title from a 'artist-title' filename and trim withespaces: " 
    echo '  BEGIN{FS="-"}{gsub(/^[ \t]+|[ \t]+$/, "");print $2}' 
    exit 0
fi
# exit if wrong parameters
if [[ "$#" -lt 2 ]]; then
    echo "wrong parameters, parameters are:"
    echo "src-folder dest-folder [t:a:l:f]"
    exit 1
fi

SRC_FOLDER="$1"
DEST_FOLDER="$2"

shift
shift

# get parameters
while getopts t:a:l:f: flag; do
    case "${flag}" in
    t) TITLE_PROGRAM=${OPTARG} ;;
    a) ARTIST_PROGRAM=${OPTARG} ;;
    l) ALBUM_PROGRAM=${OPTARG} ;;
    f) FILE_FORMAT=${OPTARG} ;;
    esac
done

# log metadata programs
echo "TITLE_PROGRAM: $TITLE_PROGRAM" >>"$SCRIPTS_LOGS_FOLDER/metadata.logs"
echo "ARTIST_PROGRAM: $ARTIST_PROGRAM" >>"$SCRIPTS_LOGS_FOLDER/metadata.logs"
echo "ALBUM_PROGRAM: $ALBUM_PROGRAM" >>"$SCRIPTS_LOGS_FOLDER/metadata.logs"
echo "FILE_FORMAT: $FILE_FORMAT" >>"$SCRIPTS_LOGS_FOLDER/metadata.logs"

if [[ ! -d "$SRC_FOLDER" ]]; then
    echo "first parameter must be a folder"
    exit 1
fi

# create folder if dosent exist
if [[ ! -d "$DEST_FOLDER" ]]; then
    mkdir "$DEST_FOLDER"
fi

if [[ "$FILE_FORMAT" == '' ]]; then
    FILE_FORMAT='opus'
fi

for FILE in "$SRC_FOLDER"/*.$FILE_FORMAT; do

    # get name file
    NAME="$(echo $FILE | rev | cut -d"/" -f1 |cut -d"." -f2| rev | awk  '{$1=$1};1')"

    # get metadata values from names
    if [[ "$ARTIST_PROGRAM" != '' ]]; then
        ARTIST="$(echo $NAME | awk -E "$ARTIST_PROGRAM"| awk  '{$1=$1};1')"

    fi
    if [[ "$ALBUM_PROGRAM" != '' ]]; then
        ALBUM="$(echo $NAME | awk -E "$ALBUM_PROGRAM"| awk  '{$1=$1};1')"
    fi
    if [[ "$TITLE_PROGRAM" != '' ]]; then
        TITLE="$(echo $NAME | awk -E "$TITLE_PROGRAM" | awk  '{$1=$1};1')"
    fi
    # log metadata
    echo -e " processing $NAME file with\n TITLE:$TITLE\n ALBUM:$ALBUM\n ARTIST:$ARTIST" 

    # ffmpeg decoding
    ffmpeg -y -v quiet -stats -i "$FILE" -acodec copy \
        -metadata album="$ALBUM" \
        -metadata title="$TITLE" \
        -map 0:0 -metadata:s:a:0 title="$TITLE" \
        -metadata Title="$TITLE" \
        -metadata artist="$ARTIST" \
       "$DEST_FOLDER"/"$TITLE.$FILE_FORMAT" 

done

