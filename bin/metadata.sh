#!/bin/bash
#import files
source "$HOME/.config/scripts/settings.sh"

# help
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

    echo 'get title using match function'
    echo 'BEGIN{'
    echo '  FS=" "'
    echo '  filter=".* ft\. .*"'
    echo '}'
    echo '$0 ~ filter {'
    echo '   match($0, /.* — (.*) ft\. .*/, arr)'
    echo '           print arr[1]'
    echo ''
    echo '}'
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

# get option parameters
while getopts t:a:l:f: flag; do
    case "${flag}" in
    t) TITLE_PROGRAM=${OPTARG} ;;
    a) ARTIST_PROGRAM=${OPTARG} ;;
    l) ALBUM_PROGRAM=${OPTARG} ;;
    f) FILE_FORMAT=${OPTARG} ;;
    esac
done

# log metadata programs
echo "TITLE_PROGRAM: $TITLE_PROGRAM"
echo "ARTIST_PROGRAM: $ARTIST_PROGRAM"
echo "ALBUM_PROGRAM: $ALBUM_PROGRAM"
echo "FILE_FORMAT: $FILE_FORMAT"

# check the src folder existance
if [[ ! -d "$SRC_FOLDER" ]]; then
    echo "first parameter must be a folder"
    exit 1
fi

# create folder if dosent exist
if [[ ! -d "$DEST_FOLDER" ]]; then
    mkdir "$DEST_FOLDER"
fi

# set default file format to opus if no format is provided
if [[ "$FILE_FORMAT" == '' ]]; then
    FILE_FORMAT='opus'
fi

# main loop
for FILE in "$SRC_FOLDER"/*.$FILE_FORMAT; do

    # get name file
    NAME="$(echo $FILE | awk 'END{ var=$0; n=split (var,a,/\//); print a[n]}')"

    # get metadata values from names
    if [[ "$ARTIST_PROGRAM" != '' ]]; then
        ARTIST="$(echo $NAME | awk -f "$ARTIST_PROGRAM")"

    fi
    if [[ "$ALBUM_PROGRAM" != '' ]]; then
        ALBUM="$(echo $NAME | awk -f "$ALBUM_PROGRAM")"
    fi
    if [[ "$TITLE_PROGRAM" != '' ]]; then
        TITLE="$(echo $NAME | awk -f "$TITLE_PROGRAM" )"
    fi

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
