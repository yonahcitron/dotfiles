# # Get absolute path to git repo
# repo="$DOTFILES"
# 
# # Fetch remote updates (non-blocking)
# git -C "$repo" fetch --quiet
# 
# # Compare local and remote refs
# LOCAL=$(git -C "$repo" rev-parse @)
# REMOTE=$(git -C "$repo" rev-parse @{u})
# BASE=$(git -C "$repo" merge-base @ @{u})
# 
# if [[ "$LOCAL" != "$REMOTE" ]]; then
#   echo "🔁 Remote changes detected in \$DOTFILES:"
#   git -C "$repo" --no-pager log --oneline "$LOCAL..$REMOTE"
#   echo ""
#   read "Press [Enter] to sync and apply updates or Ctrl+C to abort..."
#   echo "🔄 Syncing dotfiles..."
#   setup
# fi
# 

# Set up system paths for pyenv 
export PYENV_ROOT="$HOME/.pyenv"
[[ -d $PYENV_ROOT/bin ]] && export PATH="$PYENV_ROOT/bin:$PATH"
eval "$(pyenv init - zsh)"

#############################################
# DEVICE- AND PLATFORM-SPECIFIC CODE
#############################################

# Source specific .zprofiles
if [ -e "$DF_PLATFORM_ZPROFILE" ]; then
  source "$DF_PLATFORM_ZPROFILE"
fi

if [ -e "$DF_DEVICE_ZPROFILE" ]; then
  source "$DF_DEVICE_ZPROFILE"
fi
