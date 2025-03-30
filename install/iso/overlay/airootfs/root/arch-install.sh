#!/bin/bash
# Add big-level headers with ### .. find a tool for this!
# Echo out much more clearly what's going on in the script at each stage...
# Ask user to confirm at every stage whether what they've inputted is correct

# TODO: Simplify the stage with the partition writing!!
set -e

##############################################
# arch-install.sh
# Run this in the Arch ISO environment.
#
# This script partitions (optionally), formats, and installs Arch on a selected disk,
# using iwd for network configuration inside the new system.
##############################################

read -p "Hit Enter to begin install according to Yonah's configurations..."

# Doing 'loadkeys uk' messes up the keyboard layout when running the live environ through a serial console in qemu.

timedatectl set-ntp true
timedatectl status

echo ""
echo "** Available disks **"
lsblk
echo ""

# Ask user for the disk name (e.g., 'sda', not '/dev/sda')
read -rp "Enter the disk name for installation (e.g. 'sda'): " disk_name
target_disk="/dev/$disk_name"

# Prompt to partition the disk
read -rp "Partition this disk ($target_disk) with gdisk now? (Y/n): " do_partition
if [[ "$do_partition" =~ ^[Nn]$ ]]; then
  echo "Skipping disk partitioning."
else
  echo ""
  echo "Launching gdisk on $target_disk..."
  echo "Common steps:"
  echo "  - 'o' to create a new GPT"
  echo "  - 'n' to create partitions (EFI = type ef00, Linux root = type 8300, Swap = 8200)"
  echo "  - 't' to change partition type"
  echo "  - 'w' to write changes"
  echo ""
  read -p "Press Enter to continue..."
  gdisk "$target_disk"
fi

# Show newly created partitions
echo ""
echo "** Detected partitions on $target_disk **"
lsblk "$target_disk"

# Ask for root, EFI, and swap partitions by name only (e.g., sda3)
echo ""
read -rp "Enter the name of the ROOT partition (e.g. sda3): " root_name
read -rp "Enter the name of the EFI partition (e.g. sda1) or press Enter to skip: " efi_name
read -rp "Enter the name of the SWAP partition (e.g. sda2) or press Enter to skip: " swap_name

# Construct full paths
root_partition="/dev/$root_name"
efi_partition=""
swap_partition=""

[[ -n "$efi_name" ]] && efi_partition="/dev/$efi_name"
[[ -n "$swap_name" ]] && swap_partition="/dev/$swap_name"

# Format root partition
while true; do
  echo "Formatting $root_partition as ext4..."
  mkfs.ext4 "$root_partition" && break
  read -rp "Formatting failed. Try again? (y/N): " try_again
  [[ "$try_again" =~ ^[Nn]$ ]] && break
done

# Format EFI if provided
if [[ -n "$efi_partition" ]]; then
  while true; do
    echo "Formatting $efi_partition as FAT32..."
    mkfs.fat -F32 "$efi_partition" && break
    read -rp "Formatting failed. Try again? (y/N): " try_again
    [[ "$try_again" =~ ^[Nn]$ ]] && break
  done
fi

# Format swap if provided
if [[ -n "$swap_partition" ]]; then
  while true; do
    echo "Formatting $swap_partition as swap..."
    mkswap "$swap_partition" && break
    read -rp "Formatting failed. Try again? (y/N): " try_again
    [[ "$try_again" =~ ^[Nn]$ ]] && break
  done
fi

# Now that the disk is partitioned, we can proceed with the installation.


# Set DNS in the live environment (so we can download packages)
rm -f /etc/resolv.conf
echo "nameserver 1.1.1.1" >/etc/resolv.conf

# Check for internet connectivity
if ping -c 1 google.com &>/dev/null; then
  echo "Internet connection detected, skipping Wi-Fi connection."
else
  echo "No internet connection detected."
  echo "Scanning for Wi-Fi networks on interface wlan0..."
  iwctl station wlan0 scan
  iwctl station wlan0 get-networks
  read -p "Enter the SSID to connect to: " network_name
  iwctl station wlan0 connect "$network_name"
fi

# Update packages in the live environment
pacman-key --init
pacman-key --populate archlinux
# pacman-key --refresh-keys # Takes ages.
echo "Updating package database..."
pacman -Syu --noconfirm

# Mount root
mount "$root_partition" /mnt

# Mount EFI
if [[ -n "$efi_partition" ]]; then
  mkdir -p /mnt/boot/efi
  mount "$efi_partition" /mnt/boot/efi
else
  echo "No EFI partition provided. If using an existing bootloader, ensure it is handled separately."
fi

# Activate swap
if [[ -n "$swap_partition" ]]; then
  swapon "$swap_partition"
fi

# Pacstrap essential packages into new system
pacstrap /mnt base linux linux-firmware iwd grub efibootmgr

# Setup things in the new environment
cp ./arch-chroot-install.sh /mnt/root/
chmod +x /mnt/root/arch-chroot-install.sh
arch-chroot /mnt /root/arch-chroot-install.sh

# All done. Prompt to reboot.
echo "Installation is complete. Press Enter to reboot..."
read -r
reboot
