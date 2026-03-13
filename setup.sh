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
echo "Key repeat preferences set."

echo "Done! Restart your terminal to start using fish."
echo "Run 'tide configure' to set up your prompt theme."
