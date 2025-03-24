# TODO: Make a feature to automatically install it to a device, asking in particular what device you want to install it to as part of the option.
# TODO: See if there's a way to have both line numbers at the same time

# Local paths
install_dir="$dotfiles/install/"
iso_name="archlinux-x86_64.iso"
cache_dir="$install_dir/.cache"
iso_path="$cache_dir/$iso_name"
build_dir="$install_dir/.build"

# Check if base arch ISO image is already cached, else download it.
if [ ! -e $iso_path ]; then
  mkdir -p $iso_dir
  wget -O $iso_path "https://london.mirror.pkgbuild.com/iso/latest/$iso_name"
else
  echo "Arch ISO file found locally, skipping download."
fi

# Copy the ISO to the build directory.
mkdir -p $build_dir
cp $iso_path $build_dir
