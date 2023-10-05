#!/usr/bin/bash

source "$HOME/scripts/settings.sh"
source "$SCRIPTS_LIBS_FOLDER/rofi_standard.sh"
source "$SCRIPTS_HOME_FOLDER/carnivuth-DE/rofi/github-repoviewer/account.sh"

rofi_theme_setup $ROFI_CONFIG_FOLDER/github-repoviewer "$1" "github repos"
get_file(){
    curl https://api.github.com/users/$account/repos > "$SCRIPTS_LOCAL_FOLDER/repos.json"
}

print_menu() {
    get_file
    echo -e "$(cat $SCRIPTS_LOCAL_FOLDER/repos.json | jq -r '.[] | .html_url')" | rofi_cmd "${prompt}"

}

# main
chosen="$(print_menu)"
echo $chosen
# open selected folder on $1 parameter default code
if [  "$chosen" != "" ]; then
    firefox --new-window "$chosen"
fi
