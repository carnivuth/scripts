# SCRIPTS

Personal dotfiles (wayland configuration) + some useful scripts and tools for everyday use

## Features

The repo contains a bunch of scripts and utilities for day to day use, it's almost as a fully desktop environment (at least for my use case 😅)

### Systemd units and timers

- backup script using `borg` and `rsync`
- github synchronization utility
- system updates notification daemon
- battery manager script
- `newsboat` notification daemon
- `ntfy` notification client
- mount volumes with `rclone` utility
- daemon for weather forecasts

### The `L.sh` Menu

It's a script that uses bemenu and other menu backends to print a list of options from different sources and run an action for a selected item given the type item, for example given an item of type site the action will be to open the given site on the browser, every item source define it's own item type, some of the implemented sources are

- Bluetooth devices
- clipboard content
- github repo
- github ghpages
- `kanshi` profiles
- applications
- websites
- nmcli networks
- obsidian vaults
- pass password manager content
- power options
- files
- steam games

### General command line utilities

- utility for wireguard vpn connection
- utility for screen recording
- obsidian vault manager script
- utilities for cleanup of docker/vagrant/ollama data
- utility for managing audio/video file conversion and common operations
- caffeine mode
- git common utilities

## Installation

To install:

- clone the repository

```bash
git clone https://github.com/carnivuth/scripts "$HOME/scripts"
```

- run the installation script (**arch linux only**)

```
cd $HOME/scripts && ./scripts.sh
```

### Configure greeter

The installation scripts install greetd as a login daemon and hyprland and sway as window managers, configuration is done for both the environments (hyprland is more updated since is my default one), to set one of them as default program after login change `/etc/greetd/config.toml` as follows

```toml
[terminal]

vt = 1

[default_session]

# run hyprland on login
#command = "agreety --cmd /bin/Hyprland"

# run sway on login
#command = "agreety --cmd /bin/sway"

# login with tuigreet
command = "tuigreet --remember --remember-user-session"

user = "greeter"
```

To unlock the gnome keyring at default set this on the `/etc/pam.d/greetd` file

```
#%PAM-1.0

auth       required     pam_securetty.so
auth       requisite    pam_nologin.so
auth       include      system-local-login
auth       optional     pam_gnome_keyring.so
account    include      system-local-login
session    include      system-local-login
session    optional     pam_gnome_keyring.so auto_start
```

### Configure updates

The installation scripts creates a git hook that runs on merge event and execute the `./scripts.sh` installation script, to avoid input password for pacman configure sudo as follows

```bash
echo "$USER ALL=(ALL:ALL) NOPASSWD:/bin/pacman" > "/etc/sudoers.d/$USER"
```

### How it works

This will install a list of default packages and link the configuration files under the right folder using [stow](https://www.gnu.org/software/stow/), for reference

```mermaid
flowchart LR
A[etc] --> E[~/.config]
B[bin] --> F[~/.local/bin]
C[lib] --> G[~/.local/lib]
D[systemd] --> H[~/.config/systemd/user]
```

In order to add aliases and set path the following line is added to `~/.bashrc`

```bash
source $HOME/.config/scripts/bash_integration.sh
```

### Firefox

In order to configure firefox additional steps are required

- enable this firefox options inside `about:config` section

```
toolkit.legacyUserProfileCustomizations.stylesheets
layers.acceleration.force-enabled
gfx.webrender.all
gfx.webrender.enabled
layout.css.backdrop-filter.enabled
svg.context-properties.content.enabled
```

- link firefox configuration file to the profile directory

```bash
mkdir -p ~/.mozilla/firefox/<profiledir>/chrome
ln -sf firefox/userChrome.css ~/.mozilla/firefox/<profiledir>/chrome
```

- install sidebery extension end import `firefox/sidebary.json`

### Thunderbird

In order to add thunderbird catppuccin theme follow these steps

- clone theme [repo](https://github.com/catppuccin/thunderbird)

```bash
cd /tmp
git clone https://github.com/catppuccin/thunderbird
```

- install theme from the thunderbird UI

## Configuration

Configuration is done in the `$HOME/.config/settings.sh` file, see the `.sample` (version for reference)

## Supported systems

The repo is tested and used on arch linux, it should work on other distros if you install the dependencies listed in the `./scripts.sh` script and manually link dotfiles, testing is done trough the use of a archlinux vagrant box

## Development documentation

>[!WARNING]
> this documentation is for development only

### Systemd templates scripts

Some tools need to run as daemons and monitor folders such as [the script for nextcloud synchronization](bin/nxtcdd.sh) and the [folder manager](bin/folder_manager.sh), this scripts are implemented using systemd template units functionality to spawn multiple instances of the daemon and manages different directories:

```mermaid
flowchart LR
A[(nextcloud folders:<br>Documents<br>Pictures)]
B[nxtcdd.service]
C[nxtcdd@Documents]
D[nxtcdd.sh start -d Documents]
E[nxtcdd@Pictures]
F[nxtcdd.sh start -d Pictures]
A --> B -- spawns --> C & E
C -- runs --> D
E -- runs --> F
```

### The `L.sh` script

The menu is structured as follows, the [L script](bin/L.sh) load sources based on filters given as parameters an get data from each sources in parallel, then it prints the menu and run the action specified by the item type

```mermaid
sequenceDiagram
participant L
L ->> L: source all scripts in lib/menus based on filters
L ->> L: print menu
L ->> L: execute run_<type> function of the selected item type
```

The single source is implemented as a script that is named after the defined item type (*for example the site resource is implemented in the `site.sh` script*) the source script must obey to the following interface:

>lib/menus/mysource.sh
```bash
#!/bin/bash
source "$HOME/.config/scripts/settings.sh"

# this function  must print the elements to select from in the format type:<DATA>, to add type use sed 's/^/file:/g'
list_mysource(){ }

# this function is invoked when the element is selected with it as first argument
run_file(){ }
```
