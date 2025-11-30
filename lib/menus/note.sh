#!/usr/bin/bash
source "$HOME/.config/scripts/settings.sh"
source "$SCRIPTS_LIB_FOLDER/launch_webapp.sh"
NOTES_SITE="https://www.carnivuth.org"

list_note(){
  curl -L "$NOTES_SITE/index.json"  | jq  '.[] | "\( .title)|\(.permalink)"' -r | sed 's/^/note:/'
}

run_note(){

  permalink=$(echo $1 | awk -F '|' '{print $2}');

  launch_webapp "$permalink"
  # draw attention to the firefox window if running on hyprland
  if [[ "$XDG_CURRENT_DESKTOP" == 'Hyprland' ]]; then
    hyprctl dispatch 'focuswindow firefox'
  fi

}
