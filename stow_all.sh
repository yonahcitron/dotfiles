#!bin/bash
WORKING_DIR=$(pwd)
SCRIPT_DIR="$(realpath -s -- "$(dirname -- "${BASH_SOURCE[0]}")")"
HOME_STOW_DIR=$SCRIPT_DIR/user_configs
GLOBAL_STOW_DIR=$SCRIPT_DIR/global_configs
HOME_TARGET="/home/$USER"
GLOBAL_TARGET="/etc"

echo "The pwd is: $WORKING_DIR"
echo "The home stow dir is: $HOME_STOW_DIR"
echo "The global stow dir is: $GLOBAL_STOW_DIR"
echo "The home target is: $HOME_TARGET"
echo "The global target is: $GLOBAL_TARGET"

# In order to get the intended functionality of treating each of the subfolders of the stow dir as a module, and reacreate each of their substructures within the target dirs, rather than just dumping them in the target dir directly, we *must* use the cd approach. This is why we can specify the --dir directly for our command which would be more elegant.
read -rp "Setting up user configs. Hit enter to continue, ctrl+c to cancel..."
cd $HOME_STOW_DIR
stow --target $HOME_TARGET */  # User configs.

# Global configs.
read -rp "Setting up global configs. Hit enter to continue, ctrl+c to cancel..."
cd $GLOBAL_STOW_DIR
sudo stow --target $GLOBAL_TARGET */

cd $WORKING_DIR
