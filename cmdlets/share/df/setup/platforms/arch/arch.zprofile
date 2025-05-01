# Run systemctl to ensure the right services are enabled at every login; the commands are idempotent.
# This is particularly important for enabling user-level services after a fresh install from my custom arch-ISO installer.
user_services="pipewire pipewire-pulse wireplumber"
systemctl --user enable --now $user_services
