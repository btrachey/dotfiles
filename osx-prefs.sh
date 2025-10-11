set-prefs() {
  # save screenshots to custom folder
  mkdir $HOME/Pictures/Screenshots
  defaults write com.apple.screencapture location -string "$HOME/Pictures/Screenshots"
  defaults write NSGlobalDomain NSAutomaticQuoteSubstitutionEnabled -bool false
  defaults write NSGlobalDomain NSAutomaticCapitalizationEnable -bool falsed
  defaults write NSGlobalDomain NSAutomaticDashSubstitutionEnabled -bool false
  defaults write NSGlobalDomain NSAutomaticInlinePredictionEnabled -bool false
  defaults write NSGlobalDomain NSAutomaticPeriodSubstitutionEnabled -bool false
  defaults write NSGlobalDomain NSAutomaticSpellingCorrectionEnabled -bool false
}

set-prefs
