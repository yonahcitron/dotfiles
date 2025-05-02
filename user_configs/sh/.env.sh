# NOTE: This file is in my dotfiles repo. It should always be symlinked to my home dir.

#############################################
# GLOBAL VARIABLES
#############################################
export PATH="$HOME/.local/bin:$PATH"
export SUDO_EDITOR=vim
export EDITOR=nvim
# TODO: Change this everywhere to upper-case
export DOTFILES="$HOME/repos/dotfiles"
export VAULT="$HOME/repos/vault"

# This method returns the hostname of the target system even when in chroot - this is what I want for my setup scripts.
export HOSTNAME=$(</etc/hostname)

if [[ "$OSTYPE" == "linux-gnu"* ]]; then
  source /etc/os-release
  export DISTRO=$ID
elif [[ "$OSTYPE" == "darwin"* ]]; then
  export DISTRO="mac"
fi

# Dotfiles config dirs
export DF_SETUP_DIR="$DOTFILES/cmdlets/share/df/setup"
export DF_PLATFORM_DIR="$DF_SETUP_DIR/platforms/$DISTRO"
export DF_DEVICE_DIR="$DF_PLATFORM_DIR/devices/$HOSTNAME"

# Config files and scripts.

# Shell profiles.
export DF_BASE_BASHRC="$DOTFILES/user_configs/sh/.bashrc"
export DF_PLATFORM_BASHRC="$DF_PLATFORM_DIR/$DISTRO.bashrc"
export DF_DEVICE_BASHRC="$DF_DEVICE_DIR/$HOSTNAME.bashrc"
export DF_BASE_ZPROFILE="$DOTFILES/user_configs/sh/.zprofile"
export DF_PLATFORM_ZPROFILE="$DF_PLATFORM_DIR/$DISTRO.zprofile"
export DF_DEVICE_ZPROFILE="$DF_DEVICE_DIR/$HOSTNAME.zprofile"
export DF_BASE_ZSHRC="$DOTFILES/user_configs/sh/.zshrc"
export DF_PLATFORM_ZSHRC="$DF_PLATFORM_DIR/$DISTRO.zshrc"
export DF_DEVICE_ZSHRC="$DF_DEVICE_DIR/$HOSTNAME.zshrc"

# Setup and installation scripts.
export DF_PLATFORM_PACKAGES="$DF_PLATFORM_DIR/$DISTRO-packages.txt"
export DF_PLATFORM_INIT_SCRIPT="$DF_PLATFORM_DIR/$DISTRO-init.sh"
export DF_PLATFORM_POSTSCRIPT="$DF_PLATFORM_DIR/$DISTRO-postscript.sh"

export DF_BREW_PACKAGES="$DF_SETUP_DIR/brew-packages.txt" # Used for MacOS and Ubuntu.K
