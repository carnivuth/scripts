local bin_directory = "~/.local/bin/"
-- possible values
-- menu_backend="fzf --prompt"
-- menu_backend="wofi -d --show dmenu -p"
-- menu_backend="fuzzel  -d -p"
-- menu_backend="rofi -dmenu -p"
local menu_backend = "bemenu -p"
local step = 100

-- open terminal
hl.bind("SUPER + Return", hl.dsp.exec_cmd("alacritty"))

-- floating terminal
hl.bind("SUPER + + SHIFT + Return", hl.dsp.exec_cmd("alacritty --class floating"))

-- audio controls
hl.bind("XF86AudioMute" , hl.dsp.exec_cmd("pamixer -t"))
hl.bind("XF86AudioRaiseVolume", hl.dsp.exec_cmd("pamixer -i 5"))
hl.bind("XF86AudioLowerVolume", hl.dsp.exec_cmd("pamixer -d 5"))

-- Media player controls
hl.bind("XF86AudioPlay", hl.dsp.exec_cmd("playerctl play-pause"))
-- hl.bind("SUPER + bracketleft", hl.dsp.exec_cmd("playerctl previous"))
-- hl.bind("SUPER + bracketright,", hl.dsp.exec_cmd("playerctl next"))

-- brightness controls
hl.bind("XF86MonBrightnessUp", hl.dsp.exec_cmd("brightnessctl -d intel_blacklight s +10%"))
hl.bind("XF86MonBrightnessDown", hl.dsp.exec_cmd("brightnessctl -d intel_blacklight s 10%-"))
hl.bind("SUPER + up", hl.dsp.exec_cmd("brightnessctl s +10%"))
hl.bind("SUPER + down", hl.dsp.exec_cmd("brightnessctl s 10%-"))

-- screenshots
hl.bind("SUPER + SHIFT + Print" , hl.dsp.exec_cmd("hyprshot --clipboard-only -m region"))
hl.bind("SUPER + Print", hl.dsp.exec_cmd("hyprshot --clipboard-only -m active -m window"))
hl.bind("Print", hl.dsp.exec_cmd("hyprshot --clipboard-only -m active -m output"))

-- screenRecording
hl.bind("SUPER + R", hl.dsp.exec_cmd(bin_directory .. "/recorder.sh toggle"))

-- launch hyprpicker
hl.bind("SUPER + Y", hl.dsp.exec_cmd("hyprpicker -a"))

-- toggle caffeine mode (kill idle daemon)
hl.bind("SUPER + SHIFT + C", hl.dsp.exec_cmd(bin_directory  .. "/caffeine.sh toggle"))

-- open blueman
hl.bind("SUPER + B", hl.dsp.exec_cmd("blueman-manager"))

-- open pavucontrol
hl.bind("SUPER + A", hl.dsp.exec_cmd("pavucontrol"))

-- open ranger
hl.bind("SUPER + SHIFT + E", hl.dsp.exec_cmd("gio open ~"))

-- launch telegram
hl.bind("SUPER + T", hl.dsp.exec_cmd("Telegram  --enable-features=UseOzonePlatform --ozone-platform=wayland"))

-- open main menu
hl.bind("SUPER + D", hl.dsp.exec_cmd(bin_directory .. "/L.sh -b " .. menu_backend .. " app site network btdevice system"))

-- music menu
hl.bind("SUPER + M", hl.dsp.exec_cmd(bin_directory .. "/L.sh -b " .. menu_backend .. " album playlist artist cd"))
hl.bind("SUPER + SHIFT + M", hl.dsp.exec_cmd(bin_directory .. "/player.sh toggle"))
hl.bind("SUPER + CTRL + M", hl.dsp.exec_cmd(bin_directory .. "/player.sh quit"))

-- github menus
hl.bind("SUPER + G", hl.dsp.exec_cmd(bin_directory .. "/L.sh -b " .. menu_backend .. " ghrepo"))
hl.bind("SUPER + SHIFT + G", hl.dsp.exec_cmd(bin_directory .. "/L.sh -b " .. menu_backend .. " ghpage"))

-- open clipboard history menu
hl.bind("SUPER + C", hl.dsp.exec_cmd(bin_directory .. "/L.sh -b " .. menu_backend .. " clipboard"))

-- open fileopener menu
hl.bind("SUPER + E", hl.dsp.exec_cmd(bin_directory .."/L.sh -b ".. menu_backend .." file"))

-- open fileopener menu
hl.bind("SUPER + N", hl.dsp.exec_cmd(bin_directory .."/L.sh -b ".. menu_backend .." note"))

-- kill window
hl.bind("SUPER + Q", hl.dsp.window.kill())

-- toggle floating for a specific window
hl.bind("SUPER + Space", hl.dsp.window.float())

-- toggle window fullscreen
hl.bind("SUPER + F", hl.dsp.window.fullscreen({mode = "fullscreen",action = "toggle"}))

-- cycle windows in a workspace
hl.bind("SUPER + L", hl.dsp.focus({direction = "r"}))
hl.bind("SUPER + H", hl.dsp.focus({direction = "l"}))
hl.bind("SUPER + K", hl.dsp.focus({direction = "u"}))
hl.bind("SUPER + J", hl.dsp.focus({direction = "d"}))

-- Move focused window
hl.bind("SUPER + H", hl.dsp.window.move({ direction = "l"}))
hl.bind("SUPER + L", hl.dsp.window.move({ direction = "r"}))
hl.bind("SUPER + K", hl.dsp.window.move({ direction = "u"}))
hl.bind("SUPER + J", hl.dsp.window.move({ direction = "d"}))

-- resize windows
-- hl.bind("SUPER + L", hl.dsp.window.resize({step,0}))
-- hl.bind("SUPER + H", hl.dsp.window.resize({-step,0}))
-- hl.bind("SUPER + K", hl.dsp.window.resize({0,-step}))
-- hl.bind("SUPER + J", hl.dsp.window.resize({0,step}))

-- Move/resize windows with SUPER + + LMB/RMB and dragging
hl.bind("ALT + mouse:272", hl.dsp.window.drag(), { mouse = true })
hl.bind("ALT + mouse:273", hl.dsp.window.resize(), { mouse = true })

-- Switch workspaces with SUPER + + [0-9]
hl.bind("SUPER + 1", hl.dsp.focus({workspace = "1"}))
hl.bind("SUPER + 2", hl.dsp.focus({workspace = "2"}))
hl.bind("SUPER + 3", hl.dsp.focus({workspace = "3"}))
hl.bind("SUPER + 4", hl.dsp.focus({workspace = "4"}))
hl.bind("SUPER + 5", hl.dsp.focus({workspace = "5"}))
hl.bind("SUPER + 6", hl.dsp.focus({workspace = "6"}))
hl.bind("SUPER + 7", hl.dsp.focus({workspace = "7"}))
hl.bind("SUPER + 8", hl.dsp.focus({workspace = "8"}))
hl.bind("SUPER + 9", hl.dsp.focus({workspace = "9"}))
hl.bind("SUPER + 0", hl.dsp.focus({workspace = "10"}))

-- Move active window to a workspace with SUPER + + SHIFT + [0-9]
hl.bind("SUPER + 1", hl.dsp.window.move({ workspace = "1", follow = true}))
hl.bind("SUPER + 2", hl.dsp.window.move({ workspace = "2", follow = true}))
hl.bind("SUPER + 3", hl.dsp.window.move({ workspace = "3", follow = true}))
hl.bind("SUPER + 4", hl.dsp.window.move({ workspace = "4", follow = true}))
hl.bind("SUPER + 5", hl.dsp.window.move({ workspace = "5", follow = true}))
hl.bind("SUPER + 6", hl.dsp.window.move({ workspace = "6", follow = true}))
hl.bind("SUPER + 7", hl.dsp.window.move({ workspace = "7", follow = true}))
hl.bind("SUPER + 8", hl.dsp.window.move({ workspace = "8", follow = true}))
hl.bind("SUPER + 9", hl.dsp.window.move({ workspace = "9", follow = true}))
hl.bind("SUPER + 0", hl.dsp.window.move({ workspace = "10", follow = true}))
