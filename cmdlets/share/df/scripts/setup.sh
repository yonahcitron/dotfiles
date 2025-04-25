#!/bin/bash
# set -euo pipefail # TODO: Debug why there is an unbound local variable error here with set -u.
set -eo pipefail

# Import global variables. Find many of the below in the .bashrc, as well as the device-specific bashrc's that are sourced from there.
source $HOME/repos/dotfiles/user_configs/bash/.bashrc # This works even after the first install, when my bashrc has not been sourced on startup.
: "${dotfiles:?Environment variable 'dotfiles' must be set.}"
: "${DISTRO:?Environment variable 'DISTRO' must be set.}"

###################################
########## Init scripts ###########
###################################
DF_SETUP_DIR="$HOME/repos/dotfiles/cmdlets/share/df/setup"

# Run any platform-specific initialization scripts.
if [ -e "$DF_PLATFORM_INIT_SCRIPT" ]; then
  echo "Running init script for $DISTRO: $DF_PLATFORM_INIT_SCRIPT"
  source "$DF_PLATFORM_INIT_SCRIPT"
else
  echo "No init script found for $DISTRO: $DF_PLATFORM_INIT_SCRIPT"
fi

# Run any device-specific initialization scripts, identified by the hostname.
# ALSO MAKE THE DEVICE INIT SCRIPT LOCATION GLOBAL IN THE BASHRC
df_device_init_script="$DF_DEVICE_DIR/$HOSTNAME-init.sh"
if [ -e "$df_device_init_script" ]; then
  echo "Running init script for $HOSTNAME: $df_device_init_script"
  source "$df_device_init_script"
else
  echo "No init script found for $HOSTNAME: $df_device_init_script"
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
if [ -e "$DF_PLATFORM_POSTSCRIPT" ]; then
  echo "Running postscript for $DISTRO: $DF_PLATFORM_POSTSCRIPT"
  source "$DF_PLATFORM_POSTSCRIPT"
else
  echo "No postscript found for $DISTRO: $DF_PLATFORM_POSTSCRIPT"
fi

# TODO: Use the same pattern as above and ADD these to the bashrc as global variables rather than trying to define them here...
# Run any device-specific postscripts, identified by the hostname.
device_postscript="$DF_PLATFORM_DIR/devices/$HOSTNAME/$HOSTNAME-postscript.sh"
if [ -e "$device_postscript" ]; then
  echo "Running postscript for $HOSTNAME: $device_postscript"
  source "$device_postscript"
else
  echo "No postscript found for $HOSTNAME: $device_postscript"
fi
