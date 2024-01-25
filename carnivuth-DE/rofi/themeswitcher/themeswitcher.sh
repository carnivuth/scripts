#!/usr/bin/bash

source "$HOME/scripts/settings.sh"
source "$SCRIPTS_LIBS_FOLDER/array_importer.sh"
source "$SCRIPTS_LIBS_FOLDER/menu_standard.sh"

menu_theme_setup themeswitcher 

#import values from array
array_importer "$SCRIPTS_HOME_FOLDER/carnivuth-DE/rofi/themeswitcher/folders.sh" "/usr/share/backgrounds"



# menu cmd
print_menu() {

	echo -e "$(for dir in ${ARRAY[@]}; do ls -d "$dir"/*.png;ls -d "$dir"/*.jpg;ls -d "$dir"/*.jpeg; done)" | menu_cmd "${prompt}"

}
# main
chosen="$(print_menu)"
echo $chosen
if [ -f "$chosen" ]; then
	wal -i "$chosen" -o "$SCRIPTS_HOME_FOLDER/carnivuth-DE/rofi/themeswitcher/postwal.sh"
fi
