# SCRIPTS 
personal desktop customizations (xorg and wayland) + some usefull scripts and tools for everyday use

## I3 SETUP
![](./notes/assets/demo.gif)

## CONTENTS

The repo contains dotfiles for both xorg(i3) desktop and wayland(hyprland)  

### carnivuth-DE

this folder contains:

- dotfiles both for i3 and hyprland setup
- applets for keyboard shortcut and quick access to some usefull tools
- some common binaries used by dotfiles and applets

### DESKTOP FILES

desktop files for some websites and applications

### SYSTEMD UNITS

some systemd timers for everyday use

### UTILITIES
 
some utilities scripts to speedup some operations and make everyday sysadmin tasks less painful

## SUPPORTED SYSTEMS

the repo is tested on arch linux, it should work on other distros if you install the [required dependencies](./notes/pages/DEPENDENCIES.md)

## INSTALLATION

to install :

- clone the repository on the `$HOME` directory (it must be under `$HOME` directory)

- cd `$HOME/scripts`

- `./install.sh`

there is an installation script for every functionality called `install.sh` and a global interactive  install script also called `install.sh` 

## CONFIGURATION

the global `install.sh` requires a `settings.sh` file that is imported in every script, it contains:

- some path variables used by scripts to create logs files etc...

- default rofi theme configuration for the menus

- some configuration variables for applets and utilities

feel free to customize these values as you like 😉
