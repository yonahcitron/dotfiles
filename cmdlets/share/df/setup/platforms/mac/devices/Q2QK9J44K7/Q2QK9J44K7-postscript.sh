# --- Apply key remappings at every startup to make it more ergonomic ---
# Left Control	0x7000000E0	0x7000000E0
# Left Option (Alt)	0x7000000E2	0x7000000E2
# Left Command	0x7000000E3	0x7000000E3
# Right Option (Alt)	0x7000000E6	-
# Right Command	0x7000000E7	-
echo "Applying custom keymappings for the internal macos keyboard..."

# NOTE: I have set the plist file to *just apply to the keyboard of my current M1*, so that it does not remap any external keyboards.
#       To get the remap to apply to another inbuilt mac keyboard, I'll need to add its specific details to the plist file as well.

ln -sf ~/repos/dotfiles/cmdlets/share/df/setup/platforms/mac/devices/Q2QK9J44K7/plist/com.user.customkeymappings.plist ~/Library/LaunchAgents/com.user.customkeymappings.plist

SERVICE_LABEL="customkeymappings"
if launchctl list | grep -q "$SERVICE_LABEL"; then
  # Exit code 0 means grep found the service.
  echo "Service '$SERVICE_LABEL' is already loaded. No action taken."
else
  # Exit code non-zero means grep did not find the service.
  echo "Service '$SERVICE_LABEL' not found. Bootstrapping now..."
  launchctl bootstrap gui/$(id -u) ~/Library/LaunchAgents/com.user.customkeymappings.plist
fi
