#############################
#####  Systemd daemons  #####
#############################

sudo systemctl daemon-reload

# Using a template service to enable multiple kmonad services for each device.
# TODO: Use conditional per-device logic here to start the correct services.
# REMEMBER: When enabling new remappings, be sure to test them first just using the kmonad cli, and only THEN add them as a service to make sure they work! Will save me time in the long run.
sudo systemctl enable kmonad@thinkpad-keyboard-remap.service
systemctl --user enable pipewire pipewire-pulse wireplumber

if ! systemctl --quiet is-system-running; then
  echo "In chroot — skipping service start"
else
  echo "Starting services..."
  sudo systemctl start kmonad@thinkpad-keyboard-remap.service
  systemctl --user start pipewire pipewire-pulse wireplumber
fi
