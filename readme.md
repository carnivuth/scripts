# SCRIPTS 
personal dotfiles (xorg and wayland configuration) + some usefull scripts and tools for everyday use

## SHOWCASE
![](./notes/assets/demo.gif)

## INSTALLATION

to install :

- clone the repository on the `$HOME` directory (it must be under `$HOME` directory)

- cd `$HOME/scripts`

- copy default configurations `cp $HOME/scripts/settings.sh.sample $HOME/scripts/settings.sh`

- `./install.sh` this will run the global installation script wich install all the dependencies

after installation dotfiles of the selected environment will be linked inside `$HOME/.config` directory, in order to install also the bash configuration manual links need to be made:

```bash
ln -s $HOME/scripts/carnivuth-DE/.bashrc $HOME/.bashrc
ln -s $HOME/scripts/carnivuth-DE/.bash_aliases $HOME/.bash_aliases
```

systemd files will be copied to `$HOME/.config/systemd/user/` replacing paths with the user home folder

desktop files will be linked to `$HOME/.local/share/applications/`

utilities will be added to the `PATH` variable

## CONFIGURATION

configuration is done in the `$HOME/scripts/settings.sh` file, see the `.sample` version for reference

## SUPPORTED SYSTEMS

the repo is tested on arch linux, it should work on other distros if you install the dependencies listed in the `./install.sh` script
