#!/usr/bin/bash
source "$HOME/scripts/settings.sh"
source "$SCRIPTS_LIB_FOLDER/$MENU_BACKEND"_standard.sh
source "$SCRIPTS_LIB_FOLDER/get_wal_color.sh"

menu_theme_setup themeswitcher

hyprpaper_switcher(){
  hyprctl hyprpaper preload "$1"
  hyprctl hyprpaper wallpaper eDP-1,"$1"
  hyprctl hyprpaper wallpaper HDMI-A-1,"$1"
  sed -i "s|^preload = .*|preload = $1|" $HOME/.config/hypr/hyprpaper.conf
  sed -i "s|^wallpaper = \,.*|wallpaper = ,$1|" $HOME/.config/hypr/hyprpaper.conf
}
# menu cmd
print_menu() {

  echo -e "$(for dir in $THEMESWITCHER_FOLDERS; do ls -d "$dir"/*.png;ls -d "$dir"/*.jpg;ls -d "$dir"/*.jpeg; done)" | menu_cmd "themes"

}
# main
chosen="$(print_menu)"
echo "$chosen"
if [ -f "$chosen" ]; then

  wal -i "$chosen" -o "$SCRIPTS_BIN_FOLDER/postwal.sh"

  # run specific scripts if under hyprland setup
  if [[ "$XDG_CURRENT_DESKTOP" == 'Hyprland' ]]; then

    hyprpaper_switcher "$chosen"
    killall waybar
    waybar &
  fi

fi
