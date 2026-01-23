#!/usr/bin/bash
source "$HOME/.config/scripts/settings.sh"
source "$SCRIPTS_LIB_FOLDER/control_mpv.sh"

list_cd(){
  find /dev -name 'sr*' |  sed 's/^/cd:/g'
}

run_cd(){
  replace_track_on_mpv "cdda://$1"
}
