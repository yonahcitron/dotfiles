iso_name="yonah-custom-archlinux-auto-installer-x86_64.iso"
iso_path="$iso_dir/$iso_name"
disk_name="arch-disk.img"
emulator_dir="$dotfiles/install/emulator"
disk_dir="$emulator_dir/disk"
disk_path="$disk_dir/$disk_name"
nvram_path="$emulator_dir/nvram"
nvram_name="OVFM_VARS.fd"

qemu-system-x86_64 \
  -drive if=pflash,format=raw,readonly=on,file=/usr/share/edk2/x64/OVMF_CODE.4m.fd \
  -drive if=pflash,format=raw,file="$nvram_path/$nvram_name" \
  -enable-kvm \
  -cpu host \
  -m 2048 \
  -machine q35 \
  -drive file=$disk_path,format=qcow2,if=virtio \
  -boot menu=on

# TODO: MAKE THE VNC VIEWER ALSO POP UP WHEN I RUN THIS!!!!
# ALSO FIND OUT WHY GIT ISN'T INSTALLED ALREADY ON THE INSTALLED MACHINE TO DO A GIT CLONE ETC...
