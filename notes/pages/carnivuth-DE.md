# CARNIVUTH-DE

 my personal Desktop customization of arch linux x11 desktop session

## MAIN CORE SOFTWARE

| type                | application |
| ------------------- | ----------- |
| WM                  | i3          |
| menu launcher       | rofi        |
| terminal            | alacritty   |
| compositor          | picom       |
| notification daemon | dunst       |
| bar                 | polybar     |

## INSTALLATION

run `carnivuth-DE/install.sh` to install software dependencies with pacman and copy config files to `$HOME/.config` folder **this will overwrite existing configs**

the installation script will create also some default [config files](ARRAY_DATA_FILE.md) for some applets

## CONFIGURATION 

some rofi scripts use a `folder.sh` file placed under the applet folder in `rofi/<applet-name>` to load specific configuration parameter, the format is defined [here](ARRAY_DATA_FILE.md)

```bash
#!/bin/bash
ARRAY=("/some/path" "$HOME/some/other/path")

```


## ROFI APPLETS
 
i made a lot of rofi applets for day to day use:

-  launch application script
-  network menu script
-  open project with different ides
-  power menu applet
-  quicklinks applet
-  quicksearch applet
-  music player applet
-  file explorer with history applet
-  obsidian menu for opening vaults
-  github repo viewer menu

 ### STYLE  
 
the applets accept a parameter for the configuration file to load for example

```bash
./scripts/carnivuth-DE/rofi/musicplayer/musicplayer.sh default
```

will try to load 

`$HOME/.config/rofi/musicplayer/default.rasi`

with the following file as fallback

`$HOME/.config/rofi/default/default.rasi`

the rofi config folder structure must be as follow

```bash
$HOME/.config
    |
    ---rofi
        |
        --- default
            |
            --- default-center.rasi
            |
            --- default-line-bottom.rasi
            |
            --- default-line.rasi
        |
        --- <applet folder name>
            |
            ---"style1"
            |
            ---"style2"
            |
            ---"....."
```

the environment is configured to use pywal for setting the theme and themes in `$HOME/.config/rofi/default` import `$HOME/.cache/wal/colors-rofi-dark.rasi` so it will brake if this file is not present
