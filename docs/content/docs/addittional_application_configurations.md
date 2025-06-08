---
date: '2025-06-08T14:33:44+02:00'
draft: true
title: 'Additional_application_configurations'
series: ["Documentation"]
series_order:
---

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
