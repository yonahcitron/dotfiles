#############################
#####  Systemd daemons  #####
#############################

global_services="iwd systemd-networkd systemd-resolved kmonad"

# Enable necessary systemd services on every startup.
sudo systemctl enable $global_services

# Actually start the service daemons if for live system.
if sudo systemd-detect-virt --quiet --chroot; then
  echo "In chroot — enabling global service, but not starting them. Services will start on reboot."
else
  echo "Starting systemd services: $global_services"
  sudo systemctl daemon-reload
  sudo systemctl start $global_services
fi




user_services="pipewire pipewire-pulse wireplumber"
systemctl --user enable --now $user_services
