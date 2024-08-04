#!/bin/bash

# Find and terminate all rpitx processes
sudo pkill -f rpitx

# Find and terminate all screen sessions related to rpitx
screen -ls | grep rpitx_session | awk -F. '{print $1}' | xargs kill

# Find and terminate the tran.sh script
sudo pkill -f tran.sh

# Purge the tmp_files and tmp_sweeps folders
sudo find "$HOME/rpitx/src/rife/tmp_files/" -type f -exec rm -v {} +
sudo find "$HOME/rpitx/src/rife/tmp_sweeps/" -type f -exec rm -v {} +

echo "Stopped all rpitx processes, screen sessions, tran.sh script, and purged the tmp_files and tmp_sweeps folders"
