---
date: '2025-06-07T11:10:40+02:00'
draft: false
title: 'Configuration'
weight: 20
series: ["Documentation"]
series_order: 2
---

{{< alert >}}
The paths in this page are all links generated at the installation phase using stow, refer to the [installation phase](/installation/#what-does-the-installation-script) for the general structure
{{</ alert >}}

## Configuration file structure

Configuration is done trough 2 main files:

- `$HOME/.config/scripts/settings.sh.sample` this is the default configuration file that is versioned inside the repository and should be used as reference and **never edited**
- `$HOME/.config/scripts/settings.sh` this is the main configuration file that is generated from the installation script and sources the sample one

All scripts and lib files sources the `settings.sh` file that sources the sample one

{{< mermaid >}}
flowchart LR
A[some_script.sh]
B[setting.sh]
subgraph repo
C[setting.sh.sample]
end
A -- source --> B -- source -->  C
{{</ mermaid >}}

## Editing the configuration file

In order to edit the configuration file copy the interested variable from the `settings.sh.sample` file inside the `settings.sh` file following the comments guidelines inside the sample file, for example to change the folders synced using the `nxtcdd.sh` utility (*nextcloud script*):

```bash
grep TEMPLATE_SERVICE "$HOME/.config/scripts/settings.sh.sample" >> "$HOME/.config/scripts/settings.sh"

# edit the file and add content
vim "$HOME/.config/scripts/settings.sh"
```

