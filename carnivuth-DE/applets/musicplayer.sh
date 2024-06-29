#!/bin/bash

# IMPORTS
source "$HOME/scripts/settings.sh"
source "$SCRIPTS_LIBS_FOLDER"/"$MENU_BACKEND"_standard.sh

menu_theme_setup musicplayer

# MPV COMMANDS
FORWARD='{"command":["seek","5"]}'
BACKWARD='{"command":["seek","-5"]}'

# MPV SOCKET FILE
MPV_SOCKET="$SCRIPTS_RUN_FOLDER/mpv.socket"

# print folders with music content
print_playlists() {
  echo -e "$(for dir in $musicplayer_folders; do ls -d "$dir"/*/; done)"  | menu_cmd "playlists"

}

# print help
help(){
  echo "musicplayer applet"
  echo "usage $0 [cmd]"
  echo "cmd: [fw|bw|stop]"
}

# wrapper for sending command to mpv through socket
run_command(){
  echo "$1" | socat - "$MPV_SOCKET"
}

#kill vlc command
kill_mpv(){
  kill -9 "$(pidof mpv)"
}

#main
run_player(){
  chosen="$(print_playlists)"

  #run playlist
  if [[ -d "$folder/$chosen" &&  "$chosen" != '' ]]; then
    kill_mpv
    mpv --input-ipc-server="$MPV_SOCKET"  \
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
  stop)
    kill_mpv
    ;;
  '')
    run_player
    ;;
  *)
   help
    ;;
esac
