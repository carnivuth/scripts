#!/usr/bin/bash
source "$HOME/scripts/settings.sh"
source "$SCRIPTS_LIBS_FOLDER/menu_standard.sh"

menu_theme_setup themeswitcher 

# menu cmd
print_menu() {

	echo -e "$(for dir in $themeswitcher_folders; do ls -d "$dir"/*.png;ls -d "$dir"/*.jpg;ls -d "$dir"/*.jpeg; done)" | menu_cmd "themes"

}
# main
chosen="$(print_menu)"
echo $chosen
if [ -f "$chosen" ]; then
	wal -i "$chosen" -o "$SCRIPTS_HOME_FOLDER/carnivuth-DE/applets/postwal.sh"
fi
