#!/usr/bin/env sh

set -e


info() {
	echo "$(tput bold)${@}$(tput sgr0)"
}

error() {
	>&2 echo "$(tput bold)$(tput setaf 1)${@}$(tput sgr0)"
}

fail() {
	rc="${?}"
	error "${@}"
	exit "${rc}"
}

system_package() {
	if [ -x "$(command -v apt-get)" ]; then
		sudo apt-get install -y "${@}"	
	elif [ -x "$(command -v brew)" ]; then
	 	brew install "${@}"
	elif [ -x "$(command -v pacman)" ]; then
		sudo pacman -S "${@}"
	elif [ -x "$(command -v dnf)" ]; then
		dnf -y "${@}"
	elif [ -x "$(command -v zypper)" ]; then
		sudo zypper in "${@}"
	elif [ -x "$(command -v port)" ]; then
		sudo port selfupdate
		sudo port install "${@}"
	else
		return 1
	fi
}

git_pull_or_clone() {
	if [ ! -d "${2}/.git" ]; then
		git clone "${1}" "${2}" --depth=1
	else
		git -C "${2}" pull --rebase --autostash --depth=1 
	fi
}

info "Installing packages..."
system_package "git" "neovim" || fail "Install failed"

data_dir="$(nvim --headless -u NONE -c 'echo stdpath("data")' -c q 2>&1)"
info "Installing minpac..."
git_pull_or_clone \
	https://github.com/k-takata/minpac.git \
	"${data_dir}/site/pack/minpac/opt/minpac" \
	|| fail "Installing minpac failed"

config_dir="$(nvim --headless -u NONE -c 'echo stdpath("config")' -c q 2>&1)"
info "Configuring neovim..."
git_pull_or_clone \
	https://github.com/mwilliammyers/neovim-config.git \
	"${config_dir}" \
	|| fail "Cloning neovim configuration failed"
nvim --headless -c 'PackUpdate' -c q || fail "Configuring neovim failed"
