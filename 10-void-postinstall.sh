#!/bin/bash
# Enable non-free repo and update the system
xbps-install -Sy void-repo-nonfree
xbps-install -Syu

# Install build essentials
xbps-install -y git base-devel

# Install Xorg and drivers for Intel GMA (Poulsbo)
xbps-install -y xorg xf86-video-intel xrandr xinput

# Install Bluetooth service
xbps-install -y bluez

# Install audio subsystem (PipeWire) and speaker-test utilities
xbps-install -y pipewire alsa-pipewire gstreamer1-pipewire libspa-bluetooth pavucontrol alsa-utils

# Install LXQT
xbps-install -y lxqt sddm nm-tray blueman

# Install some software
xbps-install -y xmirror jq yq wget curl aria2c mc tmux unrar fastfetch firefox-esr

# Install some fonts (WARNING: 8 GB)
#xbps-install -y noto-fonts-cjk noto-fonts-emoji noto-fonts-ttf noto-fonts-ttf-extra nerd-fonts nerd-fonts-ttf

# Install zsh and some of it's plugins
xbps-install -y zsh zsh-completions zsh-syntax-highlighting zsh-autosuggestions

# Set up PipeWire
ln -s /usr/share/applications/pipewire.desktop /etc/xdg/autostart/pipewire.desktop
ln -s /usr/share/applications/pipewire-pulse.desktop /etc/xdg/autostart/pipewire-pulse.desktop
ln -s /usr/share/applications/wireplumber.desktop /etc/xdg/autostart/wireplumber.desktop
mkdir -p /etc/alsa/conf.d
ln -s /usr/share/alsa/alsa.conf.d/50-pipewire.conf /etc/alsa/conf.d
ln -s /usr/share/alsa/alsa.conf.d/99-pipewire-default.conf /etc/alsa/conf.d

# Enable bluetooth service
ln -s /etc/sv/bluetoothd /var/service/

# Remove unused services (TTYs)
for tty in 3 4 5 6; do
  rm -rf /var/service/agetty-tty"$tty"
done

# Enable ACPI
ln -s /etc/sv/acpid/ /var/service/
sv enable acpid
sv start acpid

# Enable NetworkManager and disable wpa-supplicant
xbps-install -Sy NetworkManager dbus
if sv status wpa_supplicant >/dev/null 2>&1; then
  sv stop wpa_supplicant
fi

rm -rf /var/services/wpa_supplicant 2>/dev/null

ln -s /etc/sv/NetworkManager /var/service
sv start NetworkManager

# Set and enable SDDM
cp ./etc/sddm.conf /etc/sddm.conf
ln -s /etc/sv/sddm /var/service

# Add fastfetch into .bashrc
echo "fastfetch" >> /home/sysop/.bashrc

# Cleanup
xbps-remove -O
vkpurge rm all