#!/bin/bash

# IMPORTS
source "$HOME/scripts/settings.sh"
source "$SCRIPTS_LIBS_FOLDER/menu_standard.sh"

menu_theme_setup musicplayer

# MPV COMMANDS
FORWARD='{"command":["seek","5"]}'
BACKWARD='{"command":["seek","-5"]}'

# MPV SOCKET FILE
MPV_SOCKET="$SCRIPTS_RUN_FOLDER/mpv.socket"

# print folders with music content
print_playlists() {
  echo -e "$(for dir in $musicplayer_folders; do ls -d "$dir"/*/; done)"  | menu_cmd "${prompt}"

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

# COMMAND FUNCTIONS
forward(){
  run_command "$FORWARD"
}
backward(){
  run_command "$BACKWARD"
}

#kill vlc command
player_stop(){
  player="$(cat $SCRIPTS_RUN_FOLDER/pid.player)"
    if [ "$player" != '' ]; then
      kill $player
      rm $SCRIPTS_RUN_FOLDER/pid.player
    fi
}

#main
run_player(){
  chosen="$(print_playlists)"
  
  #run playlist
  if [[ -d "$folder/$chosen" &&  "$chosen" != '' ]]; then
    player="$(cat $SCRIPTS_RUN_FOLDER/pid.player)"
      if [ "$player" != '' ]; then
        kill $player
        sleep 1
      fi
    mpv --input-ipc-server="$MPV_SOCKET"  --no-video "$folder/$chosen" 2>> $SCRIPTS_LOGS_FOLDER/musicplayer.player.log >> $SCRIPTS_LOGS_FOLDER/musicplayer.player.log &
    echo $! > $SCRIPTS_RUN_FOLDER/pid.player
    notify-send -a "Music player" -u "normal" "$chosen" "playing $chosen"
  fi
}

case "$1" in
  fw)
    forward
    ;;
  bw)
    backward
    ;;
  stop)
    player_stop
    ;;
  '')
    run_player
    ;;
  *)
   help 
    ;;
esac
