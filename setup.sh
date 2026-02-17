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
/opt/homebrew/bin/brew bundle install --file=$INSTALL_DIR/Brewfile
# install version-controlled tools (e.g. python, java, node, etc.)
mise install
# setup symlinks from other script
zsh $INSTALL_DIR/symlinks.sh
# set osx preferences
zsh $INSTALL_DIR/osx-prefs.sh
# install terminfo for `wezterm`
zsh $INSTALL_DIR/wezterm-terminfo.sh
# install scala tooling with Coursier; `cs` should have been installed by homebrew
eval "$(cs setup --env)"
# remind me to set up AWS credentials
echo "Don't forget to set up AWS credentials at `/.aws/credentials`\naws_access_key_id=???\naws_secret_access_key=???"
