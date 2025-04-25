##############################
####### Applications #########
##############################

PACKAGES_FILE="$dotfiles/cmdlets/share/df/setup/platforms/ubuntu/ubuntu-packages.txt"
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

sudo apt install -y stow
