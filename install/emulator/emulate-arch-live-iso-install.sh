# TODO:
# - Install the actual QEMU packages I need.
#   - Just `qemu` alone does not have what I need.

# Local paths
iso_dir="$dotfiles/install/iso"

# TODO: Change this logic to actually RUN the iso generation
# process if doesn't exist...
# Change the name to not be date-dependent.
iso_name="yonah-custom-archlinux-auto-installer-x86_64.iso"
iso_path="$iso_dir/$iso_name"
if [ ! -e "$iso_path" ]; then
  echo "No custom arch ISO found locally, aborting."
  exit 1
else
  echo "Compiled custom arch ISO found locally, loading existing."
fi

# Configure disk
disk_name="arch-disk.img"
emulator_dir="$dotfiles/install/emulator"
disk_dir="$emulator_dir/disk"
disk_path="$disk_dir/$disk_name"
mkdir -p "$disk_dir"

echo "Recreating new empty virtual disk..."
rm -f "$disk_path"
qemu-img create -f qcow2 "$disk_path" 20G

# Check if there's an existing nvram file
nvram_path="$emulator_dir/nvram"
nvram_name="OVFM_VARS.fd"
echo "Recreating new empty nvram file..."
rm -f "$nvram_path/$nvram_name"
mkdir -p "$nvram_path"
cp /usr/share/edk2/x64/OVMF_VARS.4m.fd "$nvram_path/$nvram_name"

qemu-system-x86_64 \
  -drive if=pflash,format=raw,readonly=on,file=/usr/share/edk2/x64/OVMF_CODE.4m.fd \
  -drive if=pflash,format=raw,file="$nvram_path/$nvram_name" \
  -enable-kvm \
  -cpu host \
  -m 2048 \
  -machine q35 \
  -drive file=$disk_path,format=qcow2,if=virtio \
  -cdrom $iso_path \
  -virtfs local,id=shared,path="$dotfiles/install/iso/overlay/airootfs/root",security_model=mapped,mount_tag=hostshare \
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
