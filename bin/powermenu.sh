#!/bin/bash
source "$HOME/.config/scripts/settings.sh"

# STANDARD MENU VARS AND FUNCTIONS
MENU_NAME="powermenu"
PROMPT="powermenu"

help_message(){
  echo " script for power options"
}

list_elements_to_user(){
  echo -e "$LOCK\n$SUSPEND\n$LOGOUT\n$REBOOT\n$SHUTDOWN"
}

exec_command_with_chosen_element(){
  case "$1" in
    "$SHUTDOWN")
      $SHUTDOWN_COMMAND
      ;;
    "$REBOOT")
      $REBOOT_COMMAND
      ;;
    "$SUSPEND")
      $SUSPEND_COMMAND
      ;;
    "$LOCK")
      lock_command
      ;;
    "$LOGOUT")
      logout_command
      ;;
  esac
}
# SCRIPT SPECIFIC VARS AND FUNCTIONS

SHUTDOWN_COMMAND='systemctl poweroff'
REBOOT_COMMAND='systemctl reboot'
SUSPEND_COMMAND='systemctl suspend'

# logout function based on DESKTOP_SESSION env var
logout_command(){

  case "$DESKTOP_SESSION" in
    sway)
      swaymsg exit
      ;;
    i3)
      i3-msg exit
      ;;
    hyprland)
      HYPRCMDS=$(hyprctl -j clients | jq -j '.[] | "dispatch closewindow address:\(.address); "')
      hyprctl --batch "$HYPRCMDS" >> /tmp/hypr/hyprexitwithgrace.log 2>&1
      hyprctl dispatch exit
      ;;
    awesome)
      killall awesome
  esac

}

# lock function based on DESKTOP_SESSION var
lock_command(){

  case "$DESKTOP_SESSION" in
    i3)
      i3lock
      ;;
    hyprland)
      hyprlock
      ;;
    sway)
      swaylock
      ;;
  esac
}

# set menu entries based on format setting
if [[ $POWERMENU_FORMAT == 'long' ]]; then
  SHUTDOWN=' poweroff'
  REBOOT=' reboot'
  LOCK=' lock'
  SUSPEND=' suspend'
  LOGOUT=' logout'
fi

if [[ $POWERMENU_FORMAT == 'short' ]]; then
  SHUTDOWN=''
  REBOOT=''
  LOCK=''
  SUSPEND=''
  LOGOUT=''
fi

source "$SCRIPTS_LIB_FOLDER/menu.sh"
