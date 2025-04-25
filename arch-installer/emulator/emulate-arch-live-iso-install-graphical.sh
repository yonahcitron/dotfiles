# Graphical install from the actual live usb that is plugged into the host

# Need to run as root to access the usb device, root doesn't have my $dotfiles env variable, so adding it here:
dotfiles="/home/yonah/repos/dotfiles"

# Local paths
iso_dir="$dotfiles/arch-installer/iso"

####################
## Qemu Paths ######
####################

emulator_dir="$dotfiles/arch-installer/emulator"

disk_name="arch-disk.img"
disk_dir="$emulator_dir/disk"
disk_path="$disk_dir/$disk_name"

nvram_dir="$emulator_dir/nvram"
nvram_name="OVFM_VARS.fd"
nvram_path="$nvram_dir/$nvram_name"

mkdir -p "$disk_dir"

read -p "Do you want to recreate the virtual disk and NVRAM file? [y/N]: " recreate_choice

if [[ "$recreate_choice" =~ ^[Yy]$ ]]; then
  echo "Recreating new empty virtual disk..."
  rm -f "$disk_path"
  qemu-img create -f qcow2 "$disk_path" 20G

  echo "Recreating new empty NVRAM file..."
  rm -f "$nvram_path"
  mkdir -p "$nvram_dir"
  cp /usr/share/edk2/x64/OVMF_VARS.4m.fd "$nvram_path"
  echo "New NVRAM file succesfully generated at $nvram_path"
else
  echo "Keeping existing virtual disk and NVRAM file."
fi

qemu-system-x86_64 \
  -drive if=pflash,format=raw,readonly=on,file=/usr/share/edk2/x64/OVMF_CODE.4m.fd \
  -drive if=pflash,format=raw,file="$nvram_path" \
  -drive file=/dev/sda,format=raw,if=virtio \
  -enable-kvm \
  -cpu host \
  -m 2048 \
  -machine q35 \
  -drive file=$disk_path,format=qcow2,if=virtio \
  -boot order=dc

# For dynamic file editing / debugging in the VM, before I bake the script into the ISO itself:
# mkdir /tmp/hostshare
# mount -t 9p -o trans=virtio,version=9p2000.L hostshare /tmp/hostshare

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
