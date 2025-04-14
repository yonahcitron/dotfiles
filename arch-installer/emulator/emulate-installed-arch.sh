emulator_dir="$dotfiles/install/emulator"

disk_name="arch-disk.img"
disk_dir="$emulator_dir/disk"
disk_path="$disk_dir/$disk_name"

nvram_dir="$emulator_dir/nvram"
nvram_name="OVFM_VARS.fd"
nvram_path="$nvram_dir/$nvram_name"

# Check if the paths exist and exit if not
if [ ! -e "$disk_path" ]; then
  echo "No disk image found at $disk_path, aborting."
  exit 1
else
  echo "Disk image found at $disk_path, loading existing."
fi
if [ ! -e "$nvram_path" ]; then
  echo "No nvram file found at $nvram_path, aborting."
  exit 1
else
  echo "NVRAM file found at $nvram_path, loading existing."
fi

qemu-system-x86_64 \
  -drive if=pflash,format=raw,readonly=on,file=/usr/share/edk2/x64/OVMF_CODE.4m.fd \
  -drive if=pflash,format=raw,file="$nvram_path" \
  -enable-kvm \
  -cpu host \
  -m 2048 \
  -machine q35 \
  -drive file=$disk_path,format=qcow2,if=virtio \
  -boot order=c,menu=on

# TODO: MAKE THE VNC VIEWER ALSO POP UP WHEN I RUN THIS!!!!
# ALSO FIND OUT WHY GIT ISN'T INSTALLED ALREADY ON THE INSTALLED MACHINE TO DO A GIT CLONE ETC...
