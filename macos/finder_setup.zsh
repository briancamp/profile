#!/usr/bin/env zsh

set -euo pipefail

# Configure the Dock
defaults write com.apple.dock show-recents -bool false

# Keep desktop clicks from moving windows aside
defaults write com.apple.WindowManager \
  EnableStandardClickToShowDesktop -bool false

# Configure Finder
defaults write com.apple.finder FXPreferredViewStyle -string "Nlsv"
defaults write com.apple.finder FXPreferredGroupBy -string "Name"
defaults write com.apple.finder ShowExternalHardDrivesOnDesktop -bool true
defaults write com.apple.finder ShowMountedServersOnDesktop -bool true

# Disable .DS_Store files on external and network volumes
defaults write com.apple.desktopservices DSDontWriteNetworkStores -bool true
defaults write com.apple.desktopservices DSDontWriteUSBStores -bool true

# Update nested Finder settings without replacing unrelated values
finder_preferences="$(mktemp)"
trap 'rm -f "$finder_preferences"' EXIT

defaults export com.apple.finder "$finder_preferences"

plutil -replace \
  DesktopViewSettings.IconViewSettings.arrangeBy \
  -string name \
  "$finder_preferences"

plutil -replace \
  StandardViewSettings.ListViewSettings.sortColumn \
  -string name \
  "$finder_preferences"

plutil -replace \
  StandardViewSettings.ExtendedListViewSettingsV2.sortColumn \
  -string name \
  "$finder_preferences"

defaults import com.apple.finder "$finder_preferences"
rm -f "$finder_preferences"
trap - EXIT

pkill -x Dock Finder WindowManager > /dev/null 2>&1 || true
