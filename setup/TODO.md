- TAKE OUT THE PART OF THE SETUP SCRIPTS THAT DEAL WITH THE INSTALL OF CONFIGS ... MAKE LIKE A POSIX SECTION....
# TODO: Ensure that I install the VIM-ONLY plugins as a part of my arch-setup script.. basically just want the one ... that does vim-wayland stuff!!
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

# TODO: Currently I'm symlinking .arch-setup.sh to home for ease of access. When I implement my little 'dotfiles' cmdlet, make a command like 'dotfiles install' or something that basicallly runs the script (from the dotfiles original repo itself), and this will remove the need to have the .arch-setup.sh script in the home dir at all. Just get the cmdlet working!
# 3. Eventually refactor this whole script into the 'df' cmdlet, and make it so that I can run it with 'df setup arch'... and then eventually if I wanna include other distros I can do like 'df setup ubuntu' etc... or if I wanna be more granular with specific device configs.
#    - Say I have a home server with specific configurations, I can run `df setup arch home-server` ... and if I pass no args like `df setup arch`, it should check first my .local folder for configs (in dotfiles repo), then my hostname for which device I'm running it on, and if it can't find a matching device should ask me to pick one. There should be a 'default' for each OS which contains all the base settings, and anything device / setup specific will go in the specific dirs for that setup....
#    - Once I've run the setup once, it should save in a .local folder in 'dotfiles' repo that stores the identity of the machine and any other identifiers... and then going forward I can just run `df sync`... however this should basically just be a shorthand for `df setup arch XXXX`... so `df sync` basically just looks for the appropriate pre-configured settings locally (if found), and passes them to `df setup`. If the args are not found it should search / prompt...
#         - So actually I think it might be better if `df setup` requires ALL args to be passed, returning the possible options, but doesn't do anythign by default... the higher-level API will be `df setup` I think...

# 4. Ensure hibernation is configured, and if not, configure it. Make an auto-script for this.
