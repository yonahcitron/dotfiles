# This is particularly important for enabling user-level services after a fresh install from my custom arch-ISO installer.

###################################
##### Ensure Installed Daemons  #####
###################################

global_services=("iwd") # Critical services are started in arch-init. Enable ones that are only installed.
user_services=("pipewire" "pipewire-pulse" "wireplumber")

# Enable necessary systemd services on every startup, and when setting up for the first time in my custom arch-ISO chroot.
sudo systemctl enable $global_services
# Actually start the service daemons if for live system.
if sudo systemd-detect-virt --quiet --chroot; then
  echo "[WARNING] In chroot — enabling global service, but not starting them. Services will start on reboot."
else
  echo "[INFO] Starting global systemd services: ${global_services[@]}"
  sudo systemctl daemon-reload
  for service in "${global_services[@]}"; do
    sudo systemctl enable --now $global_services
  done
  if [[ $EUID -ne 0 ]]; then
    echo "[INFO] Running as non-root, starting user-level systemd services: ${user_services[@]}"
    for service in "${user_services[@]}"; do
      systemctl --user enable --now $user_services
    done
  fi
fi
systemctl --user enable --now $user_services
