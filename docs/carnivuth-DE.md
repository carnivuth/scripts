# CARNIVUTH-DE
- my personal Desktop customization of arch linux x11 desktop session
## MAIN CORE SOFTWARE
| type                | application |
|---------------------|-------------|
| WM                  | i3          |
| menu launcher       | rofi        |
| terminal            | alacritty   |
| compositor          | picom       |
| notification daemon | dunst       |
| bar                 | polybar     |

## INSTALLATION
- run `carnivuth-DE/install.sh` to install software dependencies with pacman and copy config files to `$HOME/.config` folder **this will overwrite existing configs**


## ROFI APPLETS
 - i made a lot of rofi applets for day to day use
 ### STYLE  
- the rofi config folder structure must be as follow

```
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

- script under `carnivuth-DE/rofi` folder are configure to use the `default-<config-name>.rasi` file if there isn't a config file with the same name in the `<applet-folder-name>` folder

- the environment is configured to use pywal for setting the theme