#!/usr/bin/bash

source "$HOME/scripts/settings.sh"
source "$SCRIPTS_LIBS_FOLDER/array_importer.sh"
source "$SCRIPTS_LIBS_FOLDER/rofi_standard.sh"

rofi_theme_setup $ROFI_CONFIG_FOLDER/themeswitcher "$1" "theme switcher"

#import values from array
array_importer "$SCRIPTS_HOME_FOLDER/carnivuth-DE/rofi/themeswitcher/folders.sh" "/usr/share/backgrounds"



# rofi cmd
print_menu() {

	echo -e "$(for dir in ${ARRAY[@]}; do ls -d "$dir"/*.png; done)" | rofi_cmd "${prompt}"

}
# main
chosen="$(print_menu)"
echo $chosen
if [ -f "$chosen" ]; then
	wal -i "$chosen" -o "$SCRIPTS_HOME_FOLDER/carnivuth-DE/rofi/themeswitcher/postwal.sh"
fi
