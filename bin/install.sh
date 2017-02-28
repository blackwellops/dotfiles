#!/bin/bash
set -e

# install.sh
#       This script installs my basic setup for a debian laptop

# get the user that is not root
# TODO: makes a pretty bad assumption that there is only one other user
#USERNAME=$(find /home/* -maxdepth 0 -printf "%f" -type d || echo "$USER")
export DEBIAN_FRONTEND=noninteractive

check_is_sudo() {
        if [ "$EUID" -ne 0 ]; then
                echo "Please run as root."
                exit
        fi
}

install_keybase() {
	# https://keybase.io/docs/the_app/install_linux
	curl -O https://prerelease.keybase.io/keybase_amd64.deb 
	# if you see an error about missing `libappindicator1`
	# from the next command, you can ignore it, as the
	# subsequent command corrects it
	sudo dpkg -i keybase_amd64.deb
	sudo apt-get install -f
}

usage() {
	echo -e "install.sh\n\tThis script installs my basic setup for a debian laptop\n"
	echo "Usage:"
	echo "  sources                     - setup sources & install base pkgs"
	echo "  wifi {broadcom,intel}       - install wifi drivers"
	echo "  graphics {dell,mac,lenovo}  - install graphics drivers"
	echo "  wm                          - install window manager/desktop pkgs"
	echo "  dotfiles                    - get dotfiles"
	echo "  vim                         - install vim specific dotfiles"
	echo "  golang                      - install golang and packages"
	echo "  scripts                     - install scripts"
	echo "  syncthing                   - install syncthing"
	echo "  vagrant                     - install vagrant and virtualbox"
	echo "  keybase                     - install keybase" 
}

main() {
	local cmd=$1

	if [[ -z "$cmd" ]]; then
		usage
		exit 1
	fi

	if [[ $cmd == "sources" ]]; then
		check_is_sudo

		# setup /etc/apt/sources.list
		setup_sources

		base
	elif [[ $cmd == "wifi" ]]; then
		install_wifi "$2"
	elif [[ $cmd == "graphics" ]]; then
		check_is_sudo

		install_graphics "$2"
	elif [[ $cmd == "wm" ]]; then
		check_is_sudo

		install_wmapps
	elif [[ $cmd == "dotfiles" ]]; then
		get_dotfiles
	elif [[ $cmd == "vim" ]]; then
		install_vim
	elif [[ $cmd == "golang" ]]; then
		install_golang "$2"
	elif [[ $cmd == "scripts" ]]; then
		install_scripts
	elif [[ $cmd == "syncthing" ]]; then
		install_syncthing
	elif [[ $cmd == "vagrant" ]]; then
		install_vagrant "$2"
	elif [[ $cmd == "keybase" ]]; then
		install_keybase "$2"
	else
		usage
	fi
}

main "$@"
