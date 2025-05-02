# Import the global variables used throughout this script and others.
source /home/yonah/repos/dotfiles/user_configs/sh/.bashrc # This should run out-the-box even on a clean install. The 'dotfiles' repo is installed already by the arch-ISO installation script.

###################################
########## Init scripts ###########
###################################
# Run any platform-specific initialization scripts.
if [ -e "$DF_PLATFORM_INIT_SCRIPT" ]; then
  echo "Running init script for $DISTRO: $DF_PLATFORM_INIT_SCRIPT"
  source "$DF_PLATFORM_INIT_SCRIPT"
else
  echo "No init script found for $DISTRO: $DF_PLATFORM_INIT_SCRIPT"
fi

# Run any device-specific initialization scripts, identified by the hostname.
if [ -e "$DF_DEVICE_INIT_SCRIPT" ]; then
  echo "Running init script for $HOSTNAME: $DF_DEVICE_INIT_SCRIPT"
  source "$DF_DEVICE_INIT_SCRIPT"
else
  echo "No init script found for $HOSTNAME: $DF_DEVICE_INIT_SCRIPT"
fi

echo "Successfully ran init script."
###################################
########## User Configs ###########
###################################

if [ -e "$HOME/.bashrc" ] && [ ! -L "$HOME/.bashrc" ]; then
  echo "A .bashrc file exists in the home repo that NOT a symlink to my own .bashrc. Deleting it."
  rm $HOME/.bashrc
fi

# TODO: In order to get the intended functionality of treating each of the subfolders of the stow dir as a module, and reacreate each of their substructures within the target dirs, rather than just dumping them in the target dir directly, the cd approach was working best. For better readability, look into whether it could work with specifying the dir, it wasn't last time I tried.

# TODO: Symlink the .env.sh file to my home dir for better traceability.
working_dir=$(pwd)

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
cd $dotfiles/cmdlets
mkdir -p $HOME/.local/share
mkdir -p $HOME/.local/bin
stow --target $HOME/.local/share share
stow --target $HOME/.local/bin bin
sudo chmod +x $HOME/.local/bin/*

cd $working_dir

#########################################
########## Post-setup scripts ###########
#########################################

# Run any platform-specific setup postscripts.
if [ -e "$DF_PLATFORM_POSTSCRIPT" ]; then
  echo "Running postscript for $DISTRO: $DF_PLATFORM_POSTSCRIPT"
  source "$DF_PLATFORM_POSTSCRIPT"
else
  echo "No postscript found for $DISTRO: $DF_PLATFORM_POSTSCRIPT"
fi

# Run any device-specific postscripts, identified by the hostname.
if [ -e "$DF_DEVICE_POSTSCRIPT" ]; then
  echo "Running postscript for $HOSTNAME: $DF_DEVICE_POSTSCRIPT"
  source "$DF_DEVICE_POSTSCRIPT"
else
  echo "No postscript found for $HOSTNAME: $DF_DEVICE_POSTSCRIPT"
fi

# Finally, when updating system (and therefore already using zsh),
# rerun .zsh setup scripts to ensure any changes apply.
ZSH_PATH=$(which zsh)
if [[ "$SHELL" == "$ZSH_PATH" ]]; then
  echo "[INFO] Already running in zsh, sourcing zsh setup scripts to refresh environment.."
  source $DF_BASE_ZPROFILE
  source $DF_BASE_ZSHRC
fi
