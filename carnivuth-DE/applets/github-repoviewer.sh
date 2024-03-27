#!/usr/bin/bash

source "$HOME/scripts/settings.sh"
source "$SCRIPTS_LIBS_FOLDER"/"$MENU_BACKEND"_standard.sh
source "$SCRIPTS_LIBS_FOLDER/menu_standard.sh"

menu_theme_setup github-repoviewer
get_file(){
    curl https://api.github.com/users/$github_repoviewer_account/repos > "$SCRIPTS_LOCAL_FOLDER/repos.json"
}

print_menu() {
    # check if cache is valid
    birth_date="$(stat .local/scripts/repos.json  | grep Birth | cut -d' ' -f 3)"
    today="$(date +%F)"
    if [[ "$birth_date" != "$today"  ]]; then
        rm "$SCRIPTS_LOCAL_FOLDER/repos.json"
        get_file
    fi
    
    echo -e "$(cat $SCRIPTS_LOCAL_FOLDER/repos.json | jq -r '.[] | .html_url')" | menu_cmd "github repos"

}

# main
chosen="$(print_menu)"
echo $chosen
# open selected folder on $1 parameter default code
if [  "$chosen" != "" ]; then
		firefox --new-tab "$chosen"
    # draw attention to the firefox window if running on hyprland
    if [[ "$XDG_CURRENT_DESKTOP" == 'Hyprland' ]]; then
      hyprctl dispatch 'focuswindow firefox'
    fi
fi
