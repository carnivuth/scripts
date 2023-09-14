#!/bin/bash
source "$HOME/scripts/settings.sh"
source "$SCRIPTS_LIBS_FOLDER/array_importer.sh"
source "$SCRIPTS_LIBS_FOLDER/rofi_standard.sh"

rofi_theme_setup $ROFI_CONFIG_FOLDER/ndslauncher "$2" "open nds games with desmume"

#import values from array
array_importer "$SCRIPTS_HOME_FOLDER/rofi/ndslauncher/folders.sh" "$HOME"


# rofi cmd
print_roms() {
	for dir in ${ARRAY[@]}; do echo -e "$(ls  "$dir"/*)" ; done   | rofi_cmd
}
# main
chosen="$(print_roms)"
echo $chosen
# open selected folder on $1 parameter default code
if [ -f "$chosen" ]; then
	desmume "$chosen" &

fi
