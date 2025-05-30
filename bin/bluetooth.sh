#!/bin/bash
source "$HOME/.config/scripts/settings.sh"
declare -A FLAGS
FLAGS["b"]='MENU_BACKEND=${OPTARG}'
FLAGS_STRING='b:'

declare -A COMMANDS
COMMANDS[bluetooth_print]="print bluetooth devices"
COMMANDS[bluetooth_toggle]="toggle bluetooth"

function bluetooth_all_connect(){
  devices_paired=$(bluetoothctl devices Paired | grep Device | cut -d ' ' -f 2)
  echo "$devices_paired" | while read -r line; do
  bluetoothctl connect "$line" >> /dev/null
done
}

function bluetooth_print() {
  bluetoothctl | while read -r; do
  if [ "$(systemctl is-active "bluetooth.service")" == "active" ] && [ "$(bluetoothctl show | grep -o "Powered: yes")" == "Powered: yes" ]; then
    echo 'On'
    devices_paired=$(bluetoothctl devices Paired | grep Device | cut -d ' ' -f 2) counter=0

    for device in $devices_paired; do
      device_info=$(bluetoothctl info "$device")

      if echo "$device_info" | grep -q "Connected: yes"; then
        device_alias=$(echo "$device_info" | grep "Alias" | cut -d ' ' -f 2-)

        if [ $counter -gt 0 ]; then
          printf ", %s" "$device_alias "
        else
          printf " %s" "$device_alias "
        fi

        counter=$((counter + 1))
      fi
    done

  else
    echo 'Off'

  fi
done
}

function bluetooth_toggle() {
  if bluetoothctl show | grep -q "Powered: no"; then
    bluetoothctl power on >> /dev/null
  else
    devices_paired=$(bluetoothctl devices Paired | grep Device | cut -d ' ' -f 2)
    echo "$devices_paired" | while read -r line; do
    bluetoothctl disconnect "$line" >> /dev/null
  done

  bluetoothctl power off >> /dev/null
  fi
}

source "$SCRIPTS_LIB_FOLDER/cli.sh"
