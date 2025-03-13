ToDo today:

- thinkpad  still seems not have to have all fonts. Download some better fonts and set them to the system default.
- Set up kmonad for some other things on my keyboard, e.g. the mouse button... press once for clicking, hold to scroll as currently...
- Set up some function keys that I think would be useful for copy paste... maybe some volume functionality as well...
- Store all my systemd files in my dotfiles repo as well?? see if that works and if it will automatically detect them and start them on a new machine?? maybe also add at the end of my arch-setup.sh that if it's the first time doing these things I should probably do a restart of the computer... ALSO CURRENTLY in my kmonad file in /etc/systemd/system/kmonad.service ... it's hard-coded to my username as 'yac'... I need to CHANGE both pc and laptop to have the same username (yonah), and differentiate them by their hostnames :: 'thinkpad' vs 'thinkcentre'
- Remap the capslock to esc for once and capslock for twice (and maybe control for hold??)
- Make my thinkbutton less sensitive!!

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



- Work out with tree-sitter how I can get it to recognise sentences for typing txt and md files, etc. This would be useful for jumping around sentences quickly.
