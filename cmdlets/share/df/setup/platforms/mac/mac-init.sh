##############################
####### Applications #########
##############################
export PATH=$PATH:/opt/homebrew/bin
# Install programs not available through apt using linux-homebrew.
if ! command -v brew >/dev/null 2>&1; then # Install brew if not present
  echo "[INFO] Brew package manager not detected on system. Installing..."
  /bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"
fi

echo "[INFO} Installing brew packages..."
# Global packages (also installed on ubuntu)
xargs brew install <$DF_BREW_PACKAGES
# MacOS specific packages
xargs brew install <$DF_PLATFORM_BREW_PACKAGES
echo "[INFO} Brew packages successfully installed!"

# NOTE: Zsh is the default shell out the box for MacOS.
