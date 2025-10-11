#!/bin/zsh

INSTALL_DIR=$HOME/.dotfiles
# install macos developer tools to get access to git
xcode-select --install
# clone the dotfiles repo to current working directory
git clone --recurse-submodules https://github.com/btrachey/dotfiles.git $INSTALL_DIR
# install homebrew
if ! command -v brew &>/dev/null; then
  /bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"
fi
# install homebrew packages
brew bundle install --file=$INSTALL_DIR/Brewfile
# install sdkman
if ! command -v sdk &>/dev/null; then
  curl -s "https://get.sdkman.io?rcupdate=false" | bash
fi
source $HOME/.sdkman/bin/sdkman-init.sh
# install JDK
sdk install java 11.0.26-tem
sdk use java 11.0.26-tem
# setup symlinks from other script
zsh $INSTALL_DIR/symlinks.sh
# set osx preferences
zsh $INSTALL_DIR/osx-prefs.sh
# install terminfo for `wezterm`
zsh $INSTALL_DIR/wezterm-terminfo.sh
# nvm
# curl -o- https://raw.githubusercontent.com/nvm-sh/nvm/v0.39.7/install.sh | bash
# install scala tooling with Coursier; `cs` should have been installed by homebrew
eval "$(cs setup --env)"
# set up personal AWS credentials; has to be after `cs setup` so that ammonite is installed
amm $INSTALL_DIR/generate_personal_aws_credentials.sc
