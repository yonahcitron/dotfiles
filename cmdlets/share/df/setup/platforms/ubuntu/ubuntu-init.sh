##############################
####### Applications #########
##############################

echo "Ensuring all the following packages are installed:"
cat "$DF_PLATFORM_PACKAGES"

# Update package index.
echo "[INFO] Updating package index..."
sudo apt update

# Install listed packages.
echo "[INFO] Installing .deb packages from $DF_PLATFORM_PACKAGES..."
xargs -a "$DF_PLATFORM_PACKAGES" sudo apt install -y
echo "Installed all .deb packages for $DISTRO"

# Install programs not available through apt using linux-homebrew.
if ! command -v brew >/dev/null 2>&1; then # Install brew if not present
  echo "[INFO] Brew package manager not detected on system. Installing..."
  /bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"
fi

echo "[INFO} Installing brew packages..."
xargs brew install <$DF_BREW_PACKAGES
echo "[INFO} Brew packages successfully installed!"

######### Other Applications ###########
brew tap d99kris/nchat
brew install nchat
# Install pyenv
curl -fsSL https://pyenv.run | bash

##############################
####### Shell setup ##########
##############################

# Get the full path of zsh
ZSH_PATH=$(which zsh)

if [ -z $ZSH_PATH ]; then
  echo "Zsh is not installed. Please add zsh to the package install list and run the setup script again."
  exit 0
fi

# Change the default shell for the current user
if [[ "$SHELL" != "$ZSH_PATH" ]]; then
  echo "Changing default shell to zsh..."
  echo "The zsh path is $ZSH_PATH"
  sudo chsh -s "$ZSH_PATH" "$USER"
fi

echo "Confirming zsh is the default shell..."
if [[ "$(getent passwd "$USER" | cut -d: -f7)" == "$ZSH_PATH" ]]; then
  echo "Confirmed zsh is the default shell."
else
  echo "Failed to change default shell."
fi
