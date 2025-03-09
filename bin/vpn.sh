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
APP_ICON="/usr/share/icons/Papirus/32x32/apps/openvpn.svg"

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
  while true ; do
    connection_status="$( nmcli connection show --active | grep "$VPN_CONNECTION_NAME")"
    if [[ "$connection_status" != "" ]]; then
      text=" $VPN_CONNECTION_NAME"
      tooltip="connected to $VPN_CONNECTION_NAME"
    else
      text="  $VPN_CONNECTION_NAME"
      tooltip="not connected to $VPN_CONNECTION_NAME"
    fi
    echo "{ \"text\":\"$text\",\"tooltip\":\"$tooltip\"}" |jq --unbuffered --compact-output
    sleep 5s
  done
}

toggle(){
  connection_status="$( nmcli connection show --active | grep "$VPN_CONNECTION_NAME")"
  if [[ "$connection_status" != "" ]]; then
    nmcli connection down "$VPN_CONNECTION_NAME" && notify "normal"  "VPN $VPN_CONNECTION_NAME turned off"
  else
    if [[ "$(secret-tool search vpn-repository vpn_passphrase)" != '' ]]; then
      secret-tool lookup vpn-repository vpn_passphrase | nmcli connection up "$VPN_CONNECTION_NAME" --ask   && notify "normal" "VPN $VPN_CONNECTION_NAME turned on"
    else
      notify "critical" "VPN $VPN_CONNECTION_NAME not configured, run $0 init and set passphrase"
    fi
  fi
}

source "$SCRIPTS_LIB_FOLDER/cli.sh"
