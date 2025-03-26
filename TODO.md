ToDo today:
- In my home directory, make a folder 'cloud' which contains my onedrive.... in time get round to better organizing my onedrive. Download all my repos to ~/repos, all my meaningful documents to ~/cloud, and maybe make a ~/misc folder for random downloady things I don't really care about / want to keep? 
- Remap 'll' to just do ls -a .... currently it does ls -la which I don't want...
- Make it so then when you 'cd' in nvim, neo-tree or whatever file manager is installed automatically refreshes...
- Make shortcut to run the current file and open the output in the terminal, in nvim...
    - I think this shortcut is already built in ... try it ... I think it's space, b, 0
- Find a feature, either directly in git or lazygit or both, that will detect when a file greater than a certain size has been newly added (say bigger than 20mb) and raise a warning if you try add it!!!
- Get some program (with a keyboard shortcut) that automatically does all indentations for me... so that I don't need to manually re-indent everything myself every time I paste something with the wrong indentation...
- In nvim, remap control + / to be super + / for consistency....
- Very soon do the thing where I print which workspace I'm in and its name in the top right corner when I move between them.. set that up soon...
- Make "arch-setup" an executable in ~/.local/bin
- Make flag(s) in my arch setup to only do *some* of the functionality ... e.g. --stow flag to not do the whole packages update ... ask chatgpt if that's a usual api or if it's more normal to specify the things we aren't doing... e.g. --nosync
- CONFIGURE a shell fzf-based fuzzy finder that INSERTS THE CHOSEN FILE PATH directly into the shell prompt (or if not possible, copies it to the clipboard)... get chatgpt to help with this!!
- Set the locale properly, currently I'm getting issues..
- WORK OUT how to get vim integrations into neo tree so I can modify things WHILST I'm scrolling through the tree as well, ideally if poss..
- Cannot uninstall bsdtar for some reason... uninstall it properly from my machine..
- Find or make a quick and easy nvim shortcut for switching between buffers using hjkl keys and some other of the control keys for quick switch so I can quickly switch between multiple of them...
- Find a way to make it that when you clikc enter on a neotree file you're selecting, it SHUTS neotree after it opens the new file... that's the default behaviour that I really want to be honest...
- At some point soon, really spend some time setting up copilot.lua, and understanding how best to use the workflow. Watch videos and read some stuff online to read optimise how I use the workflow... for now I guess just use it like I used to use it on vscode, but update that for a more optimised flow soon enough..
    - Although I think it doesn't suggest if I'm not in insert mode... so I can just go to normal mode and it wont, which is really good! that's probably a good starting point for configuring it in such a way that it doesn't get in the way too much visually whilst I'm trying to think and code etc...
    - People make the point that setting tab in copilot to complete might get in the way with the other syntax highlighting syggestions... however, I should set THOSE to be different to accept, if I end up using them... like control tab or something
        - Moreover, when I get the remappings done for keys, I can remap either copilot complete or the other one to be done by clicking tab twice or something for ease... that can translate to control + tab or something along those lines...
- Work out how to close buffers etc properly... coz whenever I do wq it just seems to shut all buffers ... 
- Instead of having to use the arrow keys to resize vim windows, remap them to control + alt + hjkl
- In nvim, remap window resizing to sensible defaults, like control + alt + hjkl for sensible and quick window resizing of e.g. the terminal, windows I open in different places, etc etc!!! not the same as hyprland, currently for nvim windows I have to use the arrow keys which is annoying...
- Make functionality in nvim for some sort of easy sidebar to appear with an llm / chatgpt , IDEALLY with multiple tabs / conversations that I can have going on in tandem, and even more ideally associated with the current codebase that I'm using so that it 'remembers' the history of the chat for the session! and, similar to control + / to open the terminal, make it have obvious and easy to remember ways to open it??
- Configure 'noice.nvim' to make bigger popup windows when it prints stuff to the console so that I can see the errors more easily!!!
- Get rid of prompt when I quit zsh... every time it asks me if I want to close it which I don't want it to do!!
- Use qutebrowser, make a shortcut to open the current page in chrome quickly (or actually maybe integrate everthing with firefox and set up the password manager I connected to with the firefox thing as well)... and then remap the chatgpt UI to open in that instead.. make super + F be firefox (it's mapped to something currently so change this back), and then make super + B be the browser (qutebrowser)
- I think make switching between windows and with hjkl and also with numbers be super + shift... but then just remap the caps lock key to my functionality... for switching windows...
- At some point when I stop using the gui for chatgpt, then remap the terminal loading shortcut on hyprland to super + enter, rather than super + space like I'm doing now... the only reason that I'm using super + space is because the super + enter is already taken for submitting text to the chatgpt gui....
- Make that when nvim starts it ALWAYS sets the pwd to the top of the projects that I'm working on (e.g. where the git ignore is)... I can set this up in settings...
- Possibly disable the opening and closing brackets that work automatically bc they kinda annoy me tbh!!
- See if what my nvim is showing at the top are tabs or buffers (there must be a way to check)... maybe move them to the bottom of the screen, or maybe get rid of them, depending on what I want!
- Change the font maybe to jetbrains mono??
- Make the default width of the file explorer SMALLER!! currently it's too wide when it starts off....
- Install fzf or whatever I need to run executables...
- I think I'm a bit burned out from all this vim stuff.. give it a break for a while!!!
- Enable auto-saving I think for vim-files... unless I wanna open them in a mode when they don't autosave? Bc in general it's useful for me to autosave them? Or maybe don't do this idk... see how I'm feeling...


- Move my aliases to .zshenv so that they load when I run commands with ! in vim:
      ```Telling Vim to always use an interactive shell can create problems. A better solution is to figure out what in your bash configuration sets up aliases and how you can move that to a place that is loaded even in non-interactive shells. For example, zshell only loads ~/.zshrc for interactive shells, but it loads ~/.zshenv for all shells, so I moved my alias setup there and it now works from within Vim. See man zsh (or your shell's man pages) for more.```

- Work out how to save tmux sessions (and how it works with them running in the background or not? what if I just want to save the terminal history etc but don't want them to be constaltly running every time I wake up the terminal..?)... see how this works..
- I completely disabled blink.cmp ... really , I do want the drop down suggestions, I just don't want the ugly grey suggestions to the right... see how I can do that instead??
- look into obsidian.nvim 
- Follow up on my issue in the kmonad repo and see if I can come up with any fixes for it??j;
- Consider maybe getting a chatgpt api... and monitoring regularly how much I'm using / the cost... and then using it in the cli for various productivity hacks across my workload, as well as for q and a, rather than using the web interface which is less nice... for simpler tasks I can just use a simpler model... or potentially even use claude?? ... also have a look at clwrap... it SEEMS TO use copilot which actually should do most if not all of what I want to do ... so I think this should be a good solution!! practise using copilot in nvim etc so that I get good at that...
- Consider remapping caps lock whilst holding to be ALT, and then then remap ALT + hjkl to remap to just the arrow keys for non-vim applications...
- Test the installation of the arch-bootloader script etc using QEMU to recreate a "PC-VM"...
- Fix todoist being blurry on my thinkpad, bc of wayland, see what the fix is...
- Follow up with the kmonad issue I posted on github about my trackpoint... if there's no fix, read through the source code and do it myself... add this to my todo in the software section in todoist...
- Maybe get some sort of emulator on my laptop to test out whether the bootstrap script I made actually works... find a good one for linux!!!
- Practise using VISUAL mode ON THE COMMAND LINE  to copy and paste commands etc... it works !!!
- Set up the whole hibernation shtick and MAKE IT PART OF THE ARCH BOOTSTRAPPING SCRIPT!!
- Find out what the EE wifi is on the tube and whether I'm entitled to it as an EE internet and wifi customer??
- Find way to resize panes quickly with good shortcuts whilst in vim potentially for when I want to ??
- Also find a way to make my terminal in vim look more like my terminal in the cli..
- Also find a way to quickly resize text in my terminal so that I can have smaller mini terminals open when I want them without it looking to small... could even make them auto-resize when the terminal window gets smaller!! That would be best I think so that I can have the pane in the bottom or whatever and as I resize it the text will change.. maybe do this as well for vim when it goes below a certain size??...
- Find some plugin for my cli that allows me to search for files recursively within my home directory so that I don't have to type out the whole path every time... and make it include directories as well so that I can cd into them ... like so that I can cd into that home directory using a quick fuzzy-finder or something, look into the options for this!!
- Find the vim keyboard shortcut to edit things between e.g. /'s in a path quickly.. ciw nor ciW does exactly that.. maybe tree-sitter or something...
- Called the dotfile executables / function 'dfl' from the cli as easier to type! have a proper help section (generated by chatgpt) which explains what all of the things do quickly and what all the availabel functions etc are... make a `dfl todo XX` command, where XX is the todo task which is appended to the file... e.g. `dfl todo "Finish writing feature for thing"` ... this should immediately git add the todo, commit it with the message "Added new item to TODO.md: [first 10 words + ...]
- Remap my caps lock to esc... HOLDING DOWN remap to SUPER + SHIFT to switch between workspaces... and remap shift + caps to caps lock.. 
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


##### OTHER STUFF ######
- I've spoken somewhere above about adding a command to add a quick section header (like in hypr.conf) to vim files... I think the command should be 'nsec NEW_SECTION_NAME' ... also make a command 'sec' that lists all the sections...
- To make vim nicer scrolling, when I do control + d or control + u , I actually don't like the fact that it just moves instantly, makes it hard to follow.... find a way to make it that it does a 'scrolling' animation, just a really really quick one... so I can still see the mvoement that has happened when I scrolled down, and keep track of where I am!!
- I want a better way to use whatsapp on my machine... see if there's already some whatsapp app that allows you to use some sort of vim keybindings, and scrolling through chats without having to use the mouse... otherwise see if I can set one up... if I manage to , at some point could open source it! Add this to my open-source to do list of projects that I have on my todoist!!
- I think I want to have BOTH the relative and absolute line numbers in vim... see if any other people have a good way of having both in a clear manner... like the absolute ones being left most and bolt, and then relative being to the right of them and in italics or something... look around other people's setups and see how they do it / if it's advisable...


- Make a SEPARATE PARTITION FOR MY HOME/YONAH FOLDER(S) AND COPY JUST THEM TO MY ONEDRIVE... this way also I can quickly re-install the linux system and run my whole script etc without having to worry about files being persisted etc... Will make life easier methinks and is good practise!!!

- Make a section of my arch-install.sh script for checking if some of my vim packages are installed... and if not, installing them... e.g.vim wayland keyboard

- MAKE THE THINK BUTTON RED THING ON MY THINKPAD LESS SENSITIVE!!! cURRENTLY IT's superrrr sensitive, which is a bit much and makes it hard to scroll and move the mouse around effectively without overshooting... definitely a way to configure this better :))

- find out why when I do the super + control to either side of my keyboard, and try to switch between workspaces, it doesn't work!!! fix this..
- Look into mason-lspconfig.nvim .... and look into how dependency management works in pacman... I was getting an error bc I didn't have unzip installed... this should be an auto-installed dependency surely? or maybe this is more of the lazy.nvim thing (actually yeah I think it is..)... find out how this should be included in the install script or whatever, or how the error can be clearer and then speak to them about it and see what they can can do!!
- CONFIGURE HYPRLAND to have super + c be copy (NOT close -remove that from the config), and super + v be paste!!!!
- Make better shortcuts for nvim... such as an alternative to control + w, and generally a better shortcut to make windows thinner (instead of control + w, then <).
- make a remove section for the files that I uninstalled on one machine so that they're auto-removed on another machine..


- at some point try out a few different machine in qemu ... some for the apple 2, early dos computers, see what they were like!! is kinda cool to be able to do that!!

- practise PASTING over text in vim (without having to delete it first and adding it to the null register...) .... the way to do this is by first visually selecting what I want to paste over, and then pasting it..

- Make a command "df config XXXX" e.g. "df config hypr".... make a mapping file between a given name, and the config file used to config them... if one doesn't exist, it should prompt you to ask if you wanna create a new mapping... e.g. if you type "df config tmux" and you haven't yet mapped a config file to tmux, it should prompt you to ask if you want to provide a path to the file it should map to.. to store these, keep a json file in the $dotfiles root called .config_shortcuts.json or something ...

- Doubt it's possible but see if there's a way to disable chatpt completions once you've inserted a comment like # ... so that it isn't suggesting annoying comments... or at least reject a suggestion once it gives one to clear the screen and make it easier to read/think...
