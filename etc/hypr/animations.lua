hl.config({
  animations = {
    enabled = false
  }
})

hl.animation({enabled = true, speed = 5, leaf = "workspaces", bezier = "default",style = "slidevert" })
hl.animation({enabled = true, speed = 5, leaf = "windows", bezier = "default", style = "popin" })
hl.animation({enabled = true, speed = 5, leaf = "layers", bezier = "default",style = "popin" })
hl.animation({enabled = true, speed = 5, leaf = "layersOut", bezier = "default",style = "fade" })
