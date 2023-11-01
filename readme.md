# SCRIPTS 
personal desktop customizations + some usefull script and tools for everyday use

![](./notes/assets/demo.gif)

## CONTENTS

### [CARNIVUTH DE](./notes/pages/carnivuth-DE.md)

personal i3 customization and scripts for xorg graphical session

### [DESKTOP FILES](./notes/pages/DESKTOP-FILES.md)

desktop file for some websites and applications

### [SYSTEMD UNITS](./notes/pages/systemd-units.md)

some systemd timers for everyday use

### [UTILITIES](./notes/pages/UTILITIES.md)  
 
some utilities scripts to speedup some operation and make everyday sysadmin operations less painfull

## SUPPORTED SYSTEMS

the repo is tested on arch linux, it should work in other distros if you install the [required dependencies](./notes/pages/DEPENDENCIES.md)

## INSTALLATION

to install :

- clone the repository on the `$HOME` directory (it must be under `$HOME` directory)

- cd `$HOME/scripts`

- `./install.sh`

there is a installation script for every functionality called `install.sh` and a global interactive  install script also called `install.sh` 

## CONFIGURATION

the global `install.sh` creates a `settings.sh` file that is imported in every script, it contains:

- some path variables used by scripts to create logs files etc...

- default rofi theme configuration for the menus

- flameshot folder for screenshots

- some gtk bookmarks for thunar to display

- screen names ( output of `xrandr` ) for dual monitor setup 

it also create default [configuration files for single scripts](./notes/pages/ARRAY_DATA_FILE.md) that need them

feel free to customize this values as you like 😉