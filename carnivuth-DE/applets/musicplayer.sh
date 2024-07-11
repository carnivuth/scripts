#!/bin/bash

# IMPORTS
source "$HOME/scripts/settings.sh"
source "$SCRIPTS_LIBS_FOLDER"/"$MENU_BACKEND"_standard.sh

menu_theme_setup musicplayer

# MPV COMMANDS
FORWARD='{"command":["seek","5"]}'
BACKWARD='{"command":["seek","-5"]}'
KILL='{"command":["stop"]}'

# print folders with music content
print_playlists() {
  echo -e "$(for dir in $musicplayer_folders; do ls -d "$dir"/*/; done)"  | menu_cmd "playlists"

}

# print help
help(){
  echo "musicplayer applet"
  echo "usage $0 [cmd]"
  echo "cmd: [fw|bw|kill]"
}

# wrapper for sending command to mpv through socket
run_command(){
  echo "$1" | socat - "$MPV_SOCKET"
}

#main
run_player(){
  chosen="$(print_playlists)"

  #run playlist
  if [[ -d "$folder/$chosen" &&  "$chosen" != '' ]]; then
    run_command "$KILL"
    mpv \
        --no-video "$folder/$chosen" 2>> $SCRIPTS_LOGS_FOLDER/musicplayer.player.log >> $SCRIPTS_LOGS_FOLDER/musicplayer.player.log &
    notify-send -a "Music player" -u "normal" "$chosen" "playing $chosen"
  fi
}

case "$1" in
  fw)
    run_command "$FORWARD"
    ;;
  bw)
    run_command "$BACKWARD"
    ;;
  kill)
    run_command "$KILL"
    ;;
  '')
    run_player
    ;;
  *)
   help
    ;;
esac
