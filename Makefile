.DEFAULT_GOAL := install
.PHONY: $(addprefix dep-, $(DEPS)) deps links hooks install update $(HOME)/.bashrc $(HOME)/.ssh/config /etc/sudoers.d/$(USER)

DEPS= sway swaybg swayidle swaylock hyprland hyprshot hyprpicker hyprpolkitagent hyprlock hypridle hyprpaper xdg-desktop-portal-hyprland dosfstools discord gamemode mangohud python-langdetect python-pyacoustid python-pylast chromaprint python-pymad python-beautifulsoup4 python-typing_extensions beets cdrtools udiskie bash-completion wol parallel gst-plugin-spotify inotify-tools pass wireshark-cli fastfetch nextcloud-client pinentry-bemenu btop cliphist which pandoc-cli starship rsync stow yt-dlp ffmpeg gawk wf-recorder calc tmux seahorse fzf lazygit newsboat network-manager-applet playerctl pamixer gnome-themes-extra jq bluez-utils loupe evince ttf-dejavu mpv ranger thunderbird adwaita-icon-theme libnotify pop-icon-theme pavucontrol firefox telegram-desktop papirus-icon-theme brightnessctl mpv-mpris ttf-font-awesome github-cli socat blueman vim alacritty obsidian nm-connection-editor noto-fonts-emoji noto-fonts-cjk greetd greetd-tuigreet wev ttf-jetbrains-mono-nerd waybar bemenu-wayland bemenu-ncurses bemenu slurp grim qt6-wayland wl-clipboard dunst curl borg retroarch newsboat upower libsecret

define link_file
	mkdir -p "$@"
	stow --target="$@" $<
endef

.git/hooks/post-merge:
	echo -e '#!/bin/bash\nmake update' > $@
	chmod +x "$@"

$(HOME)/.local/bin: bin
	$(link_file)

$(HOME)/.local/lib: lib
	$(link_file)

$(HOME)/.config: etc
	$(link_file)

$(HOME)/.mozilla/firefox: firefox
	$(link_file)

$(HOME)/.config/systemd/user: systemd
	$(link_file)
	systemctl --user daemon-reload

/etc/greetd/config.toml: sys/greetd/config.toml
	install -m 0600 $< $@

/etc/pam.d/greetd: sys/pam.d/greetd
	install -m 0600 $< $@

/etc/sudoers.d/$(USER):
	echo "$(USER) ALL=(ALL:ALL) NOPASSWD:/bin/pacman" |sudo tee "/etc/sudoers.d/$(USER)"

$(HOME)/.bashrc:
	touch $@
	grep -qxF 'source $$HOME/.config/scripts/settings.sh' $@ || echo 'source $$HOME/.config/scripts/settings.sh' >> $@

hooks: .git/hooks/post-merge
deps: $(addprefix dep-, $(DEPS))

dep-%:
	pacman -Q $* > /dev/null 2>&1 || sudo pacman -S $* --noconfirm

links: $(HOME)/.local/bin $(HOME)/.local/lib $(HOME)/.config $(HOME)/.config/systemd/user $(HOME)/.mozilla/firefox

$(HOME)/.ssh/config:
	mkdir -p "$(HOME)/.ssh"
	touch "$(HOME)/.ssh/config"
	grep -qxF 'Include ~/.config/ssh/config' $@ || echo  "Include ~/.config/ssh/config" >> $@

install: /etc/greetd/config.toml /etc/pam.d/greetd /etc/sudoers.d/$(USER) deps links $(HOME)/.bashrc $(HOME)/.ssh/config hooks
update: deps links $(HOME)/.bashrc $(HOME)/.ssh/config hooks
