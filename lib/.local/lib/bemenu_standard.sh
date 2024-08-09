#!/bin/bash
source "$HOME/.config/settings.sh"
source "$SCRIPTS_LIB_FOLDER/get_wal_color.sh"

get_wal_color
BEMENU_HIGH=21
BEMENU_PADDING=10
BEMENU_FONT='JetBrainsMono Nerd Font,JetBrainsMono NF:style=ExtraBold 9'

menu_theme_setup(){
  echo "" > "/dev/null"
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
    --hp "$BEMENU_PADDING"\
    --fn "$BEMENU_FONT"\
    -H "$BEMENU_HIGH"
  }
