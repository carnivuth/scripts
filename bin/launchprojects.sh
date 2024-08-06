#!/usr/bin/bash
#documentation at https://github.com/carnivuth/scripts/blob/main/notes/pages/PROJECTLAUNCHER.md
source "$HOME/scripts/settings.sh"
source "$SCRIPTS_LIB_FOLDER"/"$MENU_BACKEND"_standard.sh

menu_theme_setup launchprojects

# rofi cmd
print_menu() {

	echo -e "$(for dir in $LAUNCHPROJECTS_FOLDERS; do ls -d "$dir"/*/; done)" | menu_cmd "projects"

}

# set editor command
if [[ "$1" != '' ]]; then EDITOR_COMMAND="$1"; shift; else EDITOR_COMMAND="$LAUNCHPROJECTS_DEFAULT_EDITOR";fi

# exit if parameter is not executable
if [[ ! -x "$(which "$EDITOR_COMMAND")" ]]; then echo "$EDITOR_COMMAND is not executable"; exit 1; fi

chosen="$(print_menu)"
echo "$chosen"

if [ -d "$chosen" ]; then
  "$EDITOR_COMMAND" "$@" "$chosen"
fi
