#!/bin/bash

RPITX_DIR="/home/Ri/rpitx"
RIFE_DIR="/home/Ri/rpitx/src/rife"
START_SCRIPT="/home/Ri/start.sh"
STOP_SCRIPT="/home/Ri/stop.sh"
TRAN_SCRIPT="/home/Ri/rpitx/tran.sh"

# Check if rpitx is installed
if [ ! -d "$RPITX_DIR" ]; then
    echo "RPiTX is not installed. Installing now..."
    git clone https://github.com/F5OEO/rpitx.git "$RPITX_DIR"
    cd "$RPITX_DIR"
    sudo ./install.sh
else
    echo "RPiTX is already installed."
fi

# Create rife directory if it doesn't exist
if [ ! -d "$RIFE_DIR" ]; then
    mkdir -p "$RIFE_DIR"
fi

# Copy the rife files
echo "Copying rife files..."
cp -r ./rife/* "$RIFE_DIR/"

# Copy start.sh and stop.sh to /home/Ri
echo "Copying start.sh and stop.sh..."
cp ./start.sh "$START_SCRIPT"
cp ./stop.sh "$STOP_SCRIPT"

# Copy tran.sh to /home/Ri/rpitx
echo "Copying tran.sh..."
cp ./tran.sh "$TRAN_SCRIPT"

# Set permissions
echo "Setting permissions..."
chmod +x "$START_SCRIPT"
chmod +x "$STOP_SCRIPT"
chmod +x "$TRAN_SCRIPT"
chmod -R +x "$RIFE_DIR"

echo "Installation complete."
