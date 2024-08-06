#!/bin/bash
source "$HOME/scripts/settings.sh"
source "$SCRIPTS_LIB_FOLDER/array_importer.sh"

KEYBOARD_LAYOUTS="us it"


current_layout=$(setxkbmap -print -verbose 10 | grep layout | rev | cut -d" " -f1 | rev)
echo "$current_layout"

for layout in ${KEYBOARD_LAYOUTS}; do
  if [[ "$layout" == "$current_layout" ]]; then
    #check for the end array
    setxkbmap "${KEYBOARD_LAYOUTS[$new_layout_index]}" && notify-send -a "Keyboard switcher" -u "normal" "layout changed" "changed layout to ${KEYBOARD_LAYOUTS[$new_layout_index]}"
    exit 0
  fi
done
