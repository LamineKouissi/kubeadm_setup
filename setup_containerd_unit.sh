#!/bin/bash

# Exit immediately if a command exits with a non-zero status
set -e

# Function to check if script is run with sudo
check_sudo() {
    if [ "$EUID" -ne 0 ]; then 
        echo "Please run this script with sudo or as root."
        exit 1
    fi
}

# Function to download the service file
download_service_file() {
    local url="https://raw.githubusercontent.com/containerd/containerd/main/containerd.service"
    local dest="/usr/local/lib/systemd/system/containerd.service"
    
    echo "Downloading containerd.service..."
    
    # Create directory if it doesn't exist
    mkdir -p "$(dirname "$dest")"
    
    # Download the file
    if curl -fsSL "$url" -o "$dest"; then
        echo "Successfully downloaded containerd.service to $dest"
    else
        echo "Failed to download containerd.service"
        exit 1
    fi
}

# Function to enable and start containerd
setup_containerd() {
    echo "Reloading systemd daemon..."
    systemctl daemon-reload
    
    echo "Enabling and starting containerd service..."
    systemctl enable --now containerd
    
    echo "Containerd service has been enabled and started."
}

# Main execution
main() {
    check_sudo
    download_service_file
    setup_containerd
    echo "Containerd setup completed successfully!"
}

# Run the main function
main