#############################
#####  Systemd daemons  #####
#############################

global_services="iwd systemd-networkd udevmon.service"
user_services="pipewire pipewire-pulse wireplumber"

# Enable necessary systemd services on every startup.
sudo systemctl enable $global_services

# Actually start the service daemons if for live system.
if systemd-detect-virt --quiet --chroot; then
  echo "In chroot — skipping service start. Services will start on reboot."
else
  # TODO: In future put this in the .zprofile...
  systemctl --user enable $user_services
  echo "Starting systemd services..."
  sudo systemctl daemon-reload
  sudo systemctl start $global_services
  systemctl --user start $user_services
fi
