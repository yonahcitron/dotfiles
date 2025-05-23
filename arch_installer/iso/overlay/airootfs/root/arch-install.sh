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

#################################
##### Formatting partitions #####
#################################

# Ask for root, EFI, and swap partitions by name only (e.g., sda3)
echo ""
read -rp "Enter the name of the SWAP partition (e.g. sda2) or press Enter to skip: " swap_name

while [[ -z "$root_name" ]]; do
  read -rp "Enter the name of the root partition (e.g. sda3): " root_name
done
root_partition="/dev/$root_name"

while [[ -z "$efi_name" ]]; do
  echo ""
  echo "Available EFI (vfat) partitions:"
  lsblk -p -o NAME,FSTYPE,SIZE,MOUNTPOINT | grep -i vfat || echo "  (none found)"
  echo ""
  read -rp "Enter the name of the EFI partition (e.g. sda1): " efi_name
done
efi_partition="/dev/$efi_name"

# Construct swap partition if present
swap_partition=""
[[ -n "$swap_name" ]] && swap_partition="/dev/$swap_name"

# Confirm and format root partition
read -rp "WARNING: Formatting $root_partition will erase all data on it. Do you want to reformat the root partition? (y/N): " confirm_root
if [[ "$confirm_root" =~ ^[Yy]$ ]]; then
  while true; do
    echo "Formatting $root_partition as ext4..."
    if mkfs.ext4 "$root_partition"; then
      echo "Root partition formatted successfully."
      break
    else
      read -rp "Formatting failed. Try again? (y/N): " try_again
      [[ "$try_again" =~ ^[Nn]$ ]] && break
    fi
  done
else
  echo "Skipping formatting of root partition ($root_partition)."
fi

# Confirm and format EFI partition if provided
if [[ -n "$efi_partition" ]]; then
  echo "Only format the EFI partition if not re-using an existing one."
  read -rp "WARNING: Formatting $efi_partition will erase all data on it. Do you want to reformat the EFI partition? (y/N): " confirm_efi
  if [[ "$confirm_efi" =~ ^[Yy]$ ]]; then
    while true; do
      echo "Formatting $efi_partition as FAT32..."
      if mkfs.fat -F32 "$efi_partition"; then
        echo "EFI partition formatted successfully."
        break
      else
        read -rp "Formatting failed. Try again? (y/N): " try_again
        [[ "$try_again" =~ ^[Nn]$ ]] && break
      fi
    done
  else
    echo "Skipping formatting of EFI partition ($efi_partition)."
  fi
fi

# Confirm and format swap partition if provided
if [[ -n "$swap_partition" ]]; then
  read -rp "WARNING: Formatting $swap_partition will erase all data on it. Do you want to reformat the swap partition? (y/N): " confirm_swap
  if [[ "$confirm_swap" =~ ^[Yy]$ ]]; then
    while true; do
      echo "Formatting $swap_partition as swap..."
      if mkswap "$swap_partition"; then
        echo "Swap partition formatted successfully."
        break
      else
        read -rp "Formatting failed. Try again? (y/N): " try_again
        [[ "$try_again" =~ ^[Nn]$ ]] && break
      fi
    done
  else
    echo "Skipping formatting of swap partition ($swap_partition)."
  fi
fi

echo "Disks configured. Root partition: $root_partition"

#####################################
##### Prerequisites for install #####
#####################################

echo ""
echo "Setting"

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
# Only refresh keyring; skip a full update to preserve RAM
# I was getting errors when I did a full pacman -Syu bc not enough ram on the live ISO.
pacman -Sy --needed --noconfirm archlinux-keyring

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
mkdir -p /mnt/var/lib/iwd # Wifi settings
cp -r /var/lib/iwd/* /mnt/var/lib/iwd/

cp /root/arch-chroot-install.sh /mnt/root/ # Setup script
chmod +x /mnt/root/arch-chroot-install.sh
arch-chroot /mnt /root/arch-chroot-install.sh

# TODO: Delete the arch-chroot-install.sh script after running it.

# All done. Prompt to reboot.
echo "Installation is complete. Press Enter to reboot..."
read -r
reboot
