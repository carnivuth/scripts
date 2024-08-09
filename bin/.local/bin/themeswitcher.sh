#!/usr/bin/bash
source "$HOME/.config/settings.sh"
source "$SCRIPTS_LIB_FOLDER/get_wal_color.sh"

#hyprpaper change background script
hyprpaper_switcher(){
  hyprctl hyprpaper preload "$1"
  hyprctl hyprpaper wallpaper eDP-1,"$1"
  hyprctl hyprpaper wallpaper HDMI-A-1,"$1"
  sed -i "s|^preload = .*|preload = $1|" $HOME/.config/hypr/hyprpaper.conf
  sed -i "s|^wallpaper = \,.*|wallpaper = ,$1|" $HOME/.config/hypr/hyprpaper.conf
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
  if [ -f "$chosen" ]; then
    wal -i "$chosen" -o "$SCRIPTS_BIN_FOLDER/postwal.sh"
    # run specific scripts if under hyprland setup
    if [[ "$XDG_CURRENT_DESKTOP" == 'Hyprland' ]]; then
      hyprpaper_switcher "$chosen"
      killall waybar
      waybar &
    fi
  fi
}

source "$SCRIPTS_LIB_FOLDER/menu.sh"
