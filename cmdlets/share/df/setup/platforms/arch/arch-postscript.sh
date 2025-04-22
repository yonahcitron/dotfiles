#############################
#####  Systemd daemons  #####
#############################

sudo systemctl daemon-reload

sudo systemctl enable udevmon.service
systemctl --user enable pipewire pipewire-pulse wireplumber

if ! systemctl --quiet is-system-running; then
  echo "In chroot — skipping service start"
else
  echo "Starting services..."
  sudo systemctl start udevmon.service
  systemctl --user start pipewire pipewire-pulse wireplumber
fi
