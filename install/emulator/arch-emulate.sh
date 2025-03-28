# TODO:
# - Install the actual QEMU packages I need.
#   - Just `qemu` alone does not have what I need.

# Local paths
emulator_dir="$dotfiles/install/emulator"

# TODO: Change this logic to actually RUN the iso generation
# process if doesn't exist...
iso_name="archlinux-2025.03.25-x86_64.iso"
iso_dir="$emulator_dir/.."
iso_path="$iso_dir/$iso_name"
if [ ! -e "$iso_path" ]; then
  echo "No custom arch ISO found locally, aborting."
  exit 1
else
  echo "Compiled custom arch ISO found locally, loading existing."
fi

# Configure disk
disk_name="arch-disk.img"
disk_dir="$emulator_dir/disk"
disk_path="$disk_dir/$disk_name"
mkdir -p "$disk_dir"

if [ -e "$disk_path" ]; then
  echo ""
  echo "Disk image already exists: $disk_path"
  echo "Choose an option:"
  echo "1) Keep the existing disk (boot as-is)"
  echo "2) Delete and recreate the disk (fresh install)"
  read -rp "Enter your choice [1 or 2]: " disk_choice
  case "$disk_choice" in
  1)
    echo "Keeping existing disk."
    ;;
  2)
    echo "Deleting and recreating disk..."
    rm -f "$disk_path"
    qemu-img create -f qcow2 "$disk_path" 20G
    ;;
  *)
    echo "Invalid choice. Aborting."
    exit 1
    ;;
  esac
else
  echo "No disk image found. Creating a new one..."
  qemu-img create -f qcow2 "$disk_path" 20G
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

# Check if there's an existing nvram file
nvram_path="$emulator_dir/nvram"
nvram_name="OVFM_VARS.fd"
if [ ! -e "$nvram_path/$nvram_name" ]; then
  echo "No NVRAM file found locally, copying from system."
  mkdir -p "$nvram_path"
  cp /usr/share/edk2/x64/OVMF_VARS.4m.fd "$nvram_path/$nvram_name"
else
  echo "NVRAM file found locally, loading existing."
fi

qemu-system-x86_64 \
  -drive if=pflash,format=raw,readonly=on,file=/usr/share/edk2/x64/OVMF_CODE.4m.fd \
  -drive if=pflash,format=raw,file="$nvram_path/$nvram_name" \
  -enable-kvm \
  -cpu host \
  -m 2048 \
  -machine q35 \
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
