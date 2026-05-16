-- THEME
require("mocha")

-- ENVIRONMENT VARIABLES
require("environment")


-- STARTUP APPLICATIONS
require("startup")


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
require("window-rules")

-- BINDINGS
require("bindings")

hl.config({
  animations = {
    enabled = true
  }
})

-- hl.animation({enabled = true, leaf = "workspaces", bezier = "default",style = "slidevert" })
-- hl.animation({enabled = true, leaf = "windows", bezier = "default", style = "popin" })
-- hl.animation({enabled = true, leaf = "layers", bezier = "default",style = "popin" })
-- hl.animation({enabled = true, leaf = "layersOut", bezier = "default",style = "fade" })

-- MONITORS
require("monitors")
