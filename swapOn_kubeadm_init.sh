#!/bin/bash

# Exit immediately if a command exits with a non-zero status
set -e

# check if script is run with sudo
if [ "$EUID" -ne 0 ]; then 
        echo "Please run this script with sudo or as root."
        exit 1
fi

# Configure the kubelet that kubeadm will start
# The swapOnKubeletConfig.yaml includes the KubeletConfiguration API object
kubeadm init --config ./swapOnKubeletConfig.yaml