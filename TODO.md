ToDo today:
- Make it when that I switch between workspaces in hyprland, a little thing appears in the TOP-RIGHT corner showing which workspace I'm now in.
	- Also make some nice little shortcut for navigating BETWEEN workspaces... like super + shift + hjkl.
- Find a way to perform actions with selected text in vim (in visual mode). Make a shortcut at somepoint to quickly copy selected text to the clipboard.
- There are lots of things I current DON'T like about my nvim setup that stops me using it I think.
	- I arguable prefer the font on normal vim.
	- Make the text wraparound.
	- Find all the (visual) things I don't like an improve them asap!
- Zsh not working by default as startup shell on my computer from startup script.. find out why not..
- I THINK ... switch super + c and super + q .... make opening the terminal be super + T, and make quitting a window be super + Q ... seems more sensible to me!!
- thinkpad  still seems not have to have all fonts. Download some better fonts and set them to the system default.
- Set up kmonad for some other things on my keyboard, e.g. the mouse button... press once for clicking, hold to scroll as currently...
- Set up some function keys that I think would be useful for copy paste... maybe some volume functionality as well...
- Store all my systemd files in my dotfiles repo as well?? see if that works and if it will automatically detect them and start them on a new machine?? maybe also add at the end of my arch-setup.sh that if it's the first time doing these things I should probably do a restart of the computer... ALSO CURRENTLY in my kmonad file in /etc/systemd/system/kmonad.service ... it's hard-coded to my username as 'yac'... I need to CHANGE both pc and laptop to have the same username (yonah), and differentiate them by their hostnames :: 'thinkpad' vs 'thinkcentre'
- Remap the capslock to esc for once and capslock for twice (and maybe control for hold??)
- Make my thinkbutton less sensitive!!
- PRACTISE USING THE TEE COMMAND!
# Other todos
- Every time I run the arch-install script I get locale warnings.
- Set these up to stop the warnings and would be a good thing to do anyways!
- Make some sort of configuration file in 'dotfiles' to simplify?? Maybe like a config.json or a config.ini or something like that... this can also be used by the 'dotfiles' cmdlet, and will mean I can centralise any params that won't be used globally.
- Somewhere in the arch setup script raise an error if the internet connection is not working.
	- Find the most 'legit' way to test in a script whether things are actually working with your connection to the internet.
- Make a separate script / cmdlet for connecting to wifi.
- After hibernating for a while, systemd-networkd often stop working for some reason.
	- Find out why this is.
	- If there's no obvious reason, try make a post-hibernation hook that restarts it: `sudo systemctl restart systemd-networkd`
- There's a stage in my arch-setup that does NOT proceed without confirmation... find what stage this is (a yay install or something) and add the --noconfirm switch...
- Find a way to do gh auth as automated as possible as well...

- Work out with tree-sitter how I can get it to recognise sentences for typing txt and md files, etc. This would be useful for jumping around sentences quickly.
- SET UP copy and paste shortcuts for control + shift + v ... change it for chrome so that it uses the same shortcuts?? bc currently it only works with control + c and control + v??

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


##### OTHER STUFF ######
- I've spoken somewhere above about adding a command to add a quick section header (like in hypr.conf) to vim files... I think the command should be 'nsec NEW_SECTION_NAME' ... also make a command 'sec' that lists all the sections...
- To make vim nicer scrolling, when I do control + d or control + u , I actually don't like the fact that it just moves instantly, makes it hard to follow.... find a way to make it that it does a 'scrolling' animation, just a really really quick one... so I can still see the mvoement that has happened when I scrolled down, and keep track of where I am!!
- I want a better way to use whatsapp on my machine... see if there's already some whatsapp app that allows you to use some sort of vim keybindings, and scrolling through chats without having to use the mouse... otherwise see if I can set one up... if I manage to , at some point could open source it! Add this to my open-source to do list of projects that I have on my todoist!!
- I think I want to have BOTH the relative and absolute line numbers in vim... see if any other people have a good way of having both in a clear manner... like the absolute ones being left most and bolt, and then relative being to the right of them and in italics or something... look around other people's setups and see how they do it / if it's advisable...


- Make a SEPARATE PARTITION FOR MY HOME/YONAH FOLDER(S) AND COPY JUST THEM TO MY ONEDRIVE... this way also I can quickly re-install the linux system and run my whole script etc without having to worry about files being persisted etc... Will make life easier methinks and is good practise!!!

- Make a section of my arch-install.sh script for checking if some of my vim packages are installed... and if not, installing them... e.g.vim wayland keyboard

- MAKE THE THINK BUTTON RED THING ON MY THINKPAD LESS SENSITIVE!!! cURRENTLY IT's superrrr sensitive, which is a bit much and makes it hard to scroll and move the mouse around effectively without overshooting... definitely a way to configure this better :))
