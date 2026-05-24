-- THEME
require("mocha")

-- ENVIRONMENT VARIABLES
require("environment")

-- STARTUP APPLICATIONS
require("startup")

hl.config( {
  input  ={
    kb_layout = "us",
    follow_mouse = 1,
    sensitivity = -0.25,
  }
})

hl.config( {
  general  = {
    gaps_in = 2,
    gaps_out = 2,
    border_size = 3,
    layout = "dwindle",
    allow_tearing = false,
    col = {
    active_border = { colors = { Lavender} },
    inactive_border = {colors = {Blue} },
  }
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
require("window-rules")

-- BINDINGS
require("bindings")

-- BINDINGS
require("animations")

-- MONITORS
require("monitors")
