# Import global variables.
# set -euo pipefail # TODO: Debug why there is an unbound local variable error here with set -u.
set -eo pipefail
source $HOME/repos/dotfiles/user_configs/bash/.bashrc # This works even after the first install, when my bashrc has not been sourced on startup.
: "${dotfiles:?Environment variable 'dotfiles' must be set.}"

########################################
##############   System   ##############
########################################

# **Hibernation**
if [ -n "$DISABLE_HIBERNATION_SETUP" ] || grep -q 'resume=' /etc/default/grub; then
  echo "Skipping hibernation setup (disabled or already configured)."
else
  # List available partitions and prompt user to select the swap partition
  echo "Listing all partitions and their FSTYPE..."
  lsblk -o NAME,TYPE,SIZE,FSTYPE,UUID,MOUNTPOINT
  echo
  read -rp "Enter the device name for the swap partition (e.g. sda2, nvme0n1p2, etc.): " SWAP_PART

  # Construct full device path (assuming /dev prefix)
  DEVICE_PATH="/dev/${SWAP_PART}"

  # Get UUID of the chosen swap partition
  if ! blkid "$DEVICE_PATH" &>/dev/null; then
    echo "Error: Invalid partition specified or partition not found."
    exit 1
  fi
  SWAP_UUID=$(blkid -s UUID -o value "$DEVICE_PATH")

  # Add 'resume=UUID=' to GRUB_CMDLINE_LINUX_DEFAULT
  echo "Adding 'resume=UUID=$SWAP_UUID' to GRUB_CMDLINE_LINUX_DEFAULT..."
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

PACKAGES_FILE=$dotfiles/setup/platforms/arch/arch-packages.txt # $dotfiles is defined in .bashrc
echo "Ensuring all the following packages are installed:"
cat $PACKAGES_FILE

# TODO: Install this in the chroot script!!
# any prerequisites, I don't need to do every time!
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

# Install all packages
yay -Syyu --noconfirm
xargs -a "$PACKAGES_FILE" yay -S --needed --noconfirm

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

###################################
########## User Configs ###########
###################################

working_dir=$(pwd)
user_account="yonah"
local_bin="$HOME/.local/bin"
mkdir -p $local_bin # This folder is added to the PATH in the .bashrc file.
sudo chmod +x $local_bin/*

# Symlink the setup script to the local bin directory.
source_setup="$dotfiles/setup/platforms/arch/arch-setup.sh"
symlink_setup="$local_bin/setup"
if [ -L $symlink_setup ]; then
  echo "Setup symlink already exists at: $symlink_setup. Skipping."
elif [ -e $symlink_setup ]; then
  echo "A non-symlink file already exists at $symlink_setup. Skipping."
else
  echo "Creating symlink: $symlink_setup -> $source_setup"
  ln -s "$source_setup" "$symlink_setup"
fi

if [ -e "$HOME/.bashrc" ] && [ ! -L "$HOME/.bashrc" ]; then
  echo "The .bashrc file exists and is NOT a symlink. Deleting."
  rm $HOME/.bashrc
fi

# TODO: In order to get the intended functionality of treating each of the subfolders of the stow dir as a module, and reacreate each of their substructures within the target dirs, rather than just dumping them in the target dir directly, the cd approach was working best. Look into whether it could work with specifying the dir, it wasn't last time I tried.

cd $dotfiles
sudo pacman -S --noconfirm stow

echo "Setting up Yonah's user configs."
cd $dotfiles/user_configs
stow --target $HOME */ # User configs.

# Global configs.
echo "Setting up Yonah's global configs."
cd $dotfiles/global_configs
# Stowing as root should give root ownership of the symlinks.
# The files they link to should be user-owned, to not interfere with git.
sudo stow --target /etc */

cd $working_dir

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
