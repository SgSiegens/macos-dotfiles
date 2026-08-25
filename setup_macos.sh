#!/usr/bin/env bash


################################################################################
# System Preferences > General > Language & Region
################################################################################

defaults write ".GlobalPreferences" AppleLanguages -array en-GB pl-GB
defaults write -globalDomain AppleLanguages -array en-GB pl-GB


################################################################################
# System Preferences > Siri & Spotlight
################################################################################

#Ask Siri
defaults write com.apple.Siri SiriPrefStashedStatusMenuVisible -bool false
defaults write com.apple.Siri VoiceTriggerUserEnabled -bool false


################################################################################
# System Settings > Accessibility > Display
################################################################################

# Reduce motion / disable UI animations
defaults write com.apple.universalaccess reduceMotion -bool true



################################################################################
# System Preferences > Keyboard
################################################################################

# Linux-style editing shortcuts
defaults write NSGlobalDomain NSUserKeyEquivalents -dict-add "Copy" "^c"
defaults write NSGlobalDomain NSUserKeyEquivalents -dict-add "Paste" "^v"
defaults write NSGlobalDomain NSUserKeyEquivalents -dict-add "Cut" "^x"
defaults write NSGlobalDomain NSUserKeyEquivalents -dict-add "Undo" "^z"
defaults write NSGlobalDomain NSUserKeyEquivalents -dict-add "Redo" "^$z"
defaults write NSGlobalDomain NSUserKeyEquivalents -dict-add "Select All" "^a"


# Disable Ctrl+Space input source switching
defaults write com.apple.symbolichotkeys AppleSymbolicHotKeys -dict-add 60 '<dict><key>enabled</key><false/></dict>'

defaults write com.apple.symbolichotkeys AppleSymbolicHotKeys -dict-add 61 '<dict><key>enabled</key><false/></dict>'

# 79 = Mission Control: Move left a space   (default: Control+Left)
# 81 = Mission Control: Move right a space  (default: Control+Right)
defaults write com.apple.symbolichotkeys AppleSymbolicHotKeys -dict-add 79 '<dict><key>enabled</key><false/></dict>'
defaults write com.apple.symbolichotkeys AppleSymbolicHotKeys -dict-add 81 '<dict><key>enabled</key><false/></dict>'

# Disable Ctrl+1 through Ctrl+6 for switching desktops
defaults write com.apple.symbolichotkeys AppleSymbolicHotKeys \
    -dict-add 118 '<dict><key>enabled</key><false/></dict>'

defaults write com.apple.symbolichotkeys AppleSymbolicHotKeys \
    -dict-add 119 '<dict><key>enabled</key><false/></dict>'

defaults write com.apple.symbolichotkeys AppleSymbolicHotKeys \
    -dict-add 120 '<dict><key>enabled</key><false/></dict>'

defaults write com.apple.symbolichotkeys AppleSymbolicHotKeys \
    -dict-add 121 '<dict><key>enabled</key><false/></dict>'

defaults write com.apple.symbolichotkeys AppleSymbolicHotKeys \
    -dict-add 122 '<dict><key>enabled</key><false/></dict>'

defaults write com.apple.symbolichotkeys AppleSymbolicHotKeys \
    -dict-add 123 '<dict><key>enabled</key><false/></dict>'



################################################################################
# System Preferences > Menu Bar
################################################################################

# Automatically hide and show the menu bar
defaults write NSGlobalDomain _HIHideMenuBar -bool true

# Menu Bar Controls > keep no recent items
defaults write "com.apple.controlcenter" "NumberOfRecents" -int 0

# Menu Bar Controls > Bluetooth > Show in Menu Bar
defaults write "com.apple.controlcenter" "NSStatusItem Visible Bluetooth" -bool true

# Menu Bar Controls > Screen Mirroring > Don't Show in Menu Bar
defaults write "com.apple.airplay" showInMenuBarIfPresent -bool false

# Menu Bar Controls > Sound > Always Show in Menu Bar
defaults write "com.apple.controlcenter" "NSStatusItem Visible Sound" -bool true

# Menu Bar Controls > Now Playing > Don't Show in Menu Bar
defaults write "com.apple.airplay" "NSStatusItem Visible NowPlaying" -bool false

# Menu Bar Only > Spotlight > Don't Show in Menu Bar
defaults -currentHost write com.apple.Spotlight MenuItemHidden -int 1



################################################################################
# Finder > Preferences
################################################################################

# Show all filename extensions
defaults write NSGlobalDomain AppleShowAllExtensions -bool true

# Show warning before removing from iCloud Drive
defaults write com.apple.finder FXEnableRemoveFromICloudDriveWarning -bool false

# Finder > View > As List
defaults write com.apple.finder FXPreferredViewStyle -string "Nlsv"

# Finder > View > Show Path Bar
defaults write com.apple.finder ShowPathbar -bool true


################################################################################
# System Preferences > Desktop & Dock
################################################################################

# Hide the dock
defaults write com.apple.dock autohide -bool true



# Kill affected apps
for app in Dock Finder; do
    killall $app >/dev/null 2>&1
done

# Done
echo "Done. Note that some of these changes require a logout/restart to take effect."
