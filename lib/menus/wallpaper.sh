#!/usr/bin/bash
source "$HOME/.config/scripts/settings.sh"

list_wallpaper(){
  find $THEMESWITCHER_FOLDERS -name '*.png' -or -name '*.jpg' -or -name '*.jpeg' | sed 's/^/wallpaper:/g'
}

run_wallpaper(){
  # run specific scripts based on current desktop
  case "$XDG_CURRENT_DESKTOP" in
    "Hyprland")
      hyprctl hyprpaper reload ,"$1"
      killall -SIGUSR2 waybar
      ;;
    "sway")
      # TODO
    esac
}
