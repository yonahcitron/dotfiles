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

# This method returns the hostname of the target system even when in chroot - this is what I want for my setup scripts.
export HOSTNAME=$(</etc/hostname)

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

export DF_SETUP_DIR="$dotfiles/cmdlets/share/df/setup"
export DF_PLATFORM_DIR="$DF_SETUP_DIR/platforms/$DISTRO"
export DF_PLATFORM_PACKAGES="$DF_PLATFORM_DIR/$DISTRO-packages.txt"
export DF_PLATFORM_INIT_SCRIPT="$DF_PLATFORM_DIR/$DISTRO-init.sh"
export DF_PLATFORM_POSTSCRIPT="$DF_PLATFORM_DIR/$DISTRO-postscript.sh"
df_platform_bashrc="$DF_PLATFORM_DIR/$DISTRO.bashrc"

if [ -e "$df_platform_bashrc" ]; then
  source "$df_platform_bashrc"
fi

DF_DEVICE_DIR="$DF_PLATFORM_DIR/devices/$HOSTNAME/$HOSTNAME.bashrc"
df_device_bashrc="$DF_DEVICE_DIR/$HOSTNAME.bashrc"
if [ -e "$df_device_bashrc" ]; then
  source "$df_device_bashrc"
fi
