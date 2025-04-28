#!/usr/bin/bash
source "$HOME/.config/scripts/settings.sh"

#hyprpaper change background script
hyprpaper_switcher(){
  hyprctl hyprpaper preload "$1"
  hyprctl hyprpaper wallpaper eDP-1,"$1"
  hyprctl hyprpaper wallpaper HDMI-A-1,"$1"
  cat <<EOT > "$HOME/.config/hypr/hyprpaper.conf"
preload = $1
wallpaper = ,$1
splash = false
EOT
}

list_wallpaper(){
  find $THEMESWITCHER_FOLDERS -name '*.png' -or -name '*.jpg' -or -name '*.jpeg' | sed 's/^/wallpaper:/g'
}

run_wallpaper(){
  # run specific scripts based on current desktop
  case "$XDG_CURRENT_DESKTOP" in
    "Hyprland")
      hyprpaper_switcher "$1"
      killall -SIGUSR2 waybar
      ;;
    "sway")
      # TODO
    esac
}
