#!/usr/bin/bash
source "$HOME/.config/scripts/settings.sh"

list_bitwarden-item(){
  BW=$(zenity --password)

  # list bw items
  echo $BW | bw list items | jq -r '.[].name' |  sed "s/^/bitwarden-item:/g"
  unset $BW
}

run_bitwarden-item(){
  BW=$(zenity --password)
  echo $BW | bw get item password "$1" | wl-copy
  unset $BW
}
