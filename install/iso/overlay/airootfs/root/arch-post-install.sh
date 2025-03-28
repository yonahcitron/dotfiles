#!/bin/bash

# TODO: INSTALL UEFI FIRMWARE AND THEN RUN QEMU WITH IT!!!

# TODO: For the password section, make the formatting of the prompts
# to the user more clear.
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

# Install GRUB to EFI
grub-install --target=x86_64-efi --efi-directory=/boot/efi --bootloader-id=GRUB
grub-mkconfig -o /boot/grub/grub.cfg

echo "=== Post-install setup complete ==="
