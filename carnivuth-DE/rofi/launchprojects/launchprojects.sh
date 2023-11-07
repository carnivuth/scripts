#!/usr/bin/bash
#documentation at https://github.com/carnivuth/scripts/blob/main/notes/pages/PROJECTLAUNCHER.md
source "$HOME/scripts/settings.sh"
source "$SCRIPTS_LIBS_FOLDER/array_importer.sh"
source "$SCRIPTS_LIBS_FOLDER/rofi_standard.sh"

rofi_theme_setup $ROFI_CONFIG_FOLDER/launchproject "$2" "project launcher"

#import values from array
array_importer "$SCRIPTS_HOME_FOLDER/carnivuth-DE/rofi/launchprojects/folders.sh" "$HOME"



# rofi cmd
print_menu() {

	echo -e "$(for dir in ${ARRAY[@]}; do ls -d "$dir"/*/; done)" | rofi_cmd "${prompt}"

}
# main
chosen="$(print_menu)"
echo $chosen
# open selected folder on $1 parameter default code
if [ -d "$chosen" ]; then
	if [ "$#" -eq 1 ]; then
		"$1" "$chosen"
	else
		code "$chosen"
	fi
fi
