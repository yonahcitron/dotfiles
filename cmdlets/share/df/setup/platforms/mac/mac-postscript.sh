# Load Zsh's colors module for styling output
autoload -U colors && colors

# --- Configuration for Chrome App Checks ---
# This check is configured in: YOUR_CONFIG_FILE_PATH_HERE

# Define the list of required Chrome app names
required_chrome_apps=(
  "YouTube"
  "YouTube Music"
  "Gemini"
  "DevOps"
)

# Define the directory where Chrome PWAs are installed
chrome_apps_dir="$HOME/Applications/Chrome Apps.localized"
# --- Perform Checks and Display Warnings ---

# Loop through each required app
for app_name in "${required_chrome_apps[@]}"; do
  # Construct the full path to the expected .app file
  app_path="$chrome_apps_dir/$app_name.app"

  # Check if the .app directory does NOT exist
  if [[ ! -d "$app_path" ]]; then
    # If not found, print a prominent warning with installation instructions
    print -P "%F{yellow}⚠️  Chrome App Not Found: '$app_name'%f"

    # Provide tailored installation URLs
    case "$app_name" in
    "YouTube")
      url="https://www.youtube.com"
      ;;
    "YouTube Music")
      url="https://music.youtube.com"
      ;;
    "Gemini")
      url="https://gemini.google.com"
      ;;
    "DevOps")
      # Replace with your actual DevOps URL (e.g., Azure DevOps, Jira)
      url="https://dev.azure.com/YOUR_ORG"
      ;;
    *)
      url="the relevant website"
      ;;
    esac

    print -P "%F{cyan}   To install, please go to %U$url%u in Google Chrome,"
    print -P "   then click the 'Install' icon (a screen with a downward arrow) in the address bar."
    print -P "   Note that until this is done, yabai+skhd window manager keyboard mappings will not work. The installation must be done manually, since progressive web apps cannot be programmatically installed for chrome.%f"
    print "" # Add a blank line for readability

    print "To change which programs triggers this warning, edit the file in /Users/Yonah.Citron/repos/dotfiles/cmdlets/share/df/setup/platforms/mac/mac-postscript.sh"
  fi
done

# Remove animations to speed up transitions between windows etc when using yabai
defaults write com.apple.universalaccess reduceMotion -bool true
