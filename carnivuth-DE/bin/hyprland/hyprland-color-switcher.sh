#!/bin/bash
source "$HOME/scripts/settings.sh"
source "$SCRIPTS_LIBS_FOLDER/get_wal_color.sh"
get_wal_color

sed -i "s/col.active_border = .*/col.active_border = rgb(${COLORS[1]}) rgb(${COLORS[13]}) 45deg/g" "$HOME/.config/hypr/border.conf" 
sed -i "s/col.inactive_border = .*/col.inactive_border = rgb(${COLORS[13]})/g" "$HOME/.config/hypr/border.conf" 
sed -i "s/#//g" "$HOME/.config/hypr/border.conf" 
