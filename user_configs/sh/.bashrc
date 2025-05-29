# set -euo pipefail # TODO: Debug why there is an unbound local variable error here with set -u. Should help me debug better.

# Import the global variables used throughout this script and others.
source $HOME/repos/dotfiles/user_configs/sh/.env.sh # This should run out-the-box even on a clean install. The 'dotfiles' repo is installed already by the arch-ISO installation script.

#############################################
# ALIASES
#############################################

# Convenience aliases for common commands.
alias vi="nvim"
alias lg="lazygit"
alias dfs="cd $DOTFILES && ls"
alias vlt="cd $VAULT && ls"

# Quick navigation of the 'df' cmdlet.
alias setup="source $DOTFILES/cmdlets/share/df/scripts/setup.sh" # Can't be with the 'df' cmdlet, as want to be able to source new env vars into interactive shell. Can only do this with an alias, can't inherit variables from another non-shell process.

# Quickly edit the todo. # TODO: Eventually move this into the `df` cmdlet.
#alias todo="vim $DOTFILES/TODO.md"

alias sd="sudo shutdown -h now"

#############################################
# Python versioning
#############################################
export PYENV_ROOT="$HOME/.pyenv"
export PATH="$PYENV_ROOT/bin:$PATH"
eval "$(pyenv init --path)"
eval "$(pyenv init -)"

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

# Stop zombie sessions accumulating in tmux. Just open one named session by default.
tmux() {
  # if no arguments, or just `attach`, attach-or-create "primary"
  if [ $# -eq 0 ] || { [ $# -eq 1 ] && [ "$1" = "attach" ]; }; then
    command tmux new-session -A -s mission-control
  else
    # forward everything else to the real tmux
    command tmux "$@"
  fi
}
#############################################
# DEVICE- AND PLATFORM-SPECIFIC CODE
#############################################

# Source specific .bashrc's
if [ -e "$DF_PLATFORM_BASHRC" ]; then
  source "$DF_PLATFORM_BASHRC"
fi

if [ -e "$DF_DEVICE_BASHRC" ]; then
  source "$DF_DEVICE_BASHRC"
fi
