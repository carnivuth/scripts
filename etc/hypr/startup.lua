
gestures {
}

hl.on("hyprland.start", function ()
  hl.exec_cmd(os.getenv("TERM"))
  hl.exec_cmd("hyprpaper")
  hl.exec_cmd("udiskie")
  hl.exec_cmd("waybar")
  hl.exec_cmd("nm-applet")
  hl.exec_cmd("blueman-applet")
  hl.exec_cmd("dunst")
  hl.exec_cmd("thunderbird")
  hl.exec_cmd("nextcloud")
  hl.exec_cmd("Telegram -startintray")
  hl.exec_cmd("bw sync")
  hl.exec_cmd("wl-paste --watch cliphist store")
  hl.exec_cmd("systemctl --user start hyprpolkitagent")
end)
