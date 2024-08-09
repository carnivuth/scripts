#!/bin/bash
source "$HOME/.config/scripts/settings.sh"

# MPV VARS AND FUNCTIONS
FORWARD='{"command":["seek","5"]}'
BACKWARD='{"command":["seek","-5"]}'
KILL='{"command":["stop"]}'

# wrapper for sending command to mpv through socket
run_command(){
  if [[ -f "$MPV_SOCKET" ]];then
    echo "$1" | socat - "$MPV_SOCKET"
  fi
}

# GENERAL MENU VARS AND FUNCTIONS
MENU_NAME="musicplayer"
PROMPT="playlists"

list_elements_to_user() {
  echo -e "$(for dir in $MUSICPLAYER_FOLDERS; do ls -d "$dir"/*/; done)"
}

exec_command_with_chosen_element(){
  #run playlist
  if [[ -d "$1" &&  "$1" != '' ]]; then
    run_command "$KILL"
    mpv --no-video "$1" >> $SCRIPTS_LOGS_FOLDER/musicplayer.player.log 2>&1 &
    notify-send -a "Music player" -u "normal" "playing $chosen"
  fi
}

help_message(){
  echo " script for managing an mpv instance and open local folders of music"
  echo "usage $0 [-c cmd]"
  echo "-c cmd: command to send in the mpv socket options are: [fw|bw|kill]"
}

while getopts c:b:h flag; do
  case "${flag}" in
    c) MPV_COMMAND=${OPTARG} ; shift; shift ;;
    *);;
  esac
done

case "$MPV_COMMAND" in
  fw)
    run_command "$FORWARD"
    ;;
  bw)
    run_command "$BACKWARD"
    ;;
  kill)
    run_command "$KILL"
    ;;
  *)
    source "$SCRIPTS_LIB_FOLDER/menu.sh"
    ;;
esac
