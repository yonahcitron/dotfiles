########################################
##############   System   ##############
########################################
# TODO: At some point, maybe move some of this to device-specific scripts.

critical_global_services=("iwd" "systemd-networkd" "systemd-resolved")
# Enable necessary systemd services on every startup, and when setting up for the first time in my custom arch-ISO chroot.
sudo systemctl enable $critical_global_services
# Actually start the service daemons if for live system.
if sudo systemd-detect-virt --quiet --chroot; then
  echo "[WARNING] In chroot — enabling global service, but not starting them. Services will start on reboot."
else
  echo "[INFO] Starting global systemd services: ${critical_global_services[@]}"
  sudo systemctl daemon-reload
  for service in "${critical_global_services[@]}"; do
    sudo systemctl enable --now $critical_global_services
  done
fi

# **Hibernation**
if [ -n "$disable_hibernation_setup" ] || grep -q 'resume=' /etc/default/grub; then
  echo "skipping hibernation setup (disabled or already configured)."
else
  # list available partitions and prompt user to select the swap partition
  echo "listing all partitions and their fstype..."
  lsblk -o name,type,size,fstype,uuid,mountpoint
  echo
  read -rp "enter the device name for the swap partition (e.g. sda2, nvme0n1p2, etc.): " swap_part

  # construct full device path (assuming /dev prefix)
  device_path="/dev/${swap_part}"
  echo "The path to the swap partition is: $device_path"

  # get uuid of the chosen swap partition
  if ! blkid "$device_path" >/dev/null 2>&1; then
    echo "error: invalid partition specified or partition not found."
    exit 1
  fi
  swap_uuid=$(blkid -s uuid -o value "$device_path")

  # add 'resume=uuid=' to grub_cmdline_linux_default
  echo "adding 'resume=uuid=$swap_uuid' to grub_cmdline_linux_default..."
  sudo sed -i "s|\(GRUB_CMDLINE_LINUX_DEFAULT=\"[^\"]*\)|\1 resume=UUID=$SWAP_UUID|" /etc/default/grub

  # Ensure 'resume' hook is present in /etc/mkinitcpio.conf
  if ! grep -q 'resume' /etc/mkinitcpio.conf; then
    echo "Adding 'resume' hook to /etc/mkinitcpio.conf..."
    sudo sed -i 's/\(^HOOKS=.*\)filesystems/\1resume filesystems/' /etc/mkinitcpio.conf
  fi

  # Regenerate initramfs
  echo "Regenerating initramfs..."
  sudo mkinitcpio -P

  # Update GRUB configuration
  echo "Updating GRUB config..."
  sudo grub-mkconfig -o /boot/grub/grub.cfg

  echo "Hibernation setup complete. Please reboot for changes to take effect."
fi

# **Wifi**

# Function to check if a package is installed
check_installed() {
  pacman -Q $1 &>/dev/null
  return $?
}

# Ensure iwd and systemd-networkd are enabled and running
for service in iwd systemd-networkd; do
  if ! systemctl is-active --quiet $service; then
    echo "[INFO] Enabling and starting $service..."
    sudo systemctl enable --now $service
  else
    echo "[OK] $service is already running."
  fi
done

# Ensure /etc/systemd/network/25-wireless.network exists
NETWORK_CONF="/etc/systemd/network/25-wireless.network"
if [ ! -f "$NETWORK_CONF" ]; then
  echo "[INFO] Configuring network settings..."
  sudo tee $NETWORK_CONF >/dev/null <<EOF
[Match]
Name=wlan0

[Network]
DHCP=yes
EOF
  sudo systemctl restart systemd-networkd
fi

if ping -q -c 1 -W 1 1.1.1.1 >/dev/null; then

  echo "Internet is connected"
else
  echo "No internet connection"
  # Check if WiFi is already connected
  if sudo iwctl station wlan0 show | grep -q "connected"; then
    echo "[INFO] WiFi is already connected. Skipping WiFi setup."
  else
    # Scan for WiFi networks
    echo "[INFO] Scanning for available WiFi networks..."
    sudo iwctl station wlan0 scan
    sleep 2 # Give it time to scan

    # Display available networks
    echo "[INFO] Available networks:"
    sudo iwctl station wlan0 get-networks

    # Prompt user for WiFi details
    read -p "Enter WiFi SSID: " SSID
    read -s -p "Enter WiFi Password: " PASSWORD

    # Connect to the WiFi network
    echo "\n[INFO] Connecting to $SSID..."
    sudo iwctl station wlan0 connect "$SSID" <<<"$PASSWORD"

    # Check connection status
    if sudo iwctl station wlan0 show | grep -q "connected"; then
      echo "[SUCCESS] Successfully connected to $SSID!"
    else
      echo "[ERROR] Failed to connect. Check your SSID and password."
    fi
  fi
fi

##############################
####### Applications #########
##############################
# Install arch and aur files.
echo "Ensuring all the following packages are installed:"
cat $DF_PLATFORM_PACKAGES

# Ensure system and package databases are up-to-date.
sudo pacman -Syu

# Do this in .zprofile? Maybe not, have a think about the best architecture.
if ! command -v yay &>/dev/null; then
  # Install yay to access AUR packages
  previous_dir=$(pwd)
  echo ""
  echo "Installing yay to access AUR packages..."
  sudo pacman -S --noconfirm --needed base-devel git
  mkdir -p /tmp/yay-bin
  git clone https://aur.archlinux.org/yay.git /tmp/yay-bin
  cd /tmp/yay-bin
  makepkg --noconfirm -si
  yay --version
  sudo pacman -Rns --noconfirm $(pacman -Qdtq) # Remove unneeded dependencies after installation
  cd $previous_dir
  echo "yay installed successfully!"
else
  echo "yay is already installed."
fi

# Install all packages - syncing with package dbs already done from before.
xargs -a "$DF_PLATFORM_PACKAGES" yay -S --needed --noconfirm

# Get the full path of zsh
ZSH_PATH=$(which zsh)

# Change the default shell for the current user
if [[ "$SHELL" != "$ZSH_PATH" ]]; then
  echo "Changing default shell to zsh..."
  sudo chsh -s "$ZSH_PATH" "$USER"
fi

echo "Confirming zsh is the default shell..."
# Check if the change was successful
if [[ "$(getent passwd "$USER" | cut -d: -f7)" == "$ZSH_PATH" ]]; then
  echo "Confirmed zsh is the default shell."
else
  echo "Failed to change default shell."
fi
