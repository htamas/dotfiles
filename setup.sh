#!/usr/bin/env bash

# Install homebrew packages
echo "Installing homebrew packages..."
brew bundle --file=~/.dotfiles/homebrew/.Brewfile

# Symlink config files
echo "Linking config files..."
stow --restow fish git homebrew mise zed

# Install fisher (fish plugin manager)
if ! fish -c "type -q fisher" 2>/dev/null; then
    echo "Installing fisher..."
    fish -c "curl -sL https://git.io/fisher | source && fisher install jorgebucaran/fisher"
else
    echo "Fisher already installed."
fi

# Set fish as default shell
FISH_PATH=$(which fish)
if [ -n "$FISH_PATH" ]; then
    grep -q "$FISH_PATH" /etc/shells || sudo sh -c "echo $FISH_PATH >> /etc/shells"
    [ "$SHELL" != "$FISH_PATH" ] && chsh -s "$FISH_PATH"
    echo "Fish set as default shell."
else
    echo "Fish not found — skipping default shell setup."
fi

# macOS preferences
defaults write -g InitialKeyRepeat -int 12
defaults write -g KeyRepeat -int 2
defaults write -g com.apple.keyboard.fnState -bool true
defaults write NSGlobalDomain AppleShowAllExtensions -bool true

# Keyboard shortcuts: Alt+1..5 to switch to Desktop 1..5
defaults write com.apple.symbolichotkeys AppleSymbolicHotKeys -dict-add 118 '{ enabled = 1; value = { parameters = (49, 18, 524288); type = standard; }; }'
defaults write com.apple.symbolichotkeys AppleSymbolicHotKeys -dict-add 119 '{ enabled = 1; value = { parameters = (50, 19, 524288); type = standard; }; }'
defaults write com.apple.symbolichotkeys AppleSymbolicHotKeys -dict-add 120 '{ enabled = 1; value = { parameters = (51, 20, 524288); type = standard; }; }'
defaults write com.apple.symbolichotkeys AppleSymbolicHotKeys -dict-add 121 '{ enabled = 1; value = { parameters = (52, 21, 524288); type = standard; }; }'
defaults write com.apple.symbolichotkeys AppleSymbolicHotKeys -dict-add 122 '{ enabled = 1; value = { parameters = (53, 23, 524288); type = standard; }; }'
echo "macOS preferences set."

echo "Done! Restart your terminal to start using fish."
echo "Run 'tide configure' to set up your prompt theme."
