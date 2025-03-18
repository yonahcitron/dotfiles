# TODO: Make a little dotfiles cmdlet so I don't need to always be in the in the dotfiles folder to do things... with commands like dotfiles update (which does add, prints changes, commits, and pushes), dotfiles apply, dotfiles status, dotfiles unapply (or find a better word from chatgpt), dotfiles install (which does an update of AUR / pacman, downloads the package locally, and then appends it to the packages file so that it will be downloaded to all machines.) Also maybe add a command like 'dotfiles todo add -m "Some thing that I want to do"'... and that command simply appends (>>) the message onto the end of the TODO.md there...  Currently most of the todos are in the readme, and in various other files (grep all the files to find where they all are)... but consolidate them eventually into the TODO.md which stores all this stuff..
# TODO: Also remember to implement the startup logic on my machine (I've specified it I think in tododist or maybe one of my readmes) that checks for dotfiles updates etc in github and syncs between them. Read the docs I wrote there for details 
#     Whenever I do updates to configs, download new files
export SUDO_EDITOR=vim

#############################################
# ALIASES
#############################################

# To check power on my thinkpad.
alias power="upower -i $(upower -e | grep battery) | awk '/percentage/ {print $2}'"
# To change the brightness quickly.
# TODO: Make this into a function at somepoint so I can just go `b 20` and not need to include the % sign at the end.
alias b="brightnessctl set"
#############################################
# GLOBAL VARIABLES
#############################################

export dotfiles="$HOME/repos/dotfiles"
# echo "global 'dotfiles' variable set to: $dotfiles"
