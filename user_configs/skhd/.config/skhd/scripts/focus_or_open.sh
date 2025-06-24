#!/bin/sh

# Script to focus an application's window or open it, and optionally run a final command.
APP_NAME="$1"
LAUNCH_CMD="$2"
POST_CMD="$3" # The new, optional third argument

# Use jq's 'select' to find the window.
TARGET_WINDOW=$(yabai -m query --windows | jq --arg app "$APP_NAME" -r '.[] | select(.app == $app) | .id' | head -n 1)

if [ -n "$TARGET_WINDOW" ]; then
  # If the window exists, simply focus it.
  yabai -m window --focus "$TARGET_WINDOW"
else
  # If the window does not exist, launch the application.
  eval "$LAUNCH_CMD"

  # Poll for up to 5 seconds for the new window to appear.
  NEW_WINDOW_ID=""
  for i in $( # 50 attempts * 0.1s sleep = 5s timeout
    seq 1 50
  ); do
    NEW_WINDOW_ID=$(yabai -m query --windows | jq --arg app "$APP_NAME" -r '.[] | select(.app == $app) | .id' | head -n 1)
    if [ -n "$NEW_WINDOW_ID" ]; then
      break # Exit the loop once the window is found
    fi
    sleep 0.1
  done

  # If a new window was found, toggle fullscreen on it.
  if [ -n "$NEW_WINDOW_ID" ]; then
    yabai -m window "$NEW_WINDOW_ID" --toggle native-fullscreen
  fi
fi

# --- New Section ---
# After focusing or launching, run the post-command if it was provided.
if [ -n "$POST_CMD" ]; then
  eval "$POST_CMD"
fi
