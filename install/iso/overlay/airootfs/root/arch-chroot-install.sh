#!/bin/bash

# TODO: For the password section, make the formatting of the prompts
# to the user more clear.
#
# TODO: Install git and then install the system during the setup phase here....
set -e

echo "=== Running post-install setup in installed environment ==="

# Time zone and clock
ln -sf /usr/share/zoneinfo/Europe/London /etc/localtime
hwclock --systohc

# Locale
echo "en_GB.UTF-8 UTF-8" >>/etc/locale.gen
locale-gen
echo "LANG=en_GB.UTF-8" >/etc/locale.conf

# Hostname
read -rp "Enter hostname: " hostname
echo "$hostname" >/etc/hostname

# Root password
echo ""
echo "Setting password for root user..."
passwd

# Create user 'yonah' with sudo access
echo ""
echo "Creating user 'yonah' and adding to wheel group for sudo access..."
id -u yonah &>/dev/null || useradd -m yonah # Will still succeed if user already exists
echo "Set password for user 'yonah':"
passwd yonah
usermod -aG wheel yonah
pacman -S --noconfirm sudo
echo "%wheel ALL=(ALL:ALL) NOPASSWD: ALL" >/etc/sudoers.d/99_wheel_nopasswd
chmod 440 /etc/sudoers.d/99_wheel_nopasswd

# Enable iwd with DHCP
mkdir -p /etc/iwd
cat <<EOF >/etc/iwd/main.conf
[General]
EnableNetworkConfiguration=true
EOF

# TODO: SORT OUT THE SUDO ISSUES WHERE IT STILL PROMPTS FOR PASSWORD FOR THE USER 'YONAH'...

systemctl enable iwd

# Get my dotfiles from git and install my user apps and settings.
pacman --noconfirm -S git
git clone https://github.com/yonahcitron/dotfiles.git /home/yonah/repos/dotfiles
# TODO: THIS path WILL CHANGE SOON
# Run the environment setup script for the user 'yonah'
sudo -u yonah /home/yonah/repos/dotfiles/arch-setup.sh

# Install GRUB to EFI
grub-install --target=x86_64-efi --efi-directory=/boot/efi --bootloader-id=GRUB
grub-mkconfig -o /boot/grub/grub.cfg

echo "=== Post-install setup complete ==="
