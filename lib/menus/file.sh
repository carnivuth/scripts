#!/bin/bash
source "$HOME/.config/scripts/settings.sh"
FILE_MANAGER=thunar
MUSIC_PLAYER=mpv
PDF_READER=evince
FILE_EDITOR="$TERM vim"

list_file(){
  find $HOME -type f -not -path '*/.*' -not -path '*/site-packages/*' -not -path '*/env/*' -not -path '*/go/pkg*' -mount | sed 's/^/file:/g'

}

run_file(){

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
