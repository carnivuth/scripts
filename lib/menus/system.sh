#!/bin/bash
source "$HOME/.config/scripts/settings.sh"

SHUTDOWN=' poweroff'
REBOOT=' reboot'
LOCK=' lock'
SUSPEND=' suspend'
LOGOUT=' logout'

list_system(){
  echo -e "$LOCK\n$SUSPEND\n$LOGOUT\n$REBOOT\n$SHUTDOWN" | sed 's/^/system:/'
}

run_system(){
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
      hyprctl dispatch 'hl.dsp.exit()'
      ;;
    awesome)
      killall awesome
  esac

}

# lock function based on DESKTOP_SESSION var
lock_command(){

  case "$DESKTOP_SESSION" in
    i3)
      if [[ "$(playerctl status)" != 'Paused' ]];then playerctl pause; fi
      i3lock
      ;;
    hyprland)
      if [[ "$(playerctl status)" != 'Paused' ]];then playerctl pause; fi
      hyprlock
      ;;
    sway)
      if [[ "$(playerctl status)" != 'Paused' ]];then playerctl pause; fi
      swaylock
      ;;
  esac
}

