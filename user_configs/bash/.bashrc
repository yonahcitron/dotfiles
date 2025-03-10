export dotfiles="~/repos/dotfiles"
echo $dotfiles
# TODO: Make a little dotfiles cmdlet so I don't need to always be in the in the dotfiles folder to do things... with commands like dotfiles update (which does add, prints changes, commits, and pushes), dotfiles apply, dotfiles status, dotfiles unapply (or find a better word from chatgpt), dotfiles install (which does an update of AUR / pacman, downloads the package locally, and then appends it to the packages file so that it will be downloaded to all machines.)
# TODO: Also remember to implement the startup logic on my machine (I've specified it I think in tododist or maybe one of my readmes) that checks for dotfiles updates etc in github and syncs between them. Read the docs I wrote there for details 
#     Whenever I do updates to configs, download new files
export SUDO_EDITOR=vim



