#!/bin/bash
set -e

# install.sh
#       This script installs my basic setup for a debian laptop

# get the user that is not root
# TODO: makes a pretty bad assumption that there is only one other user
USERNAME=$(find /home/* -maxdepth 0 -printf "%f" -type d || echo "$USER")
export DEBIAN_FRONTEND=noninteractive

check_is_sudo() {
        if [ "$EUID" -ne 0 ]; then
                echo "Please run as root."
                exit
        fi
}
