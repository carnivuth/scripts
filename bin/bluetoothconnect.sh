#!/usr/bin/bash
MENU_NAME="bluetoothconnect"
PROMPT="bluetooth devices"
source "$HOME/.config/scripts/settings.sh"

help_message(){
  echo "script to connect to bluetooth devices"
  echo " usage $0 "
}
list_elements_to_user(){
  bluetoothctl devices |  cut -f 2- -d' ' | sort | while read mac name;  do echo "$name";done
}

exec_command_with_chosen_element(){
  bluetoothctl devices |  cut -f 2- -d' ' | sort | while read mac name;  do
  if [[ "$chosen" == "$name" ]]; then
    bluetoothctl connect "$mac"
  fi
done
}


source "$SCRIPTS_LIB_FOLDER/menu.sh"
