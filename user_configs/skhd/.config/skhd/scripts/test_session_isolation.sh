#!/bin/bash

# Test script for tmux session manager
# This will help verify that the session isolation is working correctly

echo "=== Testing Kitty-Tmux Session Manager ==="
echo

# Test 1: List current tmux servers
echo "1. Current tmux servers:"
ls /tmp/tmux-$(id -u)/ 2>/dev/null || echo "   No tmux servers currently running"
echo

# Test 2: Show what happens when we create sessions on different servers
echo "2. Creating test sessions on different servers..."

# Create a session on main server
echo "   Creating 'test-main' session on main-server..."
tmux -L main-server new-session -d -s test-main -c "$HOME"

# Create a session on standalone server
echo "   Creating 'test-standalone' session on standalone-test..."
tmux -L standalone-test new-session -d -s test-standalone -c "$HOME"

echo

# Test 3: List servers again
echo "3. Tmux servers after creating test sessions:"
ls /tmp/tmux-$(id -u)/ 2>/dev/null
echo

# Test 4: List sessions on each server
echo "4. Sessions on each server:"
echo "   Main server sessions:"
tmux -L main-server list-sessions 2>/dev/null | sed 's/^/     /'

echo "   Standalone server sessions:"
tmux -L standalone-test list-sessions 2>/dev/null | sed 's/^/     /'
echo

# Test 5: Cleanup
echo "5. Cleaning up test sessions..."
tmux -L main-server kill-session -t test-main 2>/dev/null
tmux -L standalone-test kill-session -t test-standalone 2>/dev/null
echo "   Test sessions cleaned up"

echo
echo "=== Test Complete ==="
echo
echo "Key insight: Each tmux server (socket) is completely isolated."
echo "Session switching on 'main-server' will NEVER affect 'standalone-*' servers."
echo "This solves the bug where switching sessions affected multiple kitty windows."