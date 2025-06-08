---
date: '2025-06-07T10:48:07+02:00'
draft: false
title: 'Installation'
weight: 10
series: ["Documentation"]
series_order: 1
---

In order to install the repository run the following commands:

- clone the repository, it's recommended to clone it under the home user directory (*`$HOME`*)

```bash
git clone https://github.com/carnivuth/scripts "$HOME/scripts"
```

- run the installation script (**arch linux only**)

```
cd $HOME/scripts
./scripts.sh
# configure system wide options
./scripts.sh system
```

## What does the installation script do

The scripts will link the repository content (e.g. bash scripts, systemd units,dotfiles and general content) using stow following this file structure

{{< mermaid >}}
flowchart LR
A[etc] --> E[~/.config]
B[bin] --> F[~/.local/bin]
C[lib] --> G[~/.local/lib]
D[systemd] --> H[~/.config/systemd/user]
{{</ mermaid >}}

Then it will enabled [systemd](https://systemd.io/) user units and timers for common tasks (*e.g. backup and other stuff*), the enabled unit are defined in the configuration file (`ENABLED_SERVICES` `TEMPLATE_SERVICES` `ENABLED_TIMERS`)

The script will also add to the `~/.bashrc` an include line to enable common aliases for the scripts inside the repository

## System wide configuration

The installation script runs also other system wide configurations (*`sudo` is required*) when called with the parameter `system` such as:

- greeter and `greetd` configuration
- sudo configuration for the current user `$USER`
- `pam` configuration for unlocking gnome key ring on login

### Greeter configuration

The installation scripts install `greetd` as a login daemon and `hyprland` and sway as window managers, configuration is done for both the environments (`hyprland` is more updated since is my default one), to set one of them as default program after login edit `/etc/greetd/config.toml` as follows

> `/etc/greetd/config.toml`
{{< codeimporter url="https://raw.githubusercontent.com/carnivuth/scripts/refs/heads/main/lib/greetd/config.toml">}}

### Sudo configuration for updates

The installation scripts creates a git hook that runs on merge event and execute the `./scripts.sh` installation script, and adds a sudo config for the current `$USER` to allow `pacman` without password

```bash
echo "$USER ALL=(ALL:ALL) NOPASSWD:/bin/pacman" | sudo tee "/etc/sudoers.d/$USER"
```

### Configuring pam for gnome keyring

The installation script configure also pam module to unlock the gnome keyring on login, this is important because a lot of scripts store secrets in it

> `/etc/pam.d/greetd`
{{< codeimporter url="https://raw.githubusercontent.com/carnivuth/scripts/refs/heads/main/lib/pam.d/greetd">}}
