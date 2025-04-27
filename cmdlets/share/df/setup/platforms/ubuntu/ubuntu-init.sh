##############################
####### Applications #########
##############################

echo "Ensuring all the following packages are installed:"
cat "$DF_PLATFORM_PACKAGES"

# Update package index
echo "[INFO] Updating package index..."
sudo apt update

# Install listed packages
echo "[INFO] Installing packages from $DF_PLATFORM_PACKAGES..."
xargs -a "$DF_PLATFORM_PACKAGES" sudo apt install -y
echo "Installed all packages for $DISTRO"

# Install programs not easily available through apt

if [ ! -e /usr/local/bin/lazygit ]; then
  echo "Lazygit not installed. Installing with curl."
  LAZYGIT_VERSION=$(curl -s "https://api.github.com/repos/jesseduffield/lazygit/releases/latest" | \grep -Po '"tag_name": *"v\K[^"]*')
  curl -Lo lazygit.tar.gz "https://github.com/jesseduffield/lazygit/releases/download/v${LAZYGIT_VERSION}/lazygit_${LAZYGIT_VERSION}_Linux_x86_64.tar.gz"
  tar xf lazygit.tar.gz lazygit
  sudo install lazygit -D -t /usr/local/bin/
fi

##############################
####### Shell setup ##########
##############################

# Get the full path of zsh
ZSH_PATH=$(which zsh)

if [ -z $ZSH_PATH ]; then
    echo "Zsh is not installed. Please add zsh to the package install list and run the setup script again."
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
