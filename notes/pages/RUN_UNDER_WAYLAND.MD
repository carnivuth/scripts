# RUN UNDER WAYLAND

## vaultlauncher 

configure obsidian.desktop as follow:

```bash
cp /usr/share/applications/obsidian.desktop .local/share/applications/
```

inside `.local/share/applications/obsidian.desktop`:

```bash
[Desktop Entry]
Name=Obsidian
Exec=/usr/bin/obsidian --enable-features=UseOzonePlatform --ozone-platform=wayland -platform wayland %U
Terminal=false
Type=Application
Icon=obsidian
StartupWMClass=obsidian
Comment=Obsidian
MimeType=x-scheme-handler/obsidian;
Categories=Office;
```

## launchprojects

add options, it can be done with a file `.config/code-flags.conf`

```bash
--enable-features=UseOzonePlatform,WaylandWindowDecorations
--ozone-platform=wayland
```

for a better look add in `'.config/Code - OSS/User/settings.json'`

```bash
"window.titleBarStyle": "custom",
```

## discord

fixed with website and desktop-file

## telegram 

set experimental settings highdpi scaling


## LOCK SCREEN SLEEP LIDCLOSE AND LOGIN MANAGER

install `cage swaylock swayidle greetd greetd-regreet`

configure greetd in `/etc/greetd/config.toml`

```toml
[terminal]
# The VT to run the greeter on. Can be "next", "current" or a number
# designating the VT.
vt = 1

# The default session, also known as the greeter.
[default_session]

# `agreety` is the bundled agetty/login-lookalike. You can replace `/bin/sh`
# with whatever you want started, such as `sway`.
#command = "agreety --cmd Hyprland"
command = "cage --  regreet"
#command = "cage gtkgreet "

# The user to run the command as. The privileges this user must have depends
# on the greeter. A graphical greeter may for example require the user to be
# in the `video` group.
user = "greeter"
```

configure regreet in `/etc/greetd/regreet.toml`

```toml
# SPDX-FileCopyrightText: 2022 Harish Rajagopal <harish.rajagopals@gmail.com>
#
# SPDX-License-Identifier: GPL-3.0-or-later

[background]
# Path to the background image
path = "/usr/share/hyprland/wall_anime_4K.png"

# How the background image covers the screen if the aspect ratio doesn't match
# Available values: "Fill", "Contain", "Cover", "ScaleDown"
# Refer to: https://docs.gtk.org/gtk4/enum.ContentFit.html
# NOTE: This is ignored if ReGreet isn't compiled with GTK v4.8 support.
fit = "Contain"

# The entries defined in this section will be passed to the session as environment variables when it is started
[env]
ENV_VARIABLE = "value"

[GTK]
# Whether to use the dark theme
application_prefer_dark_theme = true

# Cursor theme name
cursor_theme_name = "Adwaita"

# Font name and size
font_name = "Cantarell 16"

# Icon theme name
icon_theme_name = "Papirus"

# GTK theme name
theme_name = "Adwaita"

[commands]
# The command used to reboot the system
reboot = [ "systemctl", "reboot" ]

# The command used to shut down the system
poweroff = [ "systemctl", "poweroff" ]
```





