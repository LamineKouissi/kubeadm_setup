#!/bin/bash

set -e

# Function to check if script is run with sudo
check_sudo() {
    if [ "$EUID" -ne 0 ]; then 
        echo "Please run this script with sudo or as root."
        exit 1
    fi
}

# Function to get the latest runc version
get_latest_version() {
    curl -s https://api.github.com/repos/opencontainers/runc/releases/latest | grep -oP '"tag_name": "\K(.*)(?=")'
}

# Function to download runc binary and checksum
download_runc() {
    local version=$1
    local arch=$2
    local base_url="https://github.com/opencontainers/runc/releases/download/${version}"
    local binary_url="${base_url}/runc.${arch}"
    local checksum_url="${base_url}/sha256sum.txt"

    echo "Downloading runc ${version} for ${arch}..."
    curl -fsSLO "${binary_url}"
    curl -fsSLO "${checksum_url}"
}

# Function to verify checksum
verify_checksum() {
    local arch=$1
    echo "Verifying checksum..."
    grep "runc.${arch}" sha256sum.txt | sha256sum -c -
}

# Function to install runc
install_runc() {
    local arch=$1
    echo "Installing runc..."
    install -m 755 "runc.${arch}" /usr/local/sbin/runc
    echo "runc has been installed to /usr/local/sbin/runc"
}

# Main execution
main() {
    check_sudo

    # Determine architecture
    local arch=$(uname -m)
    case ${arch} in
        x86_64)  arch="amd64" ;;
        aarch64) arch="arm64" ;;
        armv7l)  arch="arm" ;;
        *)
            echo "Unsupported architecture: ${arch}"
            exit 1
            ;;
    esac

    local version=$(get_latest_version)
    echo "Latest runc version: ${version}"

    download_runc "${version}" "${arch}"
    verify_checksum "${arch}"
    install_runc "${arch}"

    # Clean up downloaded files
    rm "runc.${arch}" sha256sum.txt

    echo "runc installation completed successfully!"
}

# Run the main function
main