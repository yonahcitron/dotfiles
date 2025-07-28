#!/bin/bash

# TUI Session Manager
# Manages tmux sessions in kitty windows with two modes:
# 1. Default mode: Switch to session in existing main kitty window
# 2. Standalone mode: Open/focus session in dedicated kitty window

SESSION_NAME="$1"
COMMAND="$2"
WORKING_DIR="$3"
STANDALONE_MODE="$4" # "standalone" or empty

# Default working directory if not provided
if [ -z "$WORKING_DIR" ]; then
  WORKING_DIR="$HOME"
fi

# Function to check if session exists
session_exists() {
  tmux has-session -t "$1" 2>/dev/null
}

# Function to find kitty window by title pattern
find_kitty_window() {
  local title_pattern="$1"
  yabai -m query --windows | jq --arg app "kitty" --arg pattern "$title_pattern" -r '.[] | select(.app == $app and (.title | contains($pattern))) | .id' | head -n 1
}

# Function to find main kitty window (any kitty not labeled as standalone)
find_main_kitty_window() {
  yabai -m query --windows | jq --arg app "kitty" -r '.[] | select(.app == $app and (.title | contains("standalone") | not)) | .id' | head -n 1
}

# Function to create session if it doesn't exist
create_session_if_needed() {
  local session="$1"
  local cmd="$2"
  local dir="$3"

  if ! session_exists "$session"; then
    if [ -n "$cmd" ]; then
      tmux new-session -d -s "$session" -c "$dir" "$cmd"
    else
      tmux new-session -d -s "$session" -c "$dir"
    fi
  fi
}

if [ "$STANDALONE_MODE" = "standalone" ]; then
  # STANDALONE MODE: Look for dedicated kitty window for this session
  STANDALONE_TITLE="standalone-$SESSION_NAME"
  TARGET_WINDOW=$(find_kitty_window "$STANDALONE_TITLE")

  if [ -n "$TARGET_WINDOW" ]; then
    # Found existing standalone window, just focus it
    yabai -m window --focus "$TARGET_WINDOW"
  else
    # Create session if needed
    create_session_if_needed "$SESSION_NAME" "$COMMAND" "$WORKING_DIR"

    # Launch new kitty window with session and custom title
    if [ -n "$COMMAND" ]; then
      kitty --title "$STANDALONE_TITLE" -e bash -c "cd '$WORKING_DIR' && tmux new-session -A -s '$SESSION_NAME' '$COMMAND'" &
    else
      kitty --title "$STANDALONE_TITLE" -e bash -c "cd '$WORKING_DIR' && tmux new-session -A -s '$SESSION_NAME'" &
    fi

    # Wait for window to appear and set fullscreen
    sleep 0.3
    NEW_WINDOW_ID=$(find_kitty_window "$STANDALONE_TITLE")
    if [ -n "$NEW_WINDOW_ID" ]; then
      yabai -m window "$NEW_WINDOW_ID" --toggle native-fullscreen
    fi
  fi
else
  # DEFAULT MODE: Use main kitty window and switch session
  MAIN_KITTY=$(find_main_kitty_window)

  if [ -n "$MAIN_KITTY" ]; then
    # Focus main kitty window
    yabai -m window --focus "$MAIN_KITTY"

    # Create session if needed
    create_session_if_needed "$SESSION_NAME" "$COMMAND" "$WORKING_DIR"

    # Switch to the target session
    # Try switch-client first (if we're inside tmux), then attach-session
    tmux switch-client -t "$SESSION_NAME" 2>/dev/null || tmux attach-session -t "$SESSION_NAME" 2>/dev/null
  else
    # No main kitty window found, create one
    create_session_if_needed "$SESSION_NAME" "$COMMAND" "$WORKING_DIR"

    if [ -n "$COMMAND" ]; then
      kitty --title "main-kitty" -e bash -c "cd '$WORKING_DIR' && tmux new-session -A -s '$SESSION_NAME' '$COMMAND'" &
    else
      kitty --title "main-kitty" -e bash -c "cd '$WORKING_DIR' && tmux new-session -A -s '$SESSION_NAME'" &
    fi

    # Wait for window to appear and set fullscreen
    sleep 0.3
    NEW_WINDOW_ID=$(find_kitty_window "main-kitty")
    if [ -n "$NEW_WINDOW_ID" ]; then
      yabai -m window "$NEW_WINDOW_ID" --toggle native-fullscreen
    fi
  fi
fi
