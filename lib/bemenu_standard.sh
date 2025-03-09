#!/bin/bash
source "$HOME/.config/scripts/settings.sh"

BEMENU_HIGH=21
BEMENU_BORDER=1
BEMENU_PADDING=10
BEMENU_FONT='JetBrainsMono Nerd Font,JetBrainsMono NF:style=ExtraBold 9'

menu_theme_setup(){
  echo "" > "/dev/null"
}

# $1 wofi prompt
menu_cmd() {
  bemenu \
    -p "$1"\
    --fb "#24273a"\
    --ff "#cad3f5"\
    --nb "#24273a"\
    --nf "#cad3f5"\
    --tb "#24273a"\
    --hb "#24273a"\
    --tf "#ed8796"\
    --hf "#eed49f"\
    --af "#cad3f5"\
    --ab "#24273a"\
    --bdr "#b4befe"\
    --hp "$BEMENU_PADDING"\
    -B "$BEMENU_BORDER"\
    --fn "$BEMENU_FONT"\
    -H "$BEMENU_HIGH"
    #--hb "${COLORS[13]}"\
    #--hf "${COLORS[0]}"\
    #--ff "${COLORS[13]}"\
    #--fb "${COLORS[0]}"\
    #--tf "${COLORS[13]}"\
    #--tb "${COLORS[0]}"\
    #--nf "${COLORS[13]}"\
    #--nb "${COLORS[0]}"\
  }
