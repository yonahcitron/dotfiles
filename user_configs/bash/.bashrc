#############################################
# GLOBAL VARIABLES
#############################################
export PATH="$HOME/.local/bin:$PATH"
export SUDO_EDITOR=vim
export EDITOR=nvim
export dotfiles="$HOME/repos/dotfiles"

if [[ "$OSTYPE" == "linux-gnu"* ]]; then
  source /etc/os-release
  export DISTRO=$ID
elif [[ "$OSTYPE" == "darwin"* ]]; then
  export DISTRO="mac"
fi

#############################################
# ALIASES
#############################################

# Quick dotfiles navigation.
alias dotfiles="cd $dotfiles"

# Quickly edit the todo. # TODO: Eventually move this into the `df` cmdlet.
alias todo="vim $dotfiles/TODO.md"

# To check power on my thinkpad.
alias power="upower -i $(upower -e | grep battery) | awk '/percentage/ {print $2}'"
# To change the brightness quickly.
# TODO: Make this into a function at somepoint so I can just go `b 20` and not need to include the % sign at the end.
alias b="brightnessctl set"

#############################################
# FUNCTIONS
#############################################

launch() {
  if [ $# -eq 0 ]; then
    echo "Usage: launch <command> [args...]"
    return 1
  fi

  if ! command -v "$1" >/dev/null 2>&1; then
    echo "Error: '$1' is not a valid command."
    return 2
  fi

  nohup "$@" >/dev/null 2>&1 &
  disown

  # Only call exit if we're in an interactive shell inside a terminal window
  if [[ $- == *i* ]]; then
    exit
  fi
}
