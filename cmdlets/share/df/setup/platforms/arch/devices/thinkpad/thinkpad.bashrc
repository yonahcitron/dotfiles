# To check power on my thinkpad.
# TODO: Move this into the platform specific section of the init code.
alias power="upower -i $(upower -e | grep battery) | awk '/percentage/ {print $2}'"
# To change the brightness quickly.
# TODO: Make this into a function at somepoint so I can just go `b 20` and not need to include the % sign at the end.
alias b="brightnessctl set"
