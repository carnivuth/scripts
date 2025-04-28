#!/usr/bin/bash
source "$HOME/.config/scripts/settings.sh"

list_notification(){
  dunstctl history | jq -r '.data.[][].summary.data' | sed 's/^/notification:/g'
}

exec_command_with_chosen_element(){
  true
}
