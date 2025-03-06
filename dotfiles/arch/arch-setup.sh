# TODO: Separate all arch / AUR package installs into a SEPARATE file.
# TODO: Then, in the actual system config file, make a *function* like "pacman-add" and "yay-add" that try to
#	install the file, passing ALL flags that I do, and, if successful, afterwards add it to my pacman and yay
#	list of things I've installed (and prints out that I've done so to the terminal to remind me its happening)
#       and then adds and commits it to git (after doing a git pull to get the latest changes ofc).
#	If there ARE changes from the remote git, it should pull those and ENSURE they are installed first before
#	continuing. This might have happened for example if there was no internet at startup - it ensures everything
#       is in sync.
#       Make the git message have something to show it's auto-generated from my custom "pacman-add" / "yay-add" function.
# TODO: Set a script at startup to see if there have been any changes to my dotfiles remote.
#	Make it check whether there's internet first, and display a
#	Make it run in the HYPRLAND main login terminal, so I can see exactly what's going on and what's being downloaded.
#	I can just start a new terminal session to the side if I need to do stuff if its taking a while.
#		- Likely actually start it AFTER I've done my login... i.e. it's not the first thing that should happen;
#		  first it should prompt me for login (soon I'll set this up with fingerprint hopefully), and only then
#		  should it run the startup script to ensure that each computer is up-to-date with the other. 	
# TODO: Make a "dotfiles-sync" bash function that allows me to update them to git from anywhere.
#		- This is useful because I'll be editing many of the dotfiles via their symlinks, which are not in their 
#		  native git folder. This function allows me to access it globally (also maybe make a global $dotfiles variable
#		  at startup in bash). Maybe can also deal with syncing issues, but make sure that I can handle conflicts
#		  manually if needs be. 

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
