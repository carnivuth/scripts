#!/usr/bin/bash

source "$HOME/.config/scripts/settings.sh"
source "$SCRIPTS_LIB_FOLDER/get_wal_color.sh"

dunst_switcher(){
  get_wal_color
  sed -i "s/background = \"#.*\"/background = \"${COLORS[13]}\"/g" "$HOME/.config/dunst/dunstrc"
  sed -i "s/forground = \"#.*\"/foreground = \"${COLORS[0]}\"/g" "$HOME/.config/dunst/dunstrc"
  sed -i "s/frame_color = \"#.*\"/frame_color = \"${COLORS[1]}\"/g" "$HOME/.config/dunst/dunstrc"
  killall dunst
  dunst &
}

hyprland_switcher(){
  get_wal_color
  cat <<EOT > "$HOME/.config/hypr/border.conf"
general {
  col.active_border = rgb(${COLORS[1]}) rgb(${COLORS[13]}) 45deg
  col.inactive_border = rgb(${COLORS[13]})
}
EOT
}

hyprland_switcher
dunst_switcher
