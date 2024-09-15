#!/bin/bash
set -e

# Get latest version
LATEST_VERSION=$(curl -s https://api.github.com/repos/containerd/containerd/releases/latest | grep -oP '"tag_name": "\K(.*)(?=")')
echo "Latest version: $LATEST_VERSION"

# Set OS and ARCH
OS="linux"
ARCH="amd64"

# Construct file name and download URL
FILE="containerd-${LATEST_VERSION#v}-$OS-$ARCH.tar.gz"
DOWNLOAD_URL="https://github.com/containerd/containerd/releases/download/${LATEST_VERSION}/${FILE}"

# Download archive
wget $DOWNLOAD_URL

# Download and verify checksum
wget "${DOWNLOAD_URL}.sha256sum"
sha256sum -c "${FILE}.sha256sum"

# Extract archive
sudo tar Cxzvf /usr/local $FILE

echo "Containerd has been successfully downloaded, verified, and extracted to /usr/local"