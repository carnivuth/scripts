#!/usr/bin/bash
source "$HOME/scripts/settings.sh"
source "$SCRIPTS_LIBS_FOLDER"/"$MENU_BACKEND"_standard.sh

menu_theme_setup themeswitcher

# menu cmd
print_menu() {

	echo -e "$(for dir in $THEMESWITCHER_FOLDERS; do ls -d "$dir"/*.png;ls -d "$dir"/*.jpg;ls -d "$dir"/*.jpeg; done)" | menu_cmd "themes"

}
# main
chosen="$(print_menu)"
echo $chosen
if [ -f "$chosen" ]; then

	wal -i "$chosen" -o "$SCRIPTS_HOME_FOLDER/carnivuth-DE/applets/postwal.sh"

  # run specific scripts if under hyprland setup
  if [[ "$XDG_CURRENT_DESKTOP" == 'Hyprland' ]]; then
    source "$SCRIPTS_HOME_FOLDER/carnivuth-DE/bin/swaylock/swaylock-color-switcher.sh" "$chosen"
    source "$SCRIPTS_HOME_FOLDER/carnivuth-DE/bin/hyprpaper/hyprpaper-color-switcher.sh" "$chosen"
    killall waybar
    waybar &
  fi

fi
