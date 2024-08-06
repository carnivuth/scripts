#!/usr/bin/bash
source "$HOME/scripts/settings.sh"
source "$SCRIPTS_LIB_FOLDER"/"$MENU_BACKEND"_standard.sh
source "$SCRIPTS_LIB_FOLDER"/launch_webapp.sh
menu_theme_setup launchsites

# rofi cmd
desktop_files_to_json(){

  ls "$SCRIPTS_DESKTOPFILES_FOLDER" | while read -r filename; do
  app="$(basename "$SCRIPTS_DESKTOPFILES_FOLDER/$filename"  | awk -F'.' '{print $1}')";
  link="$(grep webapp "$SCRIPTS_DESKTOPFILES_FOLDER/$filename" | awk -F \' '{print $2}' )"
  if [[ "$link" != '' ]] && [[ "$app" != '' ]]; then
    echo "{ \"app\": \"$app\",\"link\": \"$link\"}"
  fi
done
}

print_menu() {
  jq -r '.app' "$SCRIPTS_LOCAL_FOLDER/sites.json" | menu_cmd "sites"
}

if [[ ! -f "$SCRIPTS_LOCAL_FOLDER/sites.json" ]];then
  desktop_files_to_json > "$SCRIPTS_LOCAL_FOLDER/sites.json"
fi

chosen="$(print_menu)"
site="$( jq -r "select(.app == \"$chosen\")| .link " "$SCRIPTS_LOCAL_FOLDER/sites.json" )"
if [[ "$site" != '' ]];then
  launch_webapp "$site"
fi
