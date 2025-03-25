# TODO: Soon move my arch-install.sh into this folder, and call it arch-setup or something. I'll need to change the paths in it to where it's instaled new.

# I think the format should be that here I have arch-install.sh .... I should make this clear that this should run in the iso file in order to install arch itself on the system... in my /tools/bin I should have arch-setup

# TODO: Document in THIS file that this one should be used whilst in the live usb, and should be manually copied to the live usb for first setup. The other one should be run (document it there) whenever I want to sync my system, or at first install, in my user shell. I think go and configure an env variable for first setup.

- As part of the initial setup, on first boot (check whether these things are installed and install them if they're not):
	## These things are on the arch setup page
	- Setting up fstab
	- Set up time zone
	- localization
	- network configuration (/etc/hostname)
- Download my (public) dotfiles repo and run it.
        - Also make configuring the default fonts for system, for hyprland, etc , part of the setup
	- Configure hibernation for the system if I want it (maybe make an automated script that does so for me by printing each of the paritions and asking which one to use IF there is a swap partition mounted).
	- also make the sure todoist image is installed).
- Separate out the functionalities of (some) of the different parts of the script so that I can re-use or whatever the parts that I want to.

