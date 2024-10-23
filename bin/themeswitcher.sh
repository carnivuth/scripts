#!/usr/bin/bash
source "$HOME/.config/scripts/settings.sh"
source "$SCRIPTS_LIB_FOLDER/get_wal_color.sh"

#hyprpaper change background script
hyprpaper_switcher(){
  hyprctl hyprpaper preload "$1"
  hyprctl hyprpaper wallpaper eDP-1,"$1"
  hyprctl hyprpaper wallpaper HDMI-A-1,"$1"
  cat <<EOT > "$HOME/.config/hypr/hyprpaper.conf"
preload = $1
wallpaper = ,$1
splash = false
EOT
}


MENU_NAME="themeswitcher"
PROMPT="themes"

help_message(){
  echo "script for changing wallpaper and theme in supported applications"
  echo "usage: $0"
}

list_elements_to_user(){
  echo -e "$(for dir in $THEMESWITCHER_FOLDERS; do ls -d "$dir"/*.png;ls -d "$dir"/*.jpg;ls -d "$dir"/*.jpeg; done)"
}

exec_command_with_chosen_element(){
  # run specific scripts based on current desktop
  case "$XDG_CURRENT_DESKTOP" in
    "Hyprland")
      hyprpaper_switcher "$1"
      killall -SIGUSR2 waybar
      ;;
    "sway")
      # TODO
    esac
  }

  source "$SCRIPTS_LIB_FOLDER/menu.sh"
