#!/bin/bash

RPITX_DIR="$HOME/rpitx"
RIFE_DIR="$HOME/rpitx/src/rife"
TMP_SWEEP_DIR="$HOME/rpitx/src/rife/tmp_sweeps"
REPO_DIR="$HOME/RifePi"
START_SCRIPT="$HOME/start.sh"
STOP_SCRIPT="$HOME/stop.sh"
TRAN_SCRIPT="$HOME/rpitx/tran.sh"

# Ensure the script is run as root
if [ "$(id -u)" -ne 0 ]; then
    echo "This script must be run as root. Please run with sudo."
    exit 1
fi

# Function to install dependencies
install_dependencies() {
    echo "Installing dependencies..."
    apt-get update
    apt-get install -y sox screen
}

# Function to remove existing rpitx folder
remove_existing_rpitx() {
    if [ -d "$RPITX_DIR" ]; then
        echo "Removing existing RPiTX directory..."
        rm -rf "$RPITX_DIR"
    fi
}

# Function to install rpitx
install_rpitx() {
    echo "RPiTX is not installed. Installing now..."
    git clone https://github.com/F5OEO/rpitx.git "$RPITX_DIR"
    cd "$RPITX_DIR"
    ./install.sh
}

# Function to copy files and set permissions
install_rife_modification() {
    # Create rife and tmp_sweeps directories if they don't exist
    if [ ! -d "$RIFE_DIR" ]; then
        mkdir -p "$RIFE_DIR"
    fi

    if [ ! -d "$TMP_SWEEP_DIR" ]; then
        mkdir -p "$TMP_SWEEP_DIR"
    fi

    # Copy the rife files
    echo "Copying rife files..."
    cp -r "$REPO_DIR/rife/"* "$RIFE_DIR/"

    # Copy start.sh and stop.sh to $HOME
    echo "Copying start.sh and stop.sh..."
    cp "$REPO_DIR/start.sh" "$START_SCRIPT"
    cp "$REPO_DIR/stop.sh" "$STOP_SCRIPT"

    # Copy tran.sh to $HOME/rpitx
    echo "Copying tran.sh..."
    cp "$REPO_DIR/tran.sh" "$TRAN_SCRIPT"

    # Set permissions and ownership
    echo "Setting permissions and ownership..."
    chown -R "$USER:$USER" "$RIFE_DIR" "$START_SCRIPT" "$STOP_SCRIPT" "$TRAN_SCRIPT"
    chmod +x "$START_SCRIPT" "$STOP_SCRIPT" "$TRAN_SCRIPT"
    chmod -R +x "$RIFE_DIR"

    echo "Installation complete."
}

# Main script execution
install_dependencies
remove_existing_rpitx
install_rpitx
install_rife_modification
