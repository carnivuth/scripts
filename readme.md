# SCRIPTS

personal dotfiles (wayland configuration) + some usefull scripts and tools for everyday use

## INSTALLATION

to install :

- clone the repository on the `$HOME` directory (it must be under `$HOME` directory)

```bash
git clone https://github.com/carnivuth/scripts "$HOME/scripts"
```

- copy default configurations

```
cp $HOME/scripts/etc/.config/settings.sh.sample $HOME/scripts/etc/.config/settings.sh
```

- `cd $HOME/scripts && ./scripts` this will run the global installation script wich install all the dependencies

stow will place all dotfiles under `$HOME/.config` and bins and libs will be placed under `$HOME/.local/bin` and `$HOME/.local/lib`, systemd units will be placed under `$HOME/.config/systemd/user`

## CONFIGURATION

configuration is done in the `$HOME/.config/settings.sh` file, see the `.sample` version for reference

## SUPPORTED SYSTEMS

the repo is tested on arch linux, it should work on other distros if you install the dependencies listed in the `./install.sh` script
