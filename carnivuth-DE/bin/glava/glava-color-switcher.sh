#!/bin/bash
source "$HOME/scripts/settings.sh"
source "$SCRIPTS_LIBS_FOLDER/get_wal_color.sh"
get_wal_color
sed -i "s/#define COLOR ( #.* \* GRADIENT)/#define COLOR ( ${COLORS[13]} \* GRADIENT)/g" "$HOME/.config/glava/bars.glsl" 
killall glava  
glava --desktop &
