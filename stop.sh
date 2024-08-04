#!/bin/bash

# Find and terminate all rpitx processes
sudo pkill -f rpitx

# Find and terminate all screen sessions related to rpitx
screen -ls | grep rpitx_session | awk -F. '{print $1}' | xargs kill

# Find and terminate the tran.sh script
sudo pkill -f tran.sh

# Purge the /home/Ri/rpitx/src/rife/tmp_files folder
rm -rf /home/Ri/rpitx/src/rife/tmp_files/*

echo "Stopped all rpitx processes, screen sessions, tran.sh script, and purged the tmp_files folder"