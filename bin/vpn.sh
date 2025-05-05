#!/bin/bash
source "$HOME/.config/scripts/settings.sh"
source "$SCRIPTS_LIB_FOLDER/notify.sh"

FLAGS_STRING=''
declare -A FLAGS

declare -A COMMANDS
COMMANDS[toggle]="toggle connection to vpn configured in settings file"
COMMANDS[check_connection]="check if connected to vpn"
COMMANDS[init]="initialize vpn"

APP_NAME="vpn"
APP_ICON="/usr/share/icons/Papirus/16x16/apps/openvpn.svg"
STATUS_FILE="$SCRIPTS_RUN_FOLDER/vpn.status"

function init(){

  if [[ "$(secret-tool search vpn-repository vpn_passphrase)" == '' ]]; then
    echo -n "input vpn passphrase:"
    read -s vpn_passphrase
    echo "$vpn_passphrase"| secret-tool store vpn-repository vpn_passphrase --label="vpn passphrase"
  else
    echo "vpn already initialized"
  fi

}

function check_connection(){
  if [[ ! -f "$STATUS_FILE" ]]; then echo $0 > "$STATUS_FILE"; fi
    connection_status="$( cat "$STATUS_FILE" )"
    if [[ "$connection_status" == 1 ]]; then
      text=" $VPN_CONNECTION_NAME"
      tooltip="connected to $VPN_CONNECTION_NAME"
    else
      text="  $VPN_CONNECTION_NAME"
      tooltip="not connected to $VPN_CONNECTION_NAME"
    fi
    echo "{ \"text\":\"$text\",\"tooltip\":\"$tooltip\"}" |jq --unbuffered --compact-output

  inotifywait -m "$STATUS_FILE" -e close_write | while read event; do
    connection_status="$( cat "$STATUS_FILE" )"
    if [[ "$connection_status" == 1 ]]; then
      text=" $VPN_CONNECTION_NAME"
      tooltip="connected to $VPN_CONNECTION_NAME"
    else
      text="  $VPN_CONNECTION_NAME"
      tooltip="not connected to $VPN_CONNECTION_NAME"
    fi
    echo "{ \"text\":\"$text\",\"tooltip\":\"$tooltip\"}" |jq --unbuffered --compact-output
  done
}

toggle(){
  connection_status="$( nmcli connection show --active | grep "$VPN_CONNECTION_NAME")"
  if [[ "$connection_status" != "" ]]; then
    nmcli connection down "$VPN_CONNECTION_NAME" && notify "normal"  "VPN $VPN_CONNECTION_NAME turned off" && echo 0 > "$SCRIPTS_RUN_FOLDER/vpn.status"
  else
    if [[ "$(secret-tool search vpn-repository vpn_passphrase)" != '' ]]; then
      secret-tool lookup vpn-repository vpn_passphrase | nmcli connection up "$VPN_CONNECTION_NAME" --ask   && notify "normal" "VPN $VPN_CONNECTION_NAME turned on" && echo 1 > "$SCRIPTS_RUN_FOLDER/vpn.status"
    else
      notify "critical" "VPN $VPN_CONNECTION_NAME not configured, run $0 init and set passphrase"
    fi
  fi
}

source "$SCRIPTS_LIB_FOLDER/cli.sh"
