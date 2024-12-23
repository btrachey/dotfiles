#!/bin/zsh

INSTALL_DIR=$HOME/.dotfiles
# install macos developer tools to get access to git
xcode-select --install
# clone the dotfiles repo to current working directory
git clone https://github.com/brian-tracey_prot/dotfiles.git $INSTALL_DIR
# install homebrew
/bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"
# install homebrew packages
brew bundle install --file=$INSTALL_DIR/Brewfile
# sdkman
# curl -s "https://get.sdkman.io" | bash
# nvm
# curl -o- https://raw.githubusercontent.com/nvm-sh/nvm/v0.39.7/install.sh | bash
# install scala tooling with Coursier; `cs` should have been installed by homebrew
cs setup
# setup symlinks from other script
zsh $INSTALL_DIR/symlinks.sh
# set osx preferences
zsh $INSTALL_DIR/osx-prefs.sh
# set up personal AWS credentials
amm $INSTALL_DIR/generate_personal_aws_credentials.sc
