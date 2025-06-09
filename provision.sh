#!/bin/bash

set -e

echo "🚀 MacBook Pro Development Environment Provisioner"
echo "================================================="
echo ""

# Check if we're on macOS
if [[ "$OSTYPE" != "darwin"* ]]; then
    echo "❌ This script is designed for macOS only"
    exit 1
fi

# Get script directory
SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"

# Function to check if app is installed via Homebrew cask
is_cask_installed() {
    brew list --cask "$1" &> /dev/null
}

# Function to check if CLI tool is installed via Homebrew
is_brew_installed() {
    brew list "$1" &> /dev/null
}

# ============================================================================
# CORE SYSTEM TOOLS
# ============================================================================

echo "📦 Installing core system tools..."

# Install Homebrew if not present
if ! command -v brew &> /dev/null; then
    echo "🍺 Installing Homebrew..."
    /bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"
    eval "$(/opt/homebrew/bin/brew shellenv)"
    
    # Add to shell profile
    echo 'eval "$(/opt/homebrew/bin/brew shellenv)"' >> ~/.zprofile
else
    echo "✅ Homebrew already installed"
fi

# Update Homebrew
echo "🔄 Updating Homebrew..."
brew update

# Install essential CLI tools
declare -a cli_tools=(
    "git"
    "gh"
    "curl"
    "wget"
    "jq"
    "tree"
    "htop"
    "nodenv"
    "neovim"
    "awscli"
    "google-cloud-sdk"
)

echo "🛠️ Installing CLI tools..."
for tool in "${cli_tools[@]}"; do
    if ! is_brew_installed "$tool"; then
        echo "📥 Installing $tool..."
        brew install "$tool"
    else
        echo "✅ $tool already installed"
    fi
done

# ============================================================================
# NODE.JS SETUP WITH NODENV
# ============================================================================

echo "📦 Setting up Node.js with nodenv..."

# Initialize nodenv if not already done
if [[ ! -d "$HOME/.nodenv" ]]; then
    echo "🔧 Initializing nodenv..."
    nodenv init
fi

# Install latest stable Node.js
if ! command -v node &> /dev/null; then
    echo "📥 Installing latest stable Node.js..."
    LATEST_NODE=$(nodenv install -l | grep -E "^\s*[0-9]+\.[0-9]+\.[0-9]+$" | tail -1 | tr -d ' ')
    nodenv install "$LATEST_NODE"
    nodenv global "$LATEST_NODE"
    nodenv rehash
else
    echo "✅ Node.js already installed"
fi

# ============================================================================
# APPLICATIONS
# ============================================================================

echo "📱 Installing applications..."

# Install applications via Homebrew Cask
declare -a apps=(
    "iterm2"
    "docker"
    "claude-code"
    "tuple"
    "slack"
    "font-fira-code-nerd-font"
)

for app in "${apps[@]}"; do
    if ! is_cask_installed "$app"; then
        echo "📥 Installing $app..."
        brew install --cask "$app"
    else
        echo "✅ $app already installed"
    fi
done

# ============================================================================
# ZSH AND OH-MY-ZSH SETUP
# ============================================================================

echo "🐚 Setting up Zsh and Oh My Zsh..."

# Install Oh My Zsh if not present
if [[ ! -d "$HOME/.oh-my-zsh" ]]; then
    echo "📥 Installing Oh My Zsh..."
    sh -c "$(curl -fsSL https://raw.github.com/ohmyzsh/ohmyzsh/master/tools/install.sh)" "" --unattended
else
    echo "✅ Oh My Zsh already installed"
fi

# Set Zsh as default shell if it isn't already
if [[ "$SHELL" != "$(which zsh)" ]]; then
    echo "🔄 Setting Zsh as default shell..."
    chsh -s "$(which zsh)"
else
    echo "✅ Zsh already default shell"
fi

# ============================================================================
# DOTFILES SETUP
# ============================================================================

echo "📁 Setting up dotfiles..."

# Backup existing .zshrc and link to our version
if [[ -f "$HOME/.zshrc" ]] && [[ ! -L "$HOME/.zshrc" ]]; then
    echo "📋 Backing up existing .zshrc to ~/.zshrc.backup"
    mv "$HOME/.zshrc" "$HOME/.zshrc.backup"
fi

if [[ -L "$HOME/.zshrc" ]]; then
    echo "🔗 Removing existing .zshrc symlink"
    rm "$HOME/.zshrc"
fi

echo "🔗 Creating symlink from ~/.zshrc to $SCRIPT_DIR/zshrc"
ln -s "$SCRIPT_DIR/zshrc" "$HOME/.zshrc"

# ============================================================================
# NEOVIM SETUP
# ============================================================================

echo "📝 Setting up Neovim..."

# Install language servers
declare -a servers=(
    "lua-language-server"
    "typescript-language-server" 
    "solargraph"
    "pyright"
)

echo "🔧 Installing language servers..."
for server in "${servers[@]}"; do
    if ! command -v "$server" &> /dev/null; then
        echo "📥 Installing $server..."
        brew install "$server"
    else
        echo "✅ $server already installed"
    fi
done

# Create config directory if it doesn't exist
mkdir -p ~/.config

# Backup existing nvim config if present
if [[ -d ~/.config/nvim ]] && [[ ! -L ~/.config/nvim ]]; then
    echo "📋 Backing up existing nvim config to ~/.config/nvim.backup"
    mv ~/.config/nvim ~/.config/nvim.backup
fi

# Remove symlink if it exists
if [[ -L ~/.config/nvim ]]; then
    echo "🔗 Removing existing nvim symlink"
    rm ~/.config/nvim
fi

# Create symlink to this repo's nvim config
echo "🔗 Creating symlink from ~/.config/nvim to $SCRIPT_DIR/nvim"
ln -s "$SCRIPT_DIR/nvim" ~/.config/nvim

# ============================================================================
# ITERM2 CONFIGURATION
# ============================================================================

echo "⚙️ Configuring iTerm2..."

# Check if iTerm2 preferences exist and back them up
if [[ -f ~/Library/Preferences/com.googlecode.iterm2.plist ]]; then
    echo "📋 Backing up existing iTerm2 preferences..."
    cp ~/Library/Preferences/com.googlecode.iterm2.plist "$SCRIPT_DIR/iterm2-backup.plist"
    
    # Copy current preferences to the repo for future use
    echo "💾 Saving current iTerm2 preferences to repo..."
    cp ~/Library/Preferences/com.googlecode.iterm2.plist "$SCRIPT_DIR/iterm2-preferences.plist"
else
    echo "ℹ️ No existing iTerm2 preferences found"
fi

# Apply iTerm2 preferences if they exist in the repo
if [[ -f "$SCRIPT_DIR/iterm2-preferences.plist" ]]; then
    echo "🔧 Applying iTerm2 preferences..."
    cp "$SCRIPT_DIR/iterm2-preferences.plist" ~/Library/Preferences/com.googlecode.iterm2.plist
    
    # Tell iTerm2 to load preferences from our location (if running)
    defaults write com.googlecode.iterm2 PrefsCustomFolder -string "$SCRIPT_DIR"
    defaults write com.googlecode.iterm2 LoadPrefsFromCustomFolder -bool true
fi

# ============================================================================
# DOCKER SETUP
# ============================================================================

echo "🐳 Setting up Docker..."

# Start Docker if it's not running (this will require manual intervention)
if ! docker info &> /dev/null; then
    echo "ℹ️ Docker is not running. Please start Docker Desktop manually after the script completes."
else
    echo "✅ Docker is running"
fi

# ============================================================================
# POST-INSTALLATION
# ============================================================================

echo ""
echo "🧹 Cleaning up..."
brew cleanup

echo ""
echo "🎉 MacBook Pro setup complete!"
echo "=============================="
echo ""
echo "📋 Installed components:"
echo "  🍺 Homebrew package manager"
echo "  🔧 Git + GitHub CLI (gh)"
echo "  ☁️ AWS CLI"
echo "  🌐 Google Cloud SDK"
echo "  📦 Node.js (via nodenv) + latest stable version"
echo "  🐳 Docker Desktop"
echo "  💻 Claude Code"
echo "  📺 iTerm2 (configured)"
echo "  🎯 Tuple"
echo "  💬 Slack"
echo "  📝 Neovim (fully configured)"
echo "  🔤 FiraCode Nerd Font"
echo "  🐚 Zsh + Oh My Zsh"
echo "  🔧 Language servers: Lua, TypeScript, Ruby, Python"
echo ""
echo "🔗 Symlinks created:"
echo "  • ~/.zshrc -> $SCRIPT_DIR/zshrc"
echo "  • ~/.config/nvim -> $SCRIPT_DIR/nvim"
echo ""
echo "📝 Configuration files saved:"
echo "  • iTerm2 preferences -> $SCRIPT_DIR/iterm2-preferences.plist"
echo ""
echo "⚠️  Post-setup actions required:"
echo "  1. Restart your terminal or run: source ~/.zshrc"
echo "  2. Open iTerm2 and set font to 'FiraCode Nerd Font' if not already set"
echo "  3. Start Docker Desktop if not already running"
echo "  4. Set up your Anthropic API key file if needed: ~/programming/anthropic_api_key"
echo "  5. Run 'nvim' to let lazy.nvim install plugins on first launch"
echo "  6. Configure GitHub CLI: gh auth login"
echo "  7. Configure AWS CLI: aws configure"
echo "  8. Configure Google Cloud: gcloud init"
echo ""
echo "✨ Your MacBook Pro is now ready for development!"