#!/usr/bin/env bash
# Apply macOS system preferences captured from Dan's MacBook Pro.
# Only settings that differ from Apple's defaults are listed here.
# Re-capture with: ./scripts/backup.sh (prints current values for review)
set -euo pipefail

echo "==> Dock"
defaults write com.apple.dock autohide -bool true
defaults write com.apple.dock tilesize -int 63
defaults write com.apple.dock show-recents -bool false
defaults write com.apple.dock mru-spaces -bool false   # don't reorder Spaces by use

echo "==> Finder"
defaults write com.apple.finder ShowPathbar -bool true
defaults write com.apple.finder ShowStatusBar -bool true
defaults write com.apple.finder FXPreferredViewStyle -string "Nlsv"   # list view

echo "==> Global"
defaults write NSGlobalDomain AppleShowAllExtensions -bool true
defaults write NSGlobalDomain AppleInterfaceStyle -string "Dark"
defaults write NSGlobalDomain AppleShowScrollBars -string "Always"
defaults write NSGlobalDomain com.apple.swipescrolldirection -bool false  # natural scrolling OFF
defaults write NSGlobalDomain ApplePressAndHoldEnabled -bool false       # key repeat instead of accent menu (for vim)

echo "==> Screenshots"
mkdir -p "$HOME/Documents/Screenshots"
defaults write com.apple.screencapture location -string "$HOME/Documents/Screenshots"

echo "==> Restarting affected apps"
killall Dock  2>/dev/null || true
killall Finder 2>/dev/null || true
killall SystemUIServer 2>/dev/null || true

echo "Done. Some changes need a logout/restart to fully apply."
