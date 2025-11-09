#!/bin/bash
source "$HOME/.config/scripts/settings.sh"

# $1 mpv socket command
# $2 file to reproduce if mpv is not running
function run_mpv_or_send_command(){
  # check if socket exists and if it is open by a process
  if [[ ! -S "$MPV_SOCKET" ]] || ! lsof "$MPV_SOCKET" > /dev/null ;then
    mpv --no-video "--input-ipc-server=$MPV_SOCKET" "$2" > /dev/null 2>&1 &
    sleep 1
  else
    # pass command to mpv if it is already running
    echo "$1" | socat - "$MPV_SOCKET"
  fi
}

function append_track_on_mpv(){
    run_mpv_or_send_command "{ \"command\": [\"loadfile\", \"$1\",\"append\"] }" "$1"
}

function replace_track_on_mpv(){
    run_mpv_or_send_command "{ \"command\": [\"loadfile\", \"$1\"] }" "$1"
}

