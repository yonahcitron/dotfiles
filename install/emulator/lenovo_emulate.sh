#!/bin/bash
# A script to emulate the startup of my lenovo machine(s) so I can
# write and test an idempotent installation script for future machines.

# Download the arch ISO image if doesn't already exist
iso_name="archlinux-x86_64.iso"
iso_path="dotfiles/install/emulator/images/$iso_name"
if [ ! -e iso_path ]; then
  wget -P $iso_path "https://london.mirror.pkgbuild.com/iso/latest/$iso_name"
else
  echo "File does not exist"
fi

# In my .nvimrc, see how I can enable line-wraparound by default...
# Also, as a matter of urgency (next thing bc is actually useful), make
# one caps lock press be esc, holding it down be super + shift, and double tap
# be caps loc

# Search if there's a good way on vim to paste a line and overwrite the current one??
# qemu-img create -f qcow2 lenovo-disk.img 20G # Copy on write
#
#
# Vim indeed teaches you to use computers like instruments... and it shows you the
# feats that people are capable of in terms of co-ordination (by gift)...
