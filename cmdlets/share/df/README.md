-- MIGRATE all the 'setup' scripts etc here... meaning into the cmdlet section of the dotfiles repo, rather than having it in its own folder... will make a more unified structure? and really scripts that run should be placed in ~/.local/share ... rather than in the custom dotfiles path... this should be unified ofc!!! might take some time..

# A cmdlet to manage updating my dotfiles, allowing me to sync any additions with git quickly without having to cd into the folder, as well as X, Y, Z.
# - Also allow me to append to the TODO.md quickly, for any personal tasks around my machine setup I need to do.

- Make this actually be called from the cmdlet in the bin dir...;wq


########################
- Copy over the tasks I want to do on this cmdlet from arch-setup.sh and also TODO.sh
- In addition to all the above tasks, make a 'dotfiles edit' command, that allows you to pass as the next param the name of the file you want to open.
	- It should recursively search through the user_config and global_config leaf files, and open it in edit mode if a match is found.
	- Find also a good cli library (in bash, or maybe even in python), that enables tab autocomplete for this...
		- So if I go `dotfiles edit hy` and then hit TAB, it will complete it by default if only one file is found, or list ALL options starting with hy- in the recursive folder structure if multiple are found. This will be very useful!!
