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
# Convenience aliases for common commands.
alias vi="nvim"
alias lg="lazygit"

alias dotfiles="cd $dotfiles && ls"
# Quick navigation of the 'df' cmdlet.
alias setup="df setup"

# Quickly edit the todo. # TODO: Eventually move this into the `df` cmdlet.
#alias todo="vim $dotfiles/TODO.md"

alias sd="sudo shutdown -h now"

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

#############################################
# DEVICE- AND PLATFORM-SPECIFIC CODE
#############################################

# Run any platform-specific .bashrc scripts.
setup_dir="$HOME/.local/share/df/setup"
platform_dir="$setup_dir/platforms/$DISTRO"
platform_bashrc_script="$platform_dir/$DISTRO.bashrc"
if [ -e "$platform_bashrc_script" ]; then
  source "$platform_bashrc_script"
fi

# Run any device-specific .bashrc scripts, identified by the hostname.
hostname=$(uname -n)
device_bash_script="$platform_dir/devices/$hostname/$hostname.bashrc"
if [ -e "$device_bash_script" ]; then
  source "$device_bash_script"
fi
