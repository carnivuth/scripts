-- THEME
require(os.getenv("HOME") .. "/.config/hypr/mocha.lua")

-- ENVIRONMENT VARIABLES
require(os.getenv("HOME") .. "/.config/hypr/environment.lua")

-- HYPRLAND VARIABLES

-- possible values
-- menu_backend="fzf --prompt"
-- menu_backend="wofi -d --show dmenu -p"
-- menu_backend="fuzzel  -d -p"
-- menu_backend="rofi -dmenu -p"

-- STARTUP APPLICATIONS
require(os.getenv("HOME") .. "/.config/hypr/startup.lua")


hl.config( {
  input  ={
    kb_layout = us,
    follow_mouse = 1,
    sensitivity = -0.25,
  }
})

hl.config( {
  general  = {
    gaps_in = 2,
    gaps_out = 2,
    border_size = 1,
    layout = "dwindle",
    allow_tearing = false,
    active_border = { colors = { lavender, blue } },
    inactive_border = { color  = lavender},
  }
})

hl.config({
  decoration  = {
    rounding = 5,
    blur  = {
      enabled = true,
      size = 3,
      passes = 1,
    }
  }
})

hl.config({
  misc = {
    force_default_wallpaper = 0
  }
})

hl.config({
  xwayland  = {
    force_zero_scaling = true
  }
})

-- WINDOW RULES
require(os.getenv("HOME") .. "/.config/hypr/window-rules.lua")

-- BINDINGS
require(os.getenv("HOME") .. "/.config/hypr/bindings.lua")

-- ANIMATIONS
require(os.getenv("HOME") .. "/.config/hypr/animations.lua")

hl.config({
  animations = {
    enabled = true
  }
})

hl.animation({leaf = "workspaces", bezier = "default",style = "slidevert" })
hl.animation({leaf = "windows", bezier = "default", style = "popin" })
hl.animation({leaf = "layers", bezier = "default",style = "popin" })
hl.animation({leaf = "layersOut", bezier = "default",style = "fade" })

-- MONITORS
require(os.getenv("HOME") .. "/.config/hypr/monitors.lua")
