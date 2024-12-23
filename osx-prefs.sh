set-prefs() {
  # save screenshots to custom folder
  mkdir $HOME/Pictures/Screenshots
  defaults write com.apple.screencapture location -string "$HOME/Pictures/Screenshots"
}

set-prefs
