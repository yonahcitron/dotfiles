MAKE A NOTE THAT IN ORDER FOR THINGS IN /ETC TO WORK I.E. STASHING THERE, i NEED TO DO FOR EACH FILE:

# sudo chown root:root /etc/logid.cfg
# sudo chmod 600 /etc/logid.cfg


##Todo
- REALLY work out the window management thing. Currently I don't have the possibility move windows how I want them.
	- For example, if I have a big window taking up top half and two below them, I don't know how to 'raise up' one of the small ones so IT becomes the left half of the screen and the big one at the top shrinks to now take up a quarter. THAT'S the functionality that I want to implement.
- Make an install / bootstrap script for everything if possible.
- Remember to only add dotfiles as and when I need them / configure them.
- Remember to also have some script that run at setup, like when I stow the logid.cfg file, in the next step, I THEN need to actually do sudo systemctl start logid.service ... and also activate or something or enable.. check with chatgpt
- Install logid, zsh, ohmyzsh,
- Configure ohmyzsh to look nice...

this is the link to help with documentation ... https://venthur.de/2021-12-19-managing-dotfiles-with-stow.html
