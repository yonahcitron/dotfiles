# TODO: Make a feature to automatically install it to a device, asking in particular what device you want to install it to as part of the option.
# TODO: See if there's a way to have both line numbers at the same time

# Local paths
install_dir="$dotfiles/install"
iso_name="archlinux-x86_64.iso"
cache_dir="$install_dir/.cache"
iso_path="$cache_dir/$iso_name"
build_dir="$install_dir/.build"

# Check if base arch ISO image is already cached, else download it.
if [ ! -e $iso_path ]; then
  mkdir -p $iso_dir
  wget -O $iso_path "https://london.mirror.pkgbuild.com/iso/latest/$iso_name"
  echo "Downloaded Arch ISO file to $iso_path."
else
  echo "Arch ISO file found locally, skipping download."
fi

# Extract the ISO to the build directory.
# USE SOME OTHER METHOD TO DO THIS..
# mkdir -p $cache_dir/iso_read_only_mount
# Mount the iso, copy to the build directory, and unmount.
# mkdir -p $build_dir/extracted_iso
# sudo mount -o loop $iso_path $cache_dir/iso_read_only_mount
# sudo cp -r $cache_dir/iso_read_only_mount $build_dir/extracted_iso
# sudo umount $cache_dir/iso_read_only_mount
# rm -rf $cache_dir/iso_read_only_mount

# Use the other method instead... maybe 7z

# Put the final ISO in the install directory.
custom_iso_name="yonah-$iso_name"

# Delete the build artifacts.
