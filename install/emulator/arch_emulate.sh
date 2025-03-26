#!/bin/bash
# A script to emulate the startup of my lenovo machine(s) so I can
# write and test an idempotent installation script for future machines.

# TODO:
# - Install the actual qemu packages I need.
#   - Just `qemu` alone does not have what I need.

# Local paths
emulator_dir="$dotfiles/install/emulator"

# Download the arch ISO image if doesn't already exist
iso_name="archlinux-2025.03.25-x86_64.iso"
iso_dir="$emulator_dir/.."
iso_path="$iso_dir/$iso_name"
if [ ! -e $iso_path ]; then
  echo "No custom arch ISO found locally, aborting."
  exit 1
else
  echo "Compiled custom arch ISO found locally, loading existing."
fi

# Configure disk.
# TODO: Make option to delete / not delete the disk depending
# on whether I want a fresh install.. pass this as an optional param... make make the flag --wipe-disk or smt
disk_name="arch-disk.img"
disk_dir="$emulator_dir/disk"
disk_path="$disk_dir/$disk_name"
if [ ! -e $disk_path ]; then
  mkdir -p $disk_dir
  qemu-img create -f qcow2 $disk_path 20G # Copy on write
else
  echo "Arch disk file found locally, loading existing."
fi

qemu-system-x86_64 \
  -enable-kvm \
  -cpu host \
  -m 2048 \
  -drive file=$disk_path,format=qcow2,if=virtio \
  -cdrom $iso_path \
  -virtfs local,id=shared,path="$dotfiles/install/scripts",security_model=mapped,mount_tag=hostshare \
  -boot menu=on \
  -nographic

# For dynamic file editing / debugging in the VM, before I bake the script into the ISO itself:
# mkdir /mnt/hostshare
# mount -t 9p -o trans=virtio,version=9p2000.L hostshare /mnt/hostshare

# In my .nvimrc, see how I can enable line-wraparound by default...
# Also, as a matter of urgency (next thing bc is actually useful), make
# one caps lock press be esc, holding it down be super + shift, and double tap
# be caps loc
#
# Search if there's a good way on vim to paste a line and overwrite the current one??
#
#
# Vim indeed teaches you to use computers like instruments... and it shows you the
# feats that people are capable of in terms of co-ordination (by gift)...
