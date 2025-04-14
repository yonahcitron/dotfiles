#!/bin/bash
# set -euo pipefail # TODO: Debug why there is an unbound local variable error here with set -u.
set -eo pipefail

# Import global variables.
source $HOME/repos/dotfiles/user_configs/bash/.bashrc # This works even after the first install, when my bashrc has not been sourced on startup.
: "${dotfiles:?Environment variable 'dotfiles' must be set.}"
: "${DISTRO:?Environment variable 'DISTRO' must be set.}"

# Source .bashrc if exists.
if [ -e "$HOME/.bashrc" ]; then
  source "$HOME/.bashrc"
fi

###################################
########## Init scripts ###########
###################################

# Run any platform-specific initialization scripts.
setup_dir="$HOME/.local/share/df/setup"
platform_dir="$setup_dir/platforms/$DISTRO"
platform_init_script="$platform_dir/$DISTRO-init.sh"
if [ -e "$platform_init_script" ]; then
  echo "Running init script for $DISTRO: $platform_init_script"
  source "$platform_init_script"
else
  echo "No init script found for $DISTRO: $platform_init_script"
fi

# Run any device-specific initialization scripts, identified by the hostname.
hostname=$(uname -n)
device_init_script="$platform_dir/devices/$hostname/$hostname-init.sh"
if [ -e "$device_init_script" ]; then
  echo "Running init script for $hostname: $device_init_script"
  source "$device_init_script"
else
  echo "No init script found for $hostname: $device_init_script"
fi

###################################
########## User Configs ###########
###################################

if [ -e "$HOME/.bashrc" ] && [ ! -L "$HOME/.bashrc" ]; then
  echo "The .bashrc file exists and is NOT a symlink. Deleting."
  rm $HOME/.bashrc
fi

# TODO: In order to get the intended functionality of treating each of the subfolders of the stow dir as a module, and reacreate each of their substructures within the target dirs, rather than just dumping them in the target dir directly, the cd approach was working best. Look into whether it could work with specifying the dir, it wasn't last time I tried.

cd $dotfiles
sudo pacman -S --noconfirm stow

echo "Setting up Yonah's user configs."
cd $dotfiles/user_configs
stow --target $HOME */ # User configs.

# Global configs.
echo "Setting up Yonah's global configs."
cd $dotfiles/global_configs
# Stowing as root should give root ownership of the symlinks.
# The files they link to should be user-owned, to not interfere with git.
sudo stow --target /etc */

# Executable cmdlets.
cd $dotfiles
stow --target $HOME/.local cmdlets/ # Stow cmdlet folder itself as a package so that its subfolders are placed exactly.
sudo chmod +x $local_bin/*

cd $working_dir

#############################

#########################################
########## Post-setup scripts ###########
#########################################

# Run any platform-specific postscripts.
platform_postscript="$platform_dir/$DISTRO-postscript.sh"
if [ -e "$platform_postscript" ]; then
  echo "Running postscript for $DISTRO: $platform_postscript"
  source "$platform_postscript"
else
  echo "No postscript found for $DISTRO: $platform_postscript"
fi

# Run any device-specific postscripts, identified by the hostname.
device_postscript="$platform_dir/devices/$hostname/$hostname-postscript.sh"
if [ -e "$device_postscript" ]; then
  echo "Running postscript for $hostname: $device_postscript"
  source "$device_postscript"
else
  echo "No postscript found for $hostname: $device_postscript"
fi
