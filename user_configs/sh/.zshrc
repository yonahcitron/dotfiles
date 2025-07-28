# Enable Powerlevel10k instant prompt. Should stay close to the top of ~/.zshrc.
# Initialization code that may require console input (password prompts, [y/n]
# confirmations, etc.) must go above this block; everything else may go below.

if [[ -r "${XDG_CACHE_HOME:-$HOME/.cache}/p10k-instant-prompt-${(%):-%n}.zsh" ]]; then
    source "${XDG_CACHE_HOME:-$HOME/.cache}/p10k-instant-prompt-${(%):-%n}.zsh"
fi

# oh-my-zsh and powerlevel10k are not available in the default Ubuntu repositories. Even though it's available on arch etc, install manually on all distros for consistency.
export ZSH="$HOME/.oh-my-zsh"
if [ ! -d $ZSH ]; then
    git clone --depth=1 https://github.com/ohmyzsh/ohmyzsh.git $ZSH
fi
if [ ! -d $ZSH/custom/themes/powerlevel10k ]; then
    git clone --depth=1 https://github.com/romkatv/powerlevel10k.git $ZSH/custom/themes/powerlevel10k 
fi



# Source .bashrc to import all settings and global variables used throughout this script and others (e.g. $DISTRO etc)
[[ -f ~/.bashrc ]] && source ~/.bashrc

# If you come from bash you might have to change your $PATH.
# export PATH=$HOME/bin:$HOME/.local/bin:/usr/local/bin:$PATH


# Set name of the theme to load --- if set to "random", it will
# load a random theme each time Oh My Zsh is loaded, in which case,
# to know which specific one was loaded, run: echo $RANDOM_THEME
# See https://github.com/ohmyzsh/ohmyzsh/wiki/Themes
 ZSH_THEME="powerlevel10k/powerlevel10k"

# Set list of themes to pick from when loading at random
# Setting this variable when ZSH_THEME=random will cause zsh to load
# a theme from this variable instead of looking in $ZSH/themes/
# If set to an empty array, this variable will have no effect.
# ZSH_THEME_RANDOM_CANDIDATES=( "robbyrussell" "agnoster" )
# Uncomment the following line to use case-sensitive completion.
# CASE_SENSITIVE="true"

# Uncomment the following line to use hyphen-insensitive completion.
# Case-sensitive completion must be off. _ and - will be interchangeable.
# HYPHEN_INSENSITIVE="true"

# Uncomment one of the following lines to change the auto-update behavior
# zstyle ':omz:update' mode disabled  # disable automatic updates
# zstyle ':omz:update' mode auto      # update automatically without asking
# zstyle ':omz:update' mode reminder  # just remind me to update when it's time

# Uncomment the following line to change how often to auto-update (in days).
# zstyle ':omz:update' frequency 13

# Uncomment the following line if pasting URLs and other text is messed up.
# DISABLE_MAGIC_FUNCTIONS="true"

# Uncomment the following line to disable colors in ls.
# DISABLE_LS_COLORS="true"

# Uncomment the following line to disable auto-setting terminal title.
# DISABLE_AUTO_TITLE="true"

# Uncomment the following line to enable command auto-correction.
# ENABLE_CORRECTION="true"

# Uncomment the following line to display red dots whilst waiting for completion.
# You can also set it to another string to have that shown instead of the default red dots.
# e.g. COMPLETION_WAITING_DOTS="%F{yellow}waiting...%f"
# Caution: this setting can cause issues with multiline prompts in zsh < 5.7.1 (see #5765)
# COMPLETION_WAITING_DOTS="true"

# Uncomment the following line if you want to disable marking untracked files
# under VCS as dirty. This makes repository status check for large repositories
# much, much faster.
# DISABLE_UNTRACKED_FILES_DIRTY="true"

# Uncomment the following line if you want to change the command execution time
# stamp shown in the history command output.
# You can set one of the optional three formats:
# "mm/dd/yyyy"|"dd.mm.yyyy"|"yyyy-mm-dd"
# or set a custom format using the strftime function format specifications,
# see 'man strftime' for details.
# HIST_STAMPS="mm/dd/yyyy"

# Would you like to use another custom folder than $ZSH/custom?
# ZSH_CUSTOM=/path/to/new-custom-folder

# Which plugins would you like to load?
# Standard plugins can be found in $ZSH/plugins/
# Custom plugins may be added to $ZSH_CUSTOM/plugins/
# Example format: plugins=(rails git textmate ruby lighthouse)
# Add wisely, as too many plugins slow down shell startup.
plugins=(git)

source $ZSH/oh-my-zsh.sh

# User configuration

# export MANPATH="/usr/local/man:$MANPATH"

# You may need to manually set your language environment
# export LANG=en_US.UTF-8

# Preferred editor for local and remote sessions
# if [[ -n $SSH_CONNECTION ]]; then
#   export EDITOR='vim'
# else
#   export EDITOR='nvim'
# fi

# Compilation flags
# export ARCHFLAGS="-arch $(uname -m)"

# Set personal aliases, overriding those provided by Oh My Zsh libs,
# plugins, and themes. Aliases can be placed here, though Oh My Zsh
# users are encouraged to define aliases within a top-level file in
# the $ZSH_CUSTOM folder, with .zsh extension. Examples:
# - $ZSH_CUSTOM/aliases.zsh
# - $ZSH_CUSTOM/macos.zsh
# For a full list of active aliases, run `alias`.
#
# Example aliases
# alias zshconfig="mate ~/.zshrc"
# alias ohmyzsh="mate ~/.oh-my-zsh"

# Activate vim keybindings.
bindkey -v

# Remap keys to exit insert mode without having to hit esc.
bindkey -M viins 'jk' vi-cmd-mode

# To customize prompt, run `p10k configure` or edit ~/.p10k.zsh.
[[ ! -f ~/.p10k.zsh ]] || source ~/.p10k.zsh

# TODO: Put this and some of the other stuff that doesn't need to run EVERY time into the .zshrc?
# Download the tmux package manager.
if [ ! -d "$HOME/.tmux/plugins/tpm" ]; then
    git clone --depth=1 https://github.com/tmux-plugins/tpm $HOME/.tmux/plugins/tpm
fi

# Setup terminal-based file manager.
y() {
  local tmpfile="$(mktemp)"
  command yazi --cwd-file="$tmpfile" "$@"
  if [[ -f "$tmpfile" ]]; then
    local newdir
    newdir="$(<"$tmpfile")"
    rm -f "$tmpfile"
    if [[ -d "$newdir" ]]; then
      cd "$newdir"
    fi
  fi
}


# Make vi‑mode changes and stay silent during startup
function _cursor_by_keymap {
  case $KEYMAP in
    vicmd) print -n '\e[2 q' ;;           # steady block in normal mode
    viins|main) print -n '\e[6 q' ;;      # steady beam in insert/others
  esac
}
# Attach without clobbering P10k widgets
autoload -Uz add-zle-hook-widget
add-zle-hook-widget keymap-select _cursor_by_keymap
add-zle-hook-widget line-init     _cursor_by_keymap

# Ensure beam while a command runs
preexec() { print -n '\e[6 q' }

#############################################
# DEVICE- AND PLATFORM-SPECIFIC CODE
#############################################

# Source specific .zshrc's
if [ -e "$DF_PLATFORM_ZSHRC" ]; then
    source "$DF_PLATFORM_ZSHRC"
fi

if [ -e "$DF_DEVICE_ZSHRC" ]; then
    source "$DF_DEVICE_ZSHRC"
fi

# NOTE: For now I think the best way of doing this is by initializing pyenv when I want it, rather than having it as a global? See if this works, otherwise I can always put it back in the .zshrc.
# Set up system paths for pyenv in interactive shells (see .zprofile for non-interactive setup)
export PYENV_ROOT="$HOME/.pyenv"
[[ -d $PYENV_ROOT/bin ]] && export PATH="$PYENV_ROOT/bin:$PATH"
eval "$(pyenv init - zsh)"
# Set up pyenv-virtualenv
eval "$(pyenv virtualenv-init -)"


# fastfetch # See my todo in my vault for my plan to make this even cooler, by having a different thing in each of my tmux terminal grids at startup... but can implement that later.... make sure that it doesn't run both is the only thing, shouldn't be calling fast-fetch twice!!

# Set up the ghcs command
eval "$(gh copilot alias -- zsh)"
