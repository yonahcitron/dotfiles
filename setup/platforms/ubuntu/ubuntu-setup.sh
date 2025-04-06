# Import global variables.
# set -euo pipefail # TODO: Debug why there is an unbound local variable error here with set -u.
set -eo pipefail
source $HOME/repos/dotfiles/user_configs/bash/.bashrc # This works even after the first install, when my bashrc has not been sourced on startup.
: "${dotfiles:?Environment variable 'dotfiles' must be set.}"

##############################
####### Applications #########
##############################

PACKAGES_FILE="$dotfiles/setup/platforms/ubuntu/ubuntu-packages.txt"
echo "Ensuring all the following packages are installed:"
cat "$PACKAGES_FILE"

# Update package index
echo "[INFO] Updating package index..."
sudo apt update

# Install listed packages
echo "[INFO] Installing packages from $PACKAGES_FILE..."
xargs -a "$PACKAGES_FILE" sudo apt install -y

# Get the full path of zsh
ZSH_PATH=$(which zsh)

# Change the default shell for the current user
if [[ "$SHELL" != "$ZSH_PATH" ]]; then
  echo "Changing default shell to zsh..."
  sudo chsh -s "$ZSH_PATH" "$USER"
fi

echo "Confirming zsh is the default shell..."
if [[ "$(getent passwd "$USER" | cut -d: -f7)" == "$ZSH_PATH" ]]; then
  echo "Confirmed zsh is the default shell."
else
  echo "Failed to change default shell."
fi

###################################
########## User Configs ###########
###################################

working_dir=$(pwd)
user_account="yonah"
local_bin="$HOME/.local/bin"
mkdir -p $local_bin # This folder is added to the PATH in the .bashrc file.
sudo chmod +x $local_bin/*

# Symlink the setup script to the local bin directory.
source_setup="$dotfiles/setup/platforms/arch/arch-setup.sh"
symlink_setup="$local_bin/setup"
if [ -L $symlink_setup ]; then
  echo "Setup symlink already exists at: $symlink_setup. Skipping."
elif [ -e $symlink_setup ]; then
  echo "A non-symlink file already exists at $symlink_setup. Skipping."
else
  echo "Creating symlink: $symlink_setup -> $source_setup"
  ln -s "$source_setup" "$symlink_setup"
fi

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

cd $working_dir

#############################
