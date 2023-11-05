script for folders backup with [borg](https://www.borgbackup.org/) 

the scripts creates a backup for each path defined in the [datafile](#DATAFILE) under   `$BACKUP_FOLDER` borg repository 

## INITIAL CONFIGURATION

the backups are encrypted with a passphrase that is read with the secret-tool utility,  you have to save it on the system keyring before launching the script

```bash
echo "<your passprhase>"| secret-tool store borg-repository repo-name --label="borg passphrase"
```
## DATAFILE 

there is a configuration file  `systemd/scripts/target.sh` to configure folders path to backup, format as follows:

```bash 
ARRAY=( "$HOME" )
```


