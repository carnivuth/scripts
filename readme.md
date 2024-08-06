# SCRIPTS

personal dotfiles (xorg and wayland configuration) + some usefull scripts and tools for everyday use

## INSTALLATION

to install :

- clone the repository on the `$HOME` directory (it must be under `$HOME` directory)

```bash
git clone https://github.com/carnivuth/scripts "$HOME/scripts"
```

- copy default configurations

```
cp $HOME/scripts/settings.sh.sample $HOME/scripts/settings.sh
```

- `cd $HOME/scripts && ./install.sh` this will run the global installation script wich install all the dependencies

after installation dotfiles of the selected environment will be linked inside `$HOME/.config` directory **replacing existing configs** , and bash integration will be sourced in the `$HOME/.bashrc` file

systemd files will be copied to `$HOME/.config/systemd/user/` replacing paths with the user home folder

desktop files will be linked to `$HOME/.local/share/applications/`


## CONFIGURATION

configuration is done in the `$HOME/scripts/settings.sh` file, see the `.sample` version for reference

## SUPPORTED SYSTEMS

the repo is tested on arch linux, it should work on other distros if you install the dependencies listed in the `./install.sh` script
