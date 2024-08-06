#!/bin/bash
source "$HOME/scripts/settings.sh"
source "$SCRIPTS_LIB_FOLDER/get_wal_color.sh"
get_wal_color
BEMENU_HIGH=21

menu_theme_setup(){
  echo "setup complete"
}

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
      -H "$BEMENU_HIGH"
  }

  app_cmd() {
    bemenu-run \
      -p "$1" \
    --hb "${COLORS[13]}"\
    --hf "${COLORS[0]}"\
    --ff "${COLORS[13]}"\
    --fb "${COLORS[0]}"\
    --tf "${COLORS[13]}"\
    --tb "${COLORS[0]}"\
    --nf "${COLORS[13]}"\
    --nb "${COLORS[0]}"\
      -H "$BEMENU_HIGH"
    }
