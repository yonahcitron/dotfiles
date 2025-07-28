#!/bin/bash

# Kitty-Tmux Session Manager
#
# This script manages tmux sessions with complete isolation between kitty windows.
# It uses separate tmux servers (via socket names) to ensure session switching
# in one kitty window never affects sessions in other kitty windows.
#
# Two modes of operation:
# 1. MAIN MODE (default): Use main kitty window with main tmux server
# 2. STANDALONE MODE: Use dedicated kitty window with isolated tmux server
#
# Key features:
# - Complete session isolation between windows
# - Reliable window targeting and focusing
# - Clear naming conventions for easy debugging
# - Robust error handling and logging

# ============================================================================
# Arguments and Configuration
# ============================================================================
SESSION_NAME="$1"
COMMAND="$2"
WORKING_DIR="$3"
STANDALONE_MODE="$4" # "standalone" or empty

# Window identification constants
MAIN_KITTY_TITLE_PREFIX="main-kitty"
STANDALONE_TITLE_PREFIX="standalone"

# Tmux server socket names for isolation
MAIN_TMUX_SERVER="main-server"
STANDALONE_TMUX_SERVER="standalone-$SESSION_NAME"

# Default working directory if not provided
if [ -z "$WORKING_DIR" ]; then
  WORKING_DIR="$HOME"
fi

# ============================================================================
# Helper Functions
# ============================================================================

# Check if a session exists on a specific tmux server
session_exists() {
  local session_name="$1"
  local server_socket="$2"
  tmux -L "$server_socket" has-session -t "$session_name" 2>/dev/null
}

# Find kitty window by title pattern
find_kitty_window_by_title() {
  local title_pattern="$1"
  yabai -m query --windows | jq --arg app "kitty" --arg pattern "$title_pattern" -r '.[] | select(.app == $app and (.title | contains($pattern))) | .id' | head -n 1
}

# Find the main kitty window (excludes standalone windows)
find_main_kitty_window_id() {
  yabai -m query --windows | jq --arg app "kitty" --arg standalone_prefix "$STANDALONE_TITLE_PREFIX" -r '.[] | select(.app == $app and (.title | contains($standalone_prefix) | not)) | .id' | head -n 1
}

# Create tmux session on specified server if it doesn't exist
create_session_if_needed() {
  local session="$1"
  local cmd="$2"
  local dir="$3"
  local server_socket="$4"

  if ! session_exists "$session" "$server_socket"; then
    echo "Creating new tmux session: $session on server: $server_socket"
    if [ -n "$cmd" ]; then
      tmux -L "$server_socket" new-session -d -s "$session" -c "$dir" "$cmd"
    else
      tmux -L "$server_socket" new-session -d -s "$session" -c "$dir"
    fi
  else
    echo "Tmux session already exists: $session on server: $server_socket"
  fi
}

# Launch new kitty window with tmux session on specific server
launch_kitty_with_session() {
  local title="$1"
  local session_name="$2"
  local command="$3"
  local working_dir="$4"
  local server_socket="$5"

  echo "Launching new kitty window: $title (server: $server_socket)"

  if [ -n "$command" ]; then
    kitty --title "$title" -e bash -c "cd '$working_dir' && tmux -L '$server_socket' new-session -A -s '$session_name' '$command'" &
  else
    kitty --title "$title" -e bash -c "cd '$working_dir' && tmux -L '$server_socket' new-session -A -s '$session_name'" &
  fi

  # Wait for window to appear and set fullscreen
  sleep 0.5
  local new_window_id=$(find_kitty_window_by_title "$title")
  if [ -n "$new_window_id" ]; then
    echo "Setting fullscreen for window: $new_window_id"
    yabai -m window "$new_window_id" --toggle native-fullscreen
  else
    echo "Warning: Could not find newly created kitty window"
  fi
}

# ============================================================================
# Main Execution Logic
# ============================================================================

echo "=== Kitty-Tmux Session Manager ==="
echo "Session: $SESSION_NAME"
echo "Command: ${COMMAND:-'(default shell)'}"
echo "Working Dir: $WORKING_DIR"
echo "Mode: ${STANDALONE_MODE:-'main'}"
echo "======================================="

if [ "$STANDALONE_MODE" = "standalone" ]; then
  # ==========================================================================
  # STANDALONE MODE: Dedicated kitty window for this session
  # Uses isolated tmux server to prevent interference with main window
  # ==========================================================================
  STANDALONE_TITLE="$STANDALONE_TITLE_PREFIX-$SESSION_NAME"
  TARGET_WINDOW=$(find_kitty_window_by_title "$STANDALONE_TITLE")

  echo "Using standalone tmux server: $STANDALONE_TMUX_SERVER"

  if [ -n "$TARGET_WINDOW" ]; then
    echo "Found existing standalone window: $TARGET_WINDOW"
    yabai -m window --focus "$TARGET_WINDOW"
  else
    echo "No existing standalone window found, creating new one"

    # Create session on standalone server
    create_session_if_needed "$SESSION_NAME" "$COMMAND" "$WORKING_DIR" "$STANDALONE_TMUX_SERVER"

    # Launch new standalone kitty window with isolated tmux server
    launch_kitty_with_session "$STANDALONE_TITLE" "$SESSION_NAME" "$COMMAND" "$WORKING_DIR" "$STANDALONE_TMUX_SERVER"
  fi
else
  # ==========================================================================
  # MAIN MODE: Use primary kitty window with main tmux server
  # Session switching only affects the main tmux server, not standalone ones
  # ==========================================================================
  MAIN_KITTY_ID=$(find_main_kitty_window_id)

  echo "Using main tmux server: $MAIN_TMUX_SERVER"

  if [ -n "$MAIN_KITTY_ID" ]; then
    echo "Found main kitty window: $MAIN_KITTY_ID"

    # Focus main kitty window
    yabai -m window --focus "$MAIN_KITTY_ID"

    # Create session on main server if needed
    create_session_if_needed "$SESSION_NAME" "$COMMAND" "$WORKING_DIR" "$MAIN_TMUX_SERVER"

    # Switch to session on main server (isolated from standalone servers!)
    echo "Switching to session '$SESSION_NAME' on main tmux server"
    tmux -L "$MAIN_TMUX_SERVER" switch-client -t "$SESSION_NAME" 2>/dev/null || {
      echo "Switch failed, trying attach to main server"
      tmux -L "$MAIN_TMUX_SERVER" attach-session -t "$SESSION_NAME" 2>/dev/null
    }
  else
    echo "No main kitty window found, creating new one"

    # Create session on main server
    create_session_if_needed "$SESSION_NAME" "$COMMAND" "$WORKING_DIR" "$MAIN_TMUX_SERVER"

    # Launch new main kitty window with main tmux server
    launch_kitty_with_session "$MAIN_KITTY_TITLE_PREFIX" "$SESSION_NAME" "$COMMAND" "$WORKING_DIR" "$MAIN_TMUX_SERVER"
  fi
fi

echo "=== Session Manager Complete ==="
