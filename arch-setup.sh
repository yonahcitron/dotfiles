# 1. Move this into /tools/bin and remove the .sh suffix.
# 2. This should I mean I can execute it from anywhere using arch-setup.
# 3. Eventually refactor this whole script into the 'df' cmdlet, and make it so that I can run it with 'df setup arch'... and then eventually if I wanna include other distros I can do like 'df setup ubuntu' etc... or if I wanna be more granular with specific device configs.
#    - Say I have a home server with specific configurations, I can run `df setup arch home-server` ... and if I pass no args like `df setup arch`, it should check first my .local folder for configs (in dotfiles repo), then my hostname for which device I'm running it on, and if it can't find a matching device should ask me to pick one. There should be a 'default' for each OS which contains all the base settings, and anything device / setup specific will go in the specific dirs for that setup....
#    - Once I've run the setup once, it should save in a .local folder in 'dotfiles' repo that stores the identity of the machine and any other identifiers... and then going forward I can just run `df sync`... however this should basically just be a shorthand for `df setup arch XXXX`... so `df sync` basically just looks for the appropriate pre-configured settings locally (if found), and passes them to `df setup`. If the args are not found it should search / prompt...
#         - So actually I think it might be better if `df setup` requires ALL args to be passed, returning the possible options, but doesn't do anythign by default... the higher-level API will be `df setup` I think...

# 4. Ensure hibernation is configured, and if not, configure it. Make an auto-script for this.

# Import global variables.
set -e
source $HOME/repos/dotfiles/user_configs/bash/.bashrc

#####################
#####  Todos  #######
#####################
# TODO: Make it that when I scroll vim on my thinkpad with the thinkpad button thing in red, the mouse goes like two thirds of the way to the bottom, and THEN starts scrolling.
# TODO: Ensure that I install the VIM-ONLY plugins as a part of my arch-setup script.. basically just want the one ... that does vim-wayland stuff!!
# TODO: Currently I'm symlinking .arch-setup.sh to home for ease of access. When I implement my little 'dotfiles' cmdlet, make a command like 'dotfiles install' or something that basicallly runs the script (from the dotfiles original repo itself), and this will remove the need to have the .arch-setup.sh script in the home dir at all. Just get the cmdlet working!
# TODO: Ensure that I install and load the uinput kernel module every time.
# TODO: I think replace logid with kmonad as it's easier and more reliable.
# TODO: Implement this for using the same keybindings between nvim and hyprland: https://www.reddit.com/r/hyprland/comments/1blmxcm/tmux_hyprland_and_neovim_windowpane_navigation/
# TODO: I've been really liking the simplicity of black background etc that vim provides out the box. Set up as many as I can of the configs in the vimrc itself, make sure that I import / use them in my nvim configs, and only put things in the nvim configs that can't be done in vim itself. This means depending on my mood I can use either vim or nvim easily, and I can always configure nvim to be more simple with time... just depends on what I'm feeling etc.
# TODO: Take away the prompt, if it persists, that asks everytime if I wanna exit zsh when I click super +c.
# TODO: Add relative line-numbers to vim and nvim. Start using nvim more as I configure it more and more.
# TODO: Separate all arch / AUR package installs into a SEPARATE file.
# TODO: Then, in the actual system config file, make a *function* like "pacman-add" and "yay-add" that try to
#	install the file, passing ALL flags that I do, and, if successful, afterwards add it to my pacman and yay
#	list of things I've installed (and prints out that I've done so to the terminal to remind me its happening)
#       and then adds and commits it to git (after doing a git pull to get the latest changes ofc).
#	If there ARE changes from the remote git, it should pull those and ENSURE they are installed first before
#	continuing. This might have happened for example if there was no internet at startup - it ensures everything
#       is in sync.
#       Make the git message have something to show it's auto-generated from my custom "pacman-add" / "yay-add" function.
# TODO: Add the .p10k file in the root of my pc to my dotfiles repo and stow. This will get my custom configs here!
#       Check that the theme is also working on the laptop, as well as the files and that everything looks the same.
#       Make the background of the windows etc more transparent.
# TODO: Make the whole setup with a shortcut to the battery display and header bar with some stats (like wifi etc), that also simultaneously opens the quick one-time command prompt for running little things like `power` etc.
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
# TODO: Move the location of arch-setup.sh BACK to just the dotfiles root (i.e. so it's not stowed).
#	Instead I SHOULD stow the dependencies file for pacman and yay (whatever I decide to call it!!).
# This script can be run from the live arch install environment.
# Take the following steps:
#    - Connect to the internet with iwctl.
#    - Mount the partition on which you want to install arch.
#    - Install git and cd into a new directory in the home directory called `repos`.
#    - Run `git clone https://github.com/yonahcitron/dotfiles.git`.
#    - Run this script.
# TODO: Things to install - nvim, todoist-appimage (with yay)
# TODO: Once I've remapped the escape key to the caps lock, be sure to undo the 'jk' keymappings I have set up in nvim etc.

# TODO: Soon move my arch-install.sh into this folder, and call it arch-setup or something. I'll need to change the paths in it to where it's instaled new.
# TODO: Document in THIS file that this one should be used whilst in the live usb, and should be manually copied to the live usb for first setup. The other one should be run (document it there) whenever I want to sync my system, or at first install, in my user shell. I think go and configure an env variable for first setup.

#############################
######  Prerequisites ########
##############################

# - Install arch from the live usb.
# 	- Allocate the main and swap partitions, and UEFI partition if one doesn't already exist.
#	- Mount the main filesystem to /mnt , and the boot (UEFI) parition to /mnt/boot .
#	 run:
#       ` pacstrap -K /mnt base linux linux-firmware `
#       - Run `arch-chroot /mnt`, then:
#             - `pacman --noconfirm -S iwd grub efibootmgr` # Wifi and boot systems
#	      - `passwd` # Set password for root user
#             - `useradd -m -G wheel yonah && passwd yonah`
#             - ` grub-install --target=x86_64-efi --efi-directory=/boot --bootloader-id=GRUB
#	      - grub-mkconfig -o /boot/grub/grub.cfg
# IN THIS BOOTSTRAP SECTION, ALSO INSTALL VIM AND GIT!!
# Also configure sudo-ers in the bootstrap section so that i don't need to manually do anything in root...
# Restart the system and boot into the new install.
# Also make sure to install stow in the bootstrap section and also sudo and edit the list of sudoers etc.
# also set up git email and username so I don't have to configure it first time... for privacy, like the guy online said... don't actually give my REAL email, find the github anonymous email or whatever it's called... (look this up online!)
#

#### Other
# - As part of the initial setup, on first boot (check whether these things are installed and install them if they're not):
## These things are on the arch setup page
##	- Setting up fstab
#	- Set up time zone
#	- localization
#	- network configuration (/etc/hostname)
#- Download my (public) dotfiles repo and run it.
#        - Also make configuring the default fonts for system, for hyprland, etc , part of the setup
#	- Configure hibernation for the system if I want it (maybe make an automated script that does so for me by printing each of the paritions and asking which one to use IF there is a swap partition mounted).
#	- also make the sure todoist image is installed).
#- Separate out the functionalities of (some) of the different parts of the script so that I can re-use or whatever the parts that I want to.
#- Also make a thing that WHENEVER the super key in hyprland is held down, it automatically shows (in the top right) the workspace number! this would be very convenient..
#	- Also potentially start giving workspace numbers fixed names... like "1: Chrome", "2: Tmux", "5: Whatsapp", etc etc... make them also print on the top right as well as the number!! so that I get a sense of WHERE I am in the workspace manager and what each workspace should be used for...
#		This will also help teach me that if I'm opening too many tabs in a workspace not designed for that, I should create an ADDITIONAL workspace rather than trying to crowd one workspace with just that!!!!
#

#############################
######  Prerequisites ########
##############################

# - Install arch from the live usb.
# 	- Allocate the main and swap partitions, and UEFI partition if one doesn't already exist.
#	- Mount the main filesystem to /mnt , and the boot (UEFI) parition to /mnt/boot .
#	 run:
#       ` pacstrap -K /mnt base linux linux-firmware `
#       - Run `arch-chroot /mnt`, then:
#             - `pacman --noconfirm -S iwd grub efibootmgr` # Wifi and boot systems
#	      - `passwd` # Set password for root user
#             - `useradd -m -G wheel yonah && passwd yonah`
#             - ` grub-install --target=x86_64-efi --efi-directory=/boot --bootloader-id=GRUB
#	      - grub-mkconfig -o /boot/grub/grub.cfg
# IN THIS BOOTSTRAP SECTION, ALSO INSTALL VIM AND GIT!!
# Also configure sudo-ers in the bootstrap section so that i don't need to manually do anything in root...
# Restart the system and boot into the new install.
# Also make sure to install stow in the bootstrap section and also sudo and edit the list of sudoers etc.
# also set up git email and username so I don't have to configure it first time... for privacy, like the guy online said... don't actually give my REAL email, find the github anonymous email or whatever it's called... (look this up online!)
###########################
##### First-time setup ####
###########################
# TODO: In general, in nvim, find a good way to make 'section headers' (maybe using some sort of autosyntax, to generate the above style uusing ### (the same as in hypr.conf)... and then find a good way to list them and navigate to them quickly in nvim...
#- Also make a way to do search using / in an case-insensitive way (although not by default... also make a way to do a add-commit-push git workflow with some automated message... for now could jsut be 'trivial change'... but in the future could use chatgpt for this or something... or copilot.. ?? look around what exists online

# TODO: HERE INSTALL ALL THE THINGS LISTED IN THE TO-DO.MD, still to be done!!

# remove all the extraneous things here and just make it bullet points!!

# Function to check if a package is installed
check_installed() {
  pacman -Q $1 &>/dev/null
  return $?
}

# Check if iwd is installed
if ! check_installed iwd; then
  echo "[ERROR] 'iwd' is not installed. Please install it first using the live USB:"
  echo "sudo pacman -S iwd"
  exit 1
fi

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

##############################
###### Install Configs #######
##############################

WORKING_DIR=$(pwd)
USER_ACCOUNT="yonah"

# Also symlink the todo.md for easy access
source_setup="$dotfiles/arch-setup.sh"
symlink_setup="/home/$USER_ACCOUNT/.arch-setup.sh"
if [ -L $symlink_setup ]; then
  echo "Symlink already exists: $symlink_setup"
elif [ -e "/home/$user_account/.arch-setup.sh" ]; then
  echo "a regular file or directory exists at the target location. not creating symlink."
else
  ln -s "$source_setup $symlink_todo"
  echo "Symlink created: $symlink_todo -> $source_setup"
fi

if [ ! -L "/home/yonah/.bashrc" ]; then
  echo "The .bashrc file is NOT a symlink, and hence is an auto-generated config template. Deleting."
  rm /home/yonah/.bashrc
fi

# Also symlink the todo.md for easy access
source_todo="$dotfiles/TODO.md"
symlink_todo="/home/$USER_ACCOUNT/TODO.md"
if [ -L $symlink_todo ]; then
  echo "Symlink already exists: $symlink_todo"
else
  ln -s $source_todo $symlink_todo
  echo "Symlink created: $symlink_todo -> $source_todo"
fi

# In order to get the intended functionality of treating each of the subfolders of the stow dir as a module, and reacreate each of their substructures within the target dirs, rather than just dumping them in the target dir directly, we *must* use the cd approach. This is why we can specify the --dir directly for our command which would be more elegant.
echo "Setting up Yonah's user configs."
cd $dotfiles/user_configs
stow --target /home/$USER_ACCOUNT */ # User configs.

# Global configs.
echo "Setting up Yonah's global configs."
cd $dotfiles/global_configs
# Stowing as root should give root ownership of the symlinks.
# The files they link to should be user-owned, to not interfere with git.
sudo stow --target /etc */

# Executable scripts etc.
# This folder is added to the PATH in the .bashrc file.
# Add the tools as binaries once they're installed.
echo "Installing custom scripts as executables."
cd $dotfiles
mkdir -p $HOME/.local
# Stow all folders within the tools directory.
stow --target $HOME/.local tools
if [ -d "$HOME/.local/bin" ]; then
  chmod +x $HOME/.local/bin/*
fi
cd $WORKING_DIR

##############################
#### Install Local files #####
##############################

# Install arch and aur files.

PACKAGES_FILE=$dotfiles/packages.txt # $dotfiles is defined in .bashrc
echo "Ensuring all the following packages are installed:"
cat $PACKAGES_FILE

if ! command -v yay &>/dev/null; then
  # Install yay to access AUR packages
  sudo pacman -S --noconfirm --needed base-devel git
  git clone https://aur.archlinux.org/yay-bin.git
  cd yay-bin
  makepkg -si
  yay --version
  cd ..
  rm -rf yay-bin
  echo "yay installed successfully!"
else
  echo "yay is already installed."
fi

# Install all packages
yay -Syyu --noconfirm
xargs -a "$PACKAGES_FILE" yay -S --needed --noconfirm



# TODO: Set up good system font etc. Currently I am downlaoding one from yay.
#       Set up jetbrains mono for the terminal etc, and maybe something different for chrome?
#       Although anyways I think it by default has a different font, double-check on this though.
# TODO: Maybe implement some keybinding (also maybe in hyprland.conf) to open a quick central command popup window to run single short quick commandd, rather than having to go to a whole terminal... e.g. 'power' just to see quick status of battery etc..

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

# Optional: Start zsh immediately
if [[ "$SHELL" != "$ZSH_PATH" ]]; then
  echo "Starting zsh..."
  exec zsh
fi

#############################
#####  Systemd daemons  #####
#############################

sudo systemctl daemon-reload

# Using a template service to enable multiple kmonad services for each device.
# TODO: Use conditional per-device logic here to start the correct services.
# REMEMBER: When enabling new remappings, be sure to test them first just using the kmonad cli, and only THEN add them as a service to make sure they work! Will save me time in the long run.
sudo systemctl enable --now kmonad@thinkpad-keyboard-remap.service
systemctl --user enable --now pipewire pipewire-pulse wireplumber
