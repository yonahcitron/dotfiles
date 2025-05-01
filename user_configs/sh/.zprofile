# # Get absolute path to git repo
# repo="$dotfiles"
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
#   echo "🔁 Remote changes detected in \$dotfiles:"
#   git -C "$repo" --no-pager log --oneline "$LOCAL..$REMOTE"
#   echo ""
#   read "Press [Enter] to sync and apply updates or Ctrl+C to abort..."
#   echo "🔄 Syncing dotfiles..."
#   setup
# fi
# 

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
