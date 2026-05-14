-- VARIABLES
local gamesWorkspace = 6
local mailWorkspace = 10
local discordWorkspace = 8
local searchWorkspace = 9
local floating_width = "(monitor_w*0.95)"
local floating_height = "(monitor_h*0.85)"

-- persistent workspaces
hl.workspace_rule({ workspace = 1,persistent = true})
hl.workspace_rule({ workspace = 9,persistent = true})

hl.window_rule({match = { class = "discord"}, workspace = discordWorkspace })

hl.window_rule({match = { class = "org.pulseaudio.pavucontrol"}, float = true, center = true, size = {floating_width,floating_height} })

hl.window_rule({match = { class = "blueman-manager"}, float = true, center = true, size = {floating_width,floating_height} })

hl.window_rule({match = { title = "(LXRAD Window)"}, float = true })

hl.window_rule({match = { class = "(lxappearance)"}, float = true })

hl.window_rule({match = { class = "(lightdm-gtk-greeter-settings)"}, float = true })

hl.window_rule({match = { class = "(org.gnome.Loupe)"}, float = true })

hl.window_rule({match = { class = ".*(transmission).*"}, float = true,center = true, size = {floating_width,floating_height} })

hl.window_rule({match = { class = "(nwg-look)"}, float = true,center = true,size = {floating_width,floating_height} })

hl.window_rule({match = { class = "org.gnome.Nautilus"}, float = true, center = true,size = {floating_width,floating_height} })

hl.window_rule({match = { class = "([tT]hunar)"}, float = true, center = true, size = {floating_width,floating_height} })

hl.window_rule({match = { class = "nm-connection-editor"}, float = true, center = true, size = {floating_width,floating_height} })

hl.window_rule({match = { title = ".*ImageMagick.*"}, float = true, center = true, size = {floating_width,floating_height} })

hl.window_rule({match = { class = "([bhnv]+top)"}, float = true, center = true, size = {floating_width,floating_height} })

hl.window_rule({match = { class = "(ranger)"}, float = true, center = true, size = {floating_width,floating_height} })

hl.window_rule({match = { class = ".*(Lollypop).*"}, float = true, center = true, size = {floating_width,floating_height} })

hl.window_rule({match = { class = ".*(Microsoft Teams).*"}, float = true, center = true, size = {floating_width,floating_height}, workspace = "special" })

hl.window_rule({match = { title = "(LRCGET)"}, float = true, center = true, size = {floating_width,floating_height} })

hl.window_rule({match = { class = "Picard", title = "(MusicBrainz Picard)" }, float = true, center = true, size = {floating_width,floating_height} })
hl.window_rule({match = { class = "Python"}, float = true, center = true, size = {floating_width,floating_height} })

hl.window_rule({match = { class = "filezilla"}, float = true, center = true, size = {floating_width,floating_height} })

-- floating terminal window rules
hl.window_rule({match = { class = "floating"}, center = true,float = true, size = {floating_width,floating_height} })

hl.window_rule({match = { title = "Picture-in-Picture"}, float = true, size = {floating_width,floating_height} })

hl.window_rule({match = { class = "(Supersonic)"}, float = true, center = true,size = {floating_width,floating_height} })

hl.window_rule({match = { class = "(GalaxyBudsClient)"}, float = true, center = true, size = {floating_width,floating_height} })

hl.window_rule({match = { class = "(mpv)"}, float = true, center = true, size = {floating_width,floating_height} })

hl.window_rule({match = { class = ".*(keepassxc).*"}, float = true,center = true, size = {floating_width,floating_height} })

hl.window_rule({match = { class = ".*(libre).*"}, tile = true })

hl.window_rule({match = { title = "(Save As)"}, float = true,center = true,size = {floating_width,floating_height} })
hl.window_rule({match = { title = "(.*Open File.*)"}, float = true, center = true,size = {floating_width,floating_height} })

hl.window_rule({match = { class = "org.telegram.desktop"}, float = true, center = true, size = {floating_width,floating_height} })

hl.window_rule({match = { class = "(vlc)"}, float = true })
hl.window_rule({match = { title = "(Current Media Information)"}, float = true })

hl.window_rule({match = { class = "(.*gnome-pomodoro.*)"}, float = true,center = true, size = {floating_width,floating_height} })

hl.window_rule({match = { class = "(org.strawberrymusicplayer.strawberry)"}, float = true, center = true })
hl.window_rule({match = { class = "(org.strawberrymusicplayer.strawberry)", title = ".*(Settings — Strawberry Music Player).*" }, float = true,center = true, size = {floating_width,floating_height} })
hl.window_rule({match = { class = "(org.strawberrymusicplayer.strawberry)",title = ".*(Sponsoring Strawberry — Strawberry Music Player).*"}, float = true,center = true })

hl.window_rule({match = { class = "(org.mozilla.Thunderbird)"}, workspace = mailWorkspace, silent = true })
hl.window_rule({match = { class = "(org.mozilla.Thunderbird)", title  = ".*(Write).*"}, float = true,center = true, size = {floating_width,floating_height}, })
hl.window_rule({match = { class = "(org.mozilla.Thunderbird)", title = ".*(Reminder).*"}, float = true,center = true, size = {floating_width,floating_height} })

hl.window_rule({match = { class = "(firefox)"}, workspace = searchWorkspace })
hl.window_rule({match = { class = ".*(firefox).*", title = ".*(Library).*"}, float = true,center = true,size = {floating_width,floating_height} })

hl.window_rule({match = { class = ".*(seahorse).*"}, float = true,center = true,size = {floating_width,floating_height} })

hl.window_rule({match = { title = "(PCSX2.*Settings.*)"}, float = true,center = true })

hl.window_rule({match = { class = ".*(heroic).*"}, float = true, center = true, size = {floating_width,floating_height} })

hl.window_rule({match = { class = ".*RetroArch.*"}, fullscreen = true, workspace = gamesWorkspace })

hl.window_rule({match = { class = "edopro"}, workspace = gamesWorkspace })

hl.window_rule({match = { class = "([Ss]uper[Tt]ux[Kk]art)"}, tile = true, workspace = gamesWorkspace })

hl.window_rule({match = { class = "steam", title = "Steam"}, float = true, center = true, size = {floating_width,floating_height} })
hl.window_rule({match = { class = "xdg-desktop-portal-gtk"}, float = true, center = true, size = {floating_width,floating_height} })
hl.window_rule({match = { class = "steam"}, float = true })

-- move games to workspace gamesWorkspace
hl.window_rule({match = { class = "(steam_app_[0-9]+)"}, float = false, fullscreen = true, workspace = gamesWorkspace })
hl.window_rule({match = { initial_class = "VampireSurvivors.exe"}, float = false, fullscreen = true, workspace = gamesWorkspace })
hl.window_rule({match = { class = "(Minecraft Launcher)"}, float = false, fullscreen = true, workspace = gamesWorkspace })
hl.window_rule({match = { initial_class = "Godot"}, float = false, fullscreen = true, workspace = gamesWorkspace })
