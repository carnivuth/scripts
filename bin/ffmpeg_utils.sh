#!/bin/bash
source "$HOME/.config/scripts/settings.sh"

declare -A FLAGS
FLAGS[f]='FILE_FORMAT=${OPTARG}'
FLAGS[s]='SRC_FOLDER=${OPTARG}'
FLAGS[d]='DEST_FOLDER=${OPTARG}'
FLAGS[i]='INPUT_FILE=${OPTARG}'
FLAGS[T]='DURATION=${OPTARG}'

declare -A FLAGS_DESCRIPTIONS
FLAGS_DESCRIPTIONS[f]='file format to convert the file to'
FLAGS_DESCRIPTIONS[s]='content src folder'
FLAGS_DESCRIPTIONS[d]='content dest folder'
FLAGS_DESCRIPTIONS[i]='file to cut'
FLAGS_DESCRIPTIONS[T]='seconds to cut of the given file'

FLAGS_STRING='f:s:d:i:T'

declare -A COMMANDS
COMMANDS[convert_to]="convert audio video files in batch"
COMMANDS[cut_video]="cut video to a specific duration"
COMMANDS[video2gif]="convert video to gif"

function wait_n_proc {
  n_proc="$(nproc --all)"
  while [ $(jobs | wc -l) -ge $n_proc ]
  do
    sleep 3
  done
}

function convert_to(){

  # check for folder parameters and exit if absent
  if [[ -z $SRC_FOLDER ]] || [[ -z $FILE_FORMAT ]] || [[ -z $DEST_FOLDER ]]; then help; exit 1; fi


  if [[ ! -d "$SRC_FOLDER" ]]; then echo "first parameter must be a folder"; exit 1; fi

  # create folder if dosent exist
  if [[ ! -d "$DEST_FOLDER" ]]; then mkdir -p "$DEST_FOLDER"; fi

  for file in $SRC_FOLDER/*; do

      # get name file
      name=${file%.*}

    # print
    echo "CONVERTING $name TO $FILE_FORMAT"

    # encode with ffmpeg
    wait_n_proc ; ffmpeg \
      -y -stats \
      -i "$file" \
      -c:v h264_nvenc \
      "$DEST_FOLDER/$name.$FILE_FORMAT" &

  done
}
function cut_video(){

  if [[ -z $DURATION ]]; then echo 'duration parameter needed';help; exit 1; fi
  if [[ -z $INPUT_FILE ]]; then echo "input file needed";help; exit 1; fi

  filename="$(basename "$1" )"
  ext="${filename##*.}"
  ffmpeg -i "$INPUT_FILE" -to "$DURATION" -c:v copy -c:a copy "$filename-cutted.$ext"
}
function video2gif(){

  if [[ -z $INPUT_FILE ]]; then echo "input file needed";help; exit 1; fi
  if [[ ! -f "$INPUT_FILE" ]]; then echo "INPUT_FILE must be a file";help; exit 1; fi

  out_file="${INPUT_FILE%.*}"

  # run ffmpeg
  ffmpeg -i "$INPUT_FILE" -v quiet -y -stats -vf "fps=10,scale=640:-1:flags=lanczos,split[s0][s1];[s0]palettegen[p];[s1][p]paletteuse" -loop 0 "$out_file-$(date '+%s')".gif
}

source "$SCRIPTS_LIB_FOLDER/cli.sh"
