gh extension install github/gh-copilot

############################
# Pyenv setup
############################

# 1. Find the latest available stable Python 3 version from the list
LATEST_VERSION=$(pyenv install --list | grep -E '^\s*3\.[0-9]+\.[0-9]+$' | tail -1 | tr -d ' ')
# 2. Check if that version is already installed before trying to install it
if pyenv versions --bare | grep -q "^${LATEST_VERSION}$"; then
  echo "Latest Python version ($LATEST_VERSION) is already installed."
else
  echo "New Python version ($LATEST_VERSION) found. Installing..."
  pyenv install "$LATEST_VERSION"
fi
# 3. Set the latest installed version as the global default
pyenv global "$(pyenv versions --bare | grep -E '^3\.' | tail -1)"
