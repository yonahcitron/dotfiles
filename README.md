MAKE A NOTE THAT IN ORDER FOR THINGS IN /ETC TO WORK I.E. STASHING THERE, i NEED TO DO FOR EACH FILE:

# TODO: At some point make it that when I close my laptop lid it automatically hibernates it...
# TODO: Keyboard remappings to do: on my various machines and keyboards, remap the same function keys to do the same things around volume, etc etc... also remap the caps lock key maybe to be esc when pressed once, and caps when pressed twice (maybe in the future make it control or something when held???)
# In the startup file, I ALSO need to start all the services that I want to start e.g. logid and udevmon, depending on the device. This should be in the arch-setup.sh file.
##Todo
- In my .bashrc, I have some instructions about a quick dotfiles applet that I wanna make... make that quickly when I have time...
- Also see if there's a way to switch between adjacent windows in hyprland by simplying continue scrolling using super + l etc etc... like you just 'continue on to the next screen'... see if there a plugin or something for that?..
- REALLY work out the window management thing. Currently I don't have the possibility move windows how I want them.
	- For example, if I have a big window taking up top half and two below them, I don't know how to 'raise up' one of the small ones so IT becomes the left half of the screen and the big one at the top shrinks to now take up a quarter. THAT'S the functionality that I want to implement.
- Make an install / bootstrap script for everything if possible.
- Remember to only add dotfiles as and when I need them / configure them.
- Remember to also have some script that run at setup, like when I stow the logid.cfg file, in the next step, I THEN need to actually do sudo systemctl start logid.service ... and also activate or something or enable.. check with chatgpt
- Install logid, zsh, ohmyzsh,
- Configure ohmyzsh to look nice...

this is the link to help with documentation ... https://venthur.de/2021-12-19-managing-dotfiles-with-stow.html
