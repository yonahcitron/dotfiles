The bin and tools dirs are stowed from the dotfiles 'tooling' dir.
- CLI frontends and simple executables should be stored directly in bin, the actual scripts and logic in the tools subdirs, divided by project. ~/bin is added to the sys path in .env.sh

# Quick navigation of the 'df' cmdlet.
alias setup="source $DOTFILES/cmdlets/share/df/scripts/setup.sh" # 
NOTE: I wanted to have the 'setup' command be a sub-command of the 'df' tool, and then aliased for shorthand, however Can't be with the 'df' cmdlet, as want to be able to source new env vars into interactive shell. Can only do this with an alias, can't inherit variables from another non-shell process.
