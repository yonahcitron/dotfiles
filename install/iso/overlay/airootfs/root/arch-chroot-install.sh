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
echo "Set root password:"
passwd

# Create user 'yonah'
useradd -m yonah
echo "Set password for user 'yonah':"
passwd yonah
usermod -aG wheel yonah
echo "%wheel ALL=(ALL) ALL" >>/etc/sudoers

# Enable iwd with DHCP
mkdir -p /etc/iwd
cat <<EOF >/etc/iwd/main.conf
[General]
EnableNetworkConfiguration=true
EOF

systemctl enable iwd

# Setup sudo for user 'yonah'
pacman -S --noconfirm sudo
usermod -aG wheel yonah
echo "%wheel ALL=(ALL:ALL) NOPASSWD: ALL" >/etc/sudoers.d/99_wheel_nopasswd
chmod 440 /etc/sudoers.d/99_wheel_nopasswd


# Get my dotfiles from git and install my user apps and settings.
pacman -S git
mkdir /home/yonah/repos
git clone https://github.com/yonahcitron/dotfiles.git /home/yonah/repos/dotfies
# TODO: THIS path WILL CHANGE SOON
su yonah
bash /home/yonah/repos/dotfiles/arch-install.sh

# Install GRUB to EFI
su root
grub-install --target=x86_64-efi --efi-directory=/boot/efi --bootloader-id=GRUB
grub-mkconfig -o /boot/grub/grub.cfg

echo "=== Post-install setup complete ==="
