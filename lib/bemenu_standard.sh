#!/bin/bash
source "$HOME/scripts/settings.sh"
source "$SCRIPTS_LIB_FOLDER/get_wal_color.sh"
source "$SCRIPTS_LIB_FOLDER/launch_webapp.sh"
source "$SCRIPTS_LIB_FOLDER/print_bins.sh"

get_wal_color
BEMENU_HIGH=21
BEMENU_PADDING=10
BEMENU_FONT='JetBrainsMono Nerd Font,JetBrainsMono NF:style=ExtraBold 9'

menu_theme_setup(){
  echo "setup complete"
}

# create json structure from desktop files
desktop_files_to_json(){

  ls "$SCRIPTS_DESKTOPFILES_FOLDER" | while read -r filename; do
  app="$(basename "$SCRIPTS_DESKTOPFILES_FOLDER/$filename"  | awk -F'.' '{print $1}')";
  link="$(grep webapp "$SCRIPTS_DESKTOPFILES_FOLDER/$filename" | awk -F \' '{print $2}' )"
  if [[ "$link" != '' ]] && [[ "$app" != '' ]]; then
    echo "{ \"app\": \"$app\",\"link\": \"$link\"}"
  fi
done
}

if [[ ! -f "$SCRIPTS_LOCAL_FOLDER/sites.json" ]];then
  desktop_files_to_json > "$SCRIPTS_LOCAL_FOLDER/sites.json"
fi

# $1 wofi prompt
menu_cmd() {
  bemenu \
    -p "$1"\
    --hb "${COLORS[13]}"\
    --hf "${COLORS[0]}"\
    --ff "${COLORS[13]}"\
    --fb "${COLORS[0]}"\
    --tf "${COLORS[13]}"\
    --tb "${COLORS[0]}"\
    --nf "${COLORS[13]}"\
    --nb "${COLORS[0]}"\
    --hp "$BEMENU_PADDING"\
    --fn "$BEMENU_FONT"\
    -H "$BEMENU_HIGH"
  }

  app_cmd() {
    apps="$( print_bins )"
    apps="$(jq -r '.app' "$SCRIPTS_LOCAL_FOLDER/sites.json") $apps "
    chosen="$(  echo "$apps" | bemenu \
      -p "$1" \
      --hb "${COLORS[13]}"\
      --hf "${COLORS[0]}"\
      --ff "${COLORS[13]}"\
      --fb "${COLORS[0]}"\
      --tf "${COLORS[13]}"\
      --tb "${COLORS[0]}"\
      --nf "${COLORS[13]}"\
      --nb "${COLORS[0]}"\
      --hp "$BEMENU_PADDING"\
      --fn "$BEMENU_FONT"\
      -H "$BEMENU_HIGH")"

    if [[ ! -x "$( which "$chosen" > /dev/null 2>&1  )" ]];then
      site="$( jq -r "select(.app == \"$chosen\")| .link " "$SCRIPTS_LOCAL_FOLDER/sites.json" )"
      if [[ "$site" != '' ]];then
        launch_webapp "$site"
      fi
    else
      exec "$chosen"
    fi

  }
