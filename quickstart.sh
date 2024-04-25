#!/usr/bin/env bash
set -euxo pipefail

# cd ~ && mkdir repos && cd repos

# git clone git@github.com:gvarihendrix/dotfiles.git dotfiles

brew install bash
brew install bat
brew install fd
brew install fish
brew install fzf
brew install gh
brew install git
brew install git-delta
brew install lazydocker
brew install lazygit
brew install lf
brew install lsd
brew install mackup
brew install neofetch
brew install neovim
brew install pgcli
brew install ripgrep
brew install starship
brew install tealdeer
brew install tmux
brew install wakatime-cli
brew install zoxide

brew tap clementtsang/bottom
brew install bottom
brew tap federico-terzi/espanso
brew install espanso

if [[ $PLATFORM == 'macos' ]]; then
	brew install trash-cli
	brew install koekeishiya/formulae/skhd
	skhd --start-service
	brew install koekeishiya/formulae/yabai
	yabai --start-service
fi

# mackup
# cp ~/repos/dotfiles/mackup/.mackup.cfg ~/.mackup.cfg
# mackup restore

# fisher https://github.com/jorgebucaran/fisher
curl -sL https://git.io/fisher | source && fisher install jorgebucaran/fisher
fisher install FabioAntunes/fish-nvm edc/bass franciscolourenco/done

# tpm https://github.com/tmux-plugins/tpm
git clone https://github.com/tmux-plugins/tpm ~/.tmux/plugins/tpm
~/.tmux/plugins/tpm/bin/install_plugins

# casks
if [[ $PLATFORM == 'macos' ]]; then
	brew install --cask 1password
	brew install --cask alfred
	brew install --cask discord
	brew install --cask fantastical
	brew install --cask home-assistant
	brew install --cask obsidian
	brew install --cask postman
	brew install --cask slack
	brew install --cask spacelauncher
	brew install --cask spotify
	brew install --cask vivaldi
fi
