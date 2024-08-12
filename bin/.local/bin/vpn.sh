#!/bin/bash
# get_weather.sh
source "$HOME/.config/scripts/settings.sh"

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
toggle_vpn(){
  connection_status="$( nmcli connection show --active | grep "$VPN_CONNECTION_NAME")"
  if [[ "$connection_status" != "" ]]; then
    nmcli connection down "$VPN_CONNECTION_NAME"
  else
    nmcli connection up "$VPN_CONNECTION_NAME"
  fi
}
case "$1" in
  "check_connection")
    check_connection
    ;;
  "toggle_vpn")
    toggle_vpn
    ;;
  *)
    echo "usage $0 [check_connection|toggle_vpn]"
    ;;
esac
