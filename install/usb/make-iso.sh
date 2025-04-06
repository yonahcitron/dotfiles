#!/usr/bin/env bash
#
# Usage: ./create_usb_iso.sh /path/to/file.iso
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

function partition_device() {
  local device="$1"
  local size_in_mb="$2"

  echo "You have selected: $device"
  echo "This will destroy any data on the device!"
  confirm_or_exit

  echo "Partitioning $device..."
  # Create a new partition table
  parted -s "$device" mklabel msdos

  # Compute the partition start and end
  # For example, start after 1MiB and end after size_in_mb + 10MiB
  # to give some overhead
  local start="1MiB"
  local end="$((size_in_mb + 10))MiB"

  # Create a primary partition
  parted -s "$device" mkpart primary "$start" "$end"
  parted -s "$device" set 1 boot on

  # We assume partition #1 as the destination
  local partition="${device}1"
  echo "Created partition: $partition"

  # Optional: create a filesystem. Usually you'd do dd directly to the partition
  # for a bootable ISO, but if you just want to store an ISO file, uncomment this:
  # mkfs.ext4 "$partition"

  # Return the partition name for the caller
  echo "$partition"
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

echo "Do you want to create a new partition on a USB device? (y/n)"
read -r create_partition

if [[ "$create_partition" == "y" ]]; then
  list_usb_devices
  echo -n "Enter the device path (e.g. /dev/sdb): "
  read -r device_path

  partition_path=$(partition_device "$device_path" "$iso_size_mb")
  echo "Partition created at: $partition_path"
else
  echo "Please enter the existing partition path (e.g. /dev/sdb1) to copy the ISO to:"
  read -r partition_path
fi

echo "Ready to write $ISO_PATH to $partition_path. This will overwrite data on $partition_path."
confirm_or_exit

echo "Writing ISO to $partition_path via dd..."
dd if="$ISO_PATH" of="$partition_path" bs=4M status=progress oflag=sync

echo "Syncing changes..."
sync

echo "Operation complete. ISO written to $partition_path."
exit 0
