# Potentially during development, dynamically load in the arch-install.sh file so that I don't have to recompile the iso every time... however, eventually, bake in the script properly and then install it into the usb, all in this script!!!

# TODO: Make a feature to automatically install it to a device, asking in particular what device you want to install it to as part of the option.
# TODO: See if there's a way to have both line numbers at the same time

# TODO: VERY IMPORTANT:: I NEED TO MODIFY THIS SO IT CAN BE RUN FROM **BOTH** A SERIAL DEVICE AND ALSO A NORMAL TTY DEVICE!!! SO NEED TO NOT HARD-CODE TTYS0 BUT SELECT IT MORE DYNAMICALLY...

#!/bin/bash
set -e
# ============================================================
# Configuration
# ============================================================

# Working directories
working_directory=$(pwd)
install_dir="$dotfiles/install"
emulator_dir="$install_dir/emulator"
iso_dir="$install_dir/iso"

# Copy the ArchISO releng profile to the build directory.
build_dir="$install_dir/.build"
sudo rm -rf "$build_dir"
mkdir -p "$build_dir"
cp -r /usr/share/archiso/configs/releng/* "$build_dir"
echo "Copied ArchISO releng profile to: $build_dir"

# Make a temporary directory for the build process.
tmp_dir="$install_dir/.tmp"
sudo rm -rf $tmp_dir
mkdir -p $tmp_dir

# Overlay the custom files then build the ISO.
overlay_dir="$iso_dir/overlay"
rsync -av $overlay_dir/ $build_dir/
sudo mkarchiso -v -w "$tmp_dir" -o "$iso_dir" "$build_dir"

# The below is now taken care of by the overlay.

# TODO: Also change the iso name in the profiledef.sh file...
#mv "$iso_dir/archlinux-x86_64.iso" "$iso_dir/yonah-installer-archlinux-x86_64.iso"
#echo "Built ISO to: $iso_path"

# TODO: Document properly all that I'm doing here.
# Explain especially the mechanism for the gettys, e.g.:
#
# This symlink enables an instance of the getty@.service template for ttyS0.
# systemd treats getty@ttyS0.service as a parameterized invocation of getty@.service,
# where 'ttyS0' is passed as the %I template variable. Multiple such symlinks can
# coexist for different terminals (e.g., tty1, ttyS0), all using the same template.

# TODO: Mention that I'm installing all packages to do:
# - root packages to run scripts
# - kernel boot options to enable serial console
# - auto-login for serial terminal (ttyS0)
# - Maybe make the symlinks as well and set them up..

## ============================================================
## Inject install scripts into live environment ISO
## ============================================================
#for script in "$overlay_dir/root"/*; do
#  cp "$script" "$live_root/root"
#done
#
## ============================================================
## Kernel boot options (enable serial console)
## ============================================================
## Place in boot config file to boot kernel with serial console
#kernel_boot_params_path="efiboot/loader/entries/01-archiso-x86_64-linux.conf"
#cp "$overlay_dir/$kernel_boot_params_path" "$build_dir/$kernel_boot_params_path"
#echo "Added kernel boot options for serial console"
#
## ============================================================
## Auto-login for serial terminal (ttyS0)
## ============================================================
#
## Serial console login service override
#serial_getty_service="$live_root/etc/systemd/system/getty.target.wants/getty@ttyS0.service"
#serial_getty_override_dir="$live_root/etc/systemd/system/getty@ttyS0.service.d"
#serial_getty_override_conf="$serial_getty_override_dir/autologin.conf"
#
#mkdir -p "$(dirname "$serial_getty_service")"
#ln -sf /usr/lib/systemd/system/getty@.service "$serial_getty_service"
#echo "Enabled serial getty at ttyS0"
#
#mkdir -p "$serial_getty_override_dir"
#cat <<EOF >"$serial_getty_override_conf"
#[Service]
#ExecStart=
#ExecStart=-/sbin/agetty --autologin root --noclear %I \$TERM
#EOF
#echo "Configured auto-login for ttyS0"

# ============================================================
# Disable systemd-resolved (fix for live env DNS issues)
# ============================================================

# ln -sf /dev/null "$live_root/etc/systemd/system/systemd-resolved.service"
# echo "Disabled systemd-resolved in live environment"

# ============================================================
# Build the ISO
# ============================================================

# ============================================================
# Cleanup
# ============================================================

# Optionally delete build artifacts (currently not removed automatically)
# sudo rm -rf "$build_dir"
# TODO: ONCE I'VE TESTED THE SCRIPT IN THE LIVE ENVIRONMENT, BAKE the install script INTO INTO THE EXECUTABLE!!!
#     Add a note in it explaining that I don't want to have to recompile this executable ever, so make it as minimal as possible to simply install actual arch on the physical device, and from there I can / should go through all the actual set up using scripts that are pulled from the git repo, to make software updates easier. This code is really like firmware that allows me to get hold of my setup from the internet.
