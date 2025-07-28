#!/bin/sh

# GUI Application Focus/Launch Manager
#
# This script handles GUI applications only - it does NOT manage tmux sessions.
# For TUI applications with tmux, use tmux_session_manager.sh instead.
#
# Functionality:
# - Focus existing application window if found
# - Launch application if not running
# - Set fullscreen on newly launched applications
# - Clean separation from tmux session management

APP_NAME="$1"
LAUNCH_CMD="$2"

echo "=== GUI App Manager ==="
echo "App: $APP_NAME"
echo "Launch Command: $LAUNCH_CMD"
echo "======================"

# Find any existing window of the target application
TARGET_WINDOW=$(yabai -m query --windows | jq --arg app "$APP_NAME" -r '.[] | select(.app == $app) | .id' | head -n 1)

if [ -n "$TARGET_WINDOW" ]; then
  echo "Found existing window: $TARGET_WINDOW"
  yabai -m window --focus "$TARGET_WINDOW"
else
  echo "No existing window found, launching application"
  eval "$LAUNCH_CMD"

  # Poll for up to 5 seconds for the new window to appear
  NEW_WINDOW_ID=""
  echo "Waiting for application window to appear..."

  for i in $( # 50 attempts * 0.1s sleep = 5s timeout
    seq 1 50
  ); do
    NEW_WINDOW_ID=$(yabai -m query --windows | jq --arg app "$APP_NAME" -r '.[] | select(.app == $app) | .id' | head -n 1)
    if [ -n "$NEW_WINDOW_ID" ]; then
      echo "New window appeared: $NEW_WINDOW_ID"
      break
    fi
    sleep 0.1
  done

  # Set fullscreen on the new window
  if [ -n "$NEW_WINDOW_ID" ]; then
    echo "Setting fullscreen for new window"
    yabai -m window "$NEW_WINDOW_ID" --toggle native-fullscreen
  else
    echo "Warning: Application window did not appear within timeout"
  fi
fi

echo "=== GUI App Manager Complete ==="
