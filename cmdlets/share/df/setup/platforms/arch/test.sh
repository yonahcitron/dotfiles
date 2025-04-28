# list available partitions and prompt user to select the swap partition
echo "listing all partitions and their fstype..."
lsblk -o name,type,size,fstype,uuid,mountpoint
echo
read -rp "enter the device name for the swap partition (e.g. sda2, nvme0n1p2, etc.): " swap_part

# construct full device path (assuming /dev prefix)
device_path="/dev/${swap_part}"

# get uuid of the chosen swap partition
if ! blkid "$device_path" >/dev/null 2>&1; then
  echo "error: invalid partition specified or partition not found."
  exit 1
fi
swap_uuid=$(blkid -s uuid -o value "$device_path")

# add 'resume=uuid=' to grub_cmdline_linux_default
echo "adding 'resume=uuid=$swap_uuid' to grub_cmdline_linux_default..."
