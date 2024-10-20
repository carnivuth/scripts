#!/bin/bash
source "$HOME/.config/scripts/settings.sh"
MENU_NAME="quickopen"
PROMPT="files"
FILE_MANAGER=thunar
MUSIC_PLAYER=mpv
PDF_READER=evince
FILE_EDITOR="$TERM vim"

help_message(){
  echo "open files faster"
}

list_elements_to_user(){
  cd $HOME && find -H
}

exec_command_with_chosen_element(){

  cd $HOME || echo "falied to enter in $HOME dir"
  chosen="$1"
  if [ -d "$chosen" ]; then "$FILE_MANAGER" "$chosen"; exit 0;fi

  filetype="$(xdg-mime query filetype "$chosen")"
  echo "$filetype"
  case "$filetype" in

    text/*) ($FILE_EDITOR  "$chosen" &);;
    audio/*) $MUSIC_PLAYER "${chosen}";;
    application/pdf) $PDF_READER "${chosen}";;
    *) xdg-open "$chosen";;
  esac
}

source "$SCRIPTS_LIB_FOLDER/menu.sh"
