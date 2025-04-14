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

