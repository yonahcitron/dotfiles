set -e
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


# Install yay to download packages from AUR.
# TODO: Add code here later.
# TODO: Install logiops also.


SCRIPT_RESOLVED="$(readlink -f "${BASH_SOURCE[0]}")"
echo $SCRIPT_RESOLVED
SCRIPT_DIR="$(realpath -s -- "$(dirname -- "$SCRIPT_RESOLVED")")"
echo $SCRIPT_DIR
PACKAGES_FILE=$SCRIPT_DIR/../../packages.txt
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
sudo yay -S --noconfirm --needed - < $PACKAGES_FILE


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

# Check if the change was successful
if [[ "$(getent passwd "$USER" | cut -d: -f7)" == "$ZSH_PATH" ]]; then
    echo "Default shell successfully changed to zsh."
else
    echo "Failed to change default shell."
fi

# Optional: Start zsh immediately
if [[ "$SHELL" != "$ZSH_PATH" ]]; then
    echo "Starting zsh..."
    exec zsh
fi
