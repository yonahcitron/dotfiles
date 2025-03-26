# Potentially during development, dynamically load in the arch-install.sh file so that I don't have to recompile the iso every time... however, eventually, bake in the script properly and then install it into the usb, all in this script!!!

# TODO: Make a feature to automatically install it to a device, asking in particular what device you want to install it to as part of the option.
# TODO: See if there's a way to have both line numbers at the same time

set -e

working_directory=$(pwd)

# Local paths
install_dir="$dotfiles/install"
iso_name="archlinux-x86_64.iso"
cache_dir="$install_dir/.cache"
iso_path="$cache_dir/$iso_name"
build_dir="$install_dir/.build"

# FOR DEBUGGING - REMOVE BUILD DIR IF ALREADY PRESENT...
# TODO: make part of the pipeline the copying of files to the build dir from the archiso thing.. that I did at the beginnign... do this soon..

# Make a .tmp dir for the 'work' directory
mkdir -p $install_dir/.tmp
work_dir="$install_dir/.tmp"

# Copy the 'releng' configuration files to the build directory.
sudo rm -rf $build_dir
mkdir -p $build_dir
cp -r /usr/share/archiso/configs/releng/* $build_dir
echo "Copied 'releng' configuration files to $build_dir."

# airootfs represents the root of the live environment.
live_root=$build_dir/airootfs
mkdir -p $live_root/usr/local/bin

# Make a simple install.sh script that says "Hello world from install.sh!"
cat <<EOF >$live_root/usr/local/bin/auto-install.sh
#!/bin/bash
echo "Hello world from auto-install.sh!"
EOF
chmod 755 $live_root/usr/local/bin/auto-install.sh
echo "Created auto-install.sh script in the live environment."
# TODO: reorganise this whole file better
# TODO: Get the login terminal to automatically login to root
# at startup, without prompting, and then run the install.sh
# script ... better

# TODO: ONCE I'VE TESTED THE SCRIPT IN THE LIVE ENVIRONMENT, BAKE the install script INTO INTO THE EXECUTABLE!!!
#     Add a note in it explaining that I don't want to have to recompile this executable ever, so make it as minimal as possible to simply install actual arch on the physical device, and from there I can / should go through all the actual set up using scripts that are pulled from the git repo, to make software updates easier. This code is really like firmware that allows me to get hold of my setup from the internet.

# Create a systemd service that runs once at startup
# TODO: This service is failing at startup! Fix it.
mkdir -p $live_root/etc/systemd/system
cat <<EOF >$live_root/etc/systemd/system/auto-install.service
[Unit]
Description=Run yonah's install script once at startup

[Service]
Type=oneshot
ExecStart=/usr/local/bin/install.sh
StandardOutput=journal+console
RemainAfterExit=yes

[Install]
WantedBy=multi-user.target

EOF
chmod 755 $live_root/etc/systemd/system/auto-install.service
echo "Created systemd setup script to run as a systemd service upon starting the live environment."
# Create a systemd service that runs once at startup
# The first param is what the *target* will be in the symlink. Symlinks are resolved dynamically so we must be in what the *target* system will understand..
mkdir -p $live_root/etc/systemd/system/multi-user.target.wants
ln -sf /etc/systemd/system/auto-install.service \
  $live_root/etc/systemd/system/multi-user.target.wants/auto-install.service
# Configure how EFI calls the kernel -
# it should pass params to send all output to the serial console as well.
boot_params_file=$build_dir/efiboot/loader/entries/01-archiso-x86_64-linux.conf
# Send the text below to overwrite the file
cat <<EOF >$boot_params_file
title    Arch Linux install medium (x86_64, UEFI)
sort-key 01
linux    /%INSTALL_DIR%/boot/x86_64/vmlinuz-linux
initrd   /%INSTALL_DIR%/boot/x86_64/initramfs-linux.img
options  archisobasedir=%INSTALL_DIR% archisosearchuuid=%ARCHISO_UUID% console=ttyS0,115200n8
EOF
echo "Configured the kernel to send all output to the serial console."

# Make a serial getty for ttyS0
mkdir -p $live_root/etc/systemd/system/getty.target.wants
ln -sf /usr/lib/systemd/system/getty@.service \
  $live_root/etc/systemd/system/getty.target.wants/getty@ttyS0.service
echo "Configured a serial getty for the login prompt on ttyS0."

# Put the final generated ISO in the install directory.
# custom_iso_name="yonah-custom-iso-$iso_name"
# TODO: CHANGE the name of the iso to be the custom name that I made, not the defeault one so it's clear it's my file..
sudo mkarchiso -v -w $work_dir -o $install_dir $build_dir

# Delete the build artifacts.
