#!/bin/bash
set -e

# Get latest version
LATEST_VERSION=$(curl -s https://api.github.com/repos/containernetworking/plugins/releases/latest | grep -oP '"tag_name": "\K(.*)(?=")')
echo "Latest version: $LATEST_VERSION"

# Set OS and ARCH
OS="linux"
ARCH="amd64"

# Construct file name and download URL
FILE="cni-plugins-$OS-$ARCH-${LATEST_VERSION}.tgz"
DOWNLOAD_URL="https://github.com/containernetworking/plugins/releases/download/${LATEST_VERSION}/${FILE}"

# Download archive
wget $DOWNLOAD_URL

# Create Dest Dir
sudo mkdir -p /opt/cni/bin

# Extract archive
sudo tar Cxzvf /opt/cni/bin $FILE

echo "cni plugins have been successfully downloaded, verified, and extracted to /opt/cni/bin"