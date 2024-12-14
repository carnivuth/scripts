#!/bin/bash
# get_weather.sh
source "$HOME/.config/scripts/settings.sh"

FLAGS_STRING=''
declare -A FLAGS

declare -A COMMANDS
COMMANDS[toggle]="toggle connection to vpn configured in settings file"
COMMANDS[check_connection]="check if connected to vpn"
COMMANDS[init]="initialize vpn"

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
    nmcli connection down "$VPN_CONNECTION_NAME" && notify-send -a "$VPN_APP_NAME_NOTIFICATION" -u "normal" -i "$VPN_NOTIFICATION_ICON" "VPN $VPN_CONNECTION_NAME turned off"
  else
    if [[ "$(secret-tool search vpn-repository vpn_passphrase)" != '' ]]; then
      secret-tool lookup vpn-repository vpn_passphrase | nmcli connection up "$VPN_CONNECTION_NAME" --ask   && notify-send -a "$VPN_APP_NAME_NOTIFICATION" -u "normal" -i "$VPN_NOTIFICATION_ICON" "VPN $VPN_CONNECTION_NAME turned on"
    else
      notify-send -a "$VPN_APP_NAME_NOTIFICATION" -u "critical" -i "$VPN_NOTIFICATION_ICON" "VPN $VPN_CONNECTION_NAME not configured, run $0 init and set passphrase"
    fi
  fi
}

source "$SCRIPTS_LIB_FOLDER/cli.sh"
