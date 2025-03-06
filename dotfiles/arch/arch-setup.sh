# This script can be run from the live arch install environment.
# Take the following steps:
#    - Connect to the internet with iwctl.
#    - Mount the partition on which you want to install arch.
#    - Install git and cd into a new directory in the home directory called `repos`.
#    - Run `git clone https://github.com/yonahcitron/dotfiles.git`.
#    - Run this script.

# Install yay to download packages from AUR.
# TODO: Add code here later.

# Install drivers for my wifi dongle plugged into my desktop.
sudo pacman -S --noconfirm usb_modeswitch
sudo usb_modeswitch -KW -v 0bda -p 1a2b
yay -S --noconfirm rtl8188gu # Download the driver - only windows drivers are installed on the device by default most likely.
sudo modprobe 8188gu # Load the driver into the kernel.
ip link show # Verify the new interface shows: probably called 'wlan1'
