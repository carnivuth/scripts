#!/usr/bin/bash
#documentation at https://github.com/carnivuth/scripts/blob/main/notes/pages/PROJECTLAUNCHER.md
source "$HOME/scripts/settings.sh"
source "$SCRIPTS_LIBS_FOLDER"/"$MENU_BACKEND"_standard.sh

menu_theme_setup launchprojects 

# rofi cmd
print_menu() {

	echo -e "$(for dir in $launchprojects_folders; do ls -d "$dir"/*/; done)" | menu_cmd "projects"

}
# main
chosen="$(print_menu)"
echo $chosen
# open selected folder on $1 parameter default code
if [ -d "$chosen" ]; then
	if [ "$#" -gt 0 ]; then
		"$@" "$chosen"
	else
		code "$chosen"
	fi
fi
