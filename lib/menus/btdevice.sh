#!/bin/bash
source "$HOME/.config/scripts/settings.sh"

function list_btdevice(){
  systemctl is-active --quiet bluetooth && bluetoothctl devices |  awk -F' ' '{$1=""; $2=""; print $0}' | sed 's/^\s*//g' | sed 's/^/btdevice:/g'
}

function run_btdevice(){
  systemctl is-active --quiet bluetooth && bluetoothctl devices |  awk -F' ' '{$1=""; print $0}' | sed 's/^\s*//g' |  while read mac name;  do
  if [[ "$1" == "$name" ]]; then
    systemctl is-active --quiet bluetooth && bluetoothctl disconnect "$mac"
    systemctl is-active --quiet bluetooth && bluetoothctl connect "$mac"
  fi
done
}
