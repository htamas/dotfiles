#!/usr/bin/env zsh
set -e

echo "🍺 Installing homebrew packages"
brew bundle --file=~/.dotfiles/homebrew/.Brewfile
echo "✅ Packages installed"
echo "🪏 Linking up config files..."
stow fish git homebrew mise zed
echo "✅ Config files are in place"

echo "🐠 Configuring fish..."
# Download and install fisher
curl -sL https://raw.githubusercontent.com/jorgebucaran/fisher/main/functions/fisher.fish -o /tmp/fisher.fish
fish -c "source /tmp/fisher.fish && fisher install jorgebucaran/fisher"
fish -c "fisher update"
rm /tmp/fisher.fish
fish -c "fisher install IlanCosman/tide@v6"
fish -c "tide configure --auto --style=Lean --prompt_colors='True color' --show_time='24-hour format' --lean_prompt_height='Two lines' --prompt_connection=Disconnected --prompt_spacing=Sparse --icons='Few icons' --transient=No"
echo "✅ fish configured"

echo "Setting up key repeat preferences..."
defaults write -g InitialKeyRepeat -int 12
defaults write -g KeyRepeat -int 2
echo "✅ Key repeat preferences are set up"

echo "🐠 Making fish shell the default..."

# Detect architecture
ARCH=$(uname -m)
echo "Detected architecture: $ARCH"

# Determine fish path based on architecture
if [[ "$ARCH" == "arm64" ]]; then
    # Apple Silicon Mac
    FISH_PATH="/opt/homebrew/bin/fish"
    echo "Apple Silicon detected - using $FISH_PATH"
elif [[ "$ARCH" == "x86_64" ]]; then
    # Intel Mac
    FISH_PATH="/usr/local/bin/fish"
    echo "Intel Mac detected - using $FISH_PATH"
else
    echo "❌ Unsupported architecture: $ARCH"
    exit 1
fi

# Check if fish is installed at the expected location
if [[ ! -f "$FISH_PATH" ]]; then
    echo "❌ Fish shell not found at $FISH_PATH"
    echo "Please install fish via Homebrew first: brew install fish"
    exit 1
fi

echo "✅ Found fish at $FISH_PATH"

# Check if fish is already in /etc/shells
if grep -q "$FISH_PATH" /etc/shells; then
    echo "✅ Fish is already registered in /etc/shells"
else
    echo "📝 Adding fish to /etc/shells..."
    sudo sh -c "echo $FISH_PATH >> /etc/shells"
    echo "✅ Added fish to /etc/shells"
fi

# Check if fish is already the default shell
CURRENT_SHELL=$(echo $SHELL)
if [[ "$CURRENT_SHELL" == "$FISH_PATH" ]]; then
    echo "✅ Fish is already your default shell"
else
    echo "🔄 Changing default shell to fish..."
    chsh -s "$FISH_PATH"
    echo "✅ Default shell changed to fish"
    echo "💡 Please restart your terminal or run 'exec $FISH_PATH' to start using fish"
fi

echo "🎉 Fish shell setup complete!"
