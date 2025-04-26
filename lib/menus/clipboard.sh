#!/usr/bin/bash
source "$HOME/.config/scripts/settings.sh"

list_clipboard(){
  cliphist list | sed 's/^/clipboard:/g'
}

run_clipboard(){
  code="$(echo -n "$1" | awk -F' ' '{print $1}')"
  echo -n "$code" | cliphist decode | wl-copy
}
