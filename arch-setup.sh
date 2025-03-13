# Import global variables.
set -e
source $HOME/.bashrc

#####################
#####  Todos  #######
#####################

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

##############################
######  Prerequisites ########
##############################

# - Install arch from the live usb
#	- After chrooting into the drive, be sure to install iwd with pacman.
#       - Also be sure to make a user account called 'yonah' (some of the hard-coded installations depend on this) ... I think in future maybe make the start of the script check whether you're running in root, tell you you shouldn't if you are, and then use the user-account name as a param for the install!
###########################
##### First-time setup ####
###########################


# Function to check if a package is installed
check_installed() {
    pacman -Q $1 &> /dev/null
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
    sudo tee $NETWORK_CONF > /dev/null <<EOF
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
    sleep 2  # Give it time to scan

    # Display available networks
    echo "[INFO] Available networks:"
    sudo iwctl station wlan0 get-networks

    # Prompt user for WiFi details
    read -p "Enter WiFi SSID: " SSID
    read -s -p "Enter WiFi Password: " PASSWORD

    # Connect to the WiFi network
    echo "\n[INFO] Connecting to $SSID..."
    sudo iwctl station wlan0 connect "$SSID" <<< "$PASSWORD"

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

# Symlink this file to the home folder so I can easily re-run.
if [ -L "/home/$USER_ACCOUNT/.arch-setup.sh" ]; then
    echo "Symlink already exists: /home/$USER_ACCOUNT/.arch-setup.sh"
elif [ -e "/home/$USER_ACCOUNT/.arch-setup.sh" ]; then
    echo "A regular file or directory exists at the target location. Not creating symlink."
else
    ln -s "$dotfiles/arch-setup.sh" "/home/$USER_ACCOUNT/.arch-setup.sh"
    echo "Symlink created: /home/$USER_ACCOUNT/.arch-setup.sh -> $dotfiles/arch-setup.sh"
fi


# In order to get the intended functionality of treating each of the subfolders of the stow dir as a module, and reacreate each of their substructures within the target dirs, rather than just dumping them in the target dir directly, we *must* use the cd approach. This is why we can specify the --dir directly for our command which would be more elegant.
echo "Setting up Yonah's user configs." 
cd $dotfiles/user_configs
stow --target /home/$USER_ACCOUNT */  # User configs.

# Global configs.
echo "Setting up Yonah's global configs." 
cd $dotfiles/global_configs
# Stowing as root should give root ownership of the symlinks.
# The files they link to should be user-owned, to not interfere with git.
sudo stow --target /etc */

# Tools.
echo "Setting up Yonah's cmdlet tools."
cd $dotfiles
mkdir -p tools
stow --target /home/$USER_ACCOUNT/tools tools
cd $WORKING_DIR


##############################
#### Install Local files #####
##############################

# Install arch and aur files.

PACKAGES_FILE=$dotfiles/packages.txt # $dotfiles is defined in .bashrc
echo "Ensuring all the following packages are installed:"
cat $PACKAGES_FILE
  
if ! command -v yay &> /dev/null; then
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
yay -S --noconfirm --needed - < $PACKAGES_FILE


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

sudo systemctl enable --now kmonad.service

