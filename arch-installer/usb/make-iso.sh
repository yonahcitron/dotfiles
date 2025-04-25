#!/usr/bin/env bash
#
# Usage: sudo ./create_usb_iso.sh /path/to/file.iso
#
# This script:
# 1. Takes the path to an ISO file.
# 2. Asks whether to create a new partition on a USB device or use an existing partition.
# 3. Lists USB devices if a new partition is requested.
# 4. Partitions the device with just enough space to hold the ISO (plus a little overhead).
# 5. Copies the ISO to the selected partition.
#
# NOTE: This script requires root privileges, parted, lsblk, and dd.
#       USE AT YOUR OWN RISK. You could lose data if used incorrectly.

# TODO: In future, I'd like to do this just to a paritition:
#  In future, can set up my bootable arch iso onto a partition of the usb rather than the whole thing.. but that requires manual installations etc... for now just put it on the whole usb for simplicity...

# Exit on errors or undefined variables
set -euo pipefail

# --- Functions ---

function confirm_or_exit() {
  echo -n "Confirm? (y/n): "
  read -r answer
  if [[ "$answer" != "y" ]]; then
    echo "Aborted."
    exit 1
  fi
}

function list_usb_devices() {
  echo "Available USB devices:"
  # Filter out only removable disks (TYPE="disk" and ROTA="1" often indicates a USB, but not always)
  # Adjust as needed if you have a different system layout
  lsblk -p -o NAME,SIZE,TYPE,MODEL | grep -w "disk" || true
}

# --- Main Script ---

if [[ $# -lt 1 ]]; then
  echo "Usage: $0 /path/to/file.iso"
  exit 1
fi

ISO_PATH="$1"

if [[ ! -f "$ISO_PATH" ]]; then
  echo "Invalid ISO file path: $ISO_PATH"
  exit 1
fi

# Check for root
if [[ $EUID -ne 0 ]]; then
  echo "This script must be run as root."
  exit 1
fi

# Check required tools
for tool in parted lsblk dd stat; do
  if ! command -v "$tool" >/dev/null 2>&1; then
    echo "Missing required tool: $tool"
    exit 1
  fi
done

# Get the size in bytes and convert to MB
iso_size_bytes=$(stat -c%s "$ISO_PATH")
iso_size_mb=$(((iso_size_bytes + 1024 * 1024 - 1) / (1024 * 1024)))

echo "ISO size: $iso_size_mb MB"

echo ""
list_usb_devices
while :; do
  echo -n "Enter the device path to copy the ISO to (e.g. /dev/sdb): "
  read -r device_path
  if [ -b "$device_path" ]; then
    echo "The selected device path is $device_path"
    echo ""
    break
  else
    echo "Error: '$device_path' is not a valid block device. Please try again."
  fi
done

# calculate block count
iso_bytes=$(stat -c '%s' "$ISO_PATH")
bs_bytes=$((4 * 1024 * 1024)) # block size in bytes for arithmetic
blocks=$(((iso_bytes + bs_bytes - 1) / bs_bytes))

echo "dd if=$ISO_PATH of=$device_path bs=$bs_bytes count=$blocks status=progress oflag=sync"
dd if="$ISO_PATH" \
  of="$device_path" \
  bs=$bs_bytes \
  count=$blocks \
  status=progress \
  oflag=sync
sync

echo "Operation complete. ISO written to device $device_path"
exit 0
