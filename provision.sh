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
    "rbenv"
    "ruby-build"
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
# RUBY SETUP WITH RBENV
# ============================================================================

echo "💎 Setting up Ruby with rbenv..."

# Initialize rbenv if not already done
if [[ ! -d "$HOME/.rbenv" ]]; then
    echo "🔧 Initializing rbenv..."
    rbenv init
fi

# Install latest stable Ruby
if ! command -v ruby &> /dev/null || [[ "$(ruby --version)" == *"2.6"* ]]; then
    echo "📥 Installing latest stable Ruby..."
    LATEST_RUBY=$(rbenv install -l | grep -E "^\s*[0-9]+\.[0-9]+\.[0-9]+$" | tail -1 | tr -d ' ')
    rbenv install "$LATEST_RUBY"
    rbenv global "$LATEST_RUBY"
    rbenv rehash
else
    echo "✅ Ruby already installed and up to date"
fi

# ============================================================================
# APPLICATIONS
# ============================================================================

echo "📱 Installing applications..."

# Install applications via Homebrew Cask
declare -a apps=(
    "iterm2"
    "docker"
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

# Install Claude Code via npm (official method)
echo "💻 Installing Claude Code..."
if ! command -v claude &> /dev/null; then
    echo "📥 Installing Claude Code via npm..."
    npm install -g @anthropic-ai/claude-code
else
    echo "✅ Claude Code already installed"
fi

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

# Language servers are now managed by mason.nvim (no manual installation needed)
echo "🔧 Language servers will be automatically installed by mason.nvim when you open nvim"

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

# Generate detailed summary
echo "📊 INSTALLATION SUMMARY"
echo "======================="
echo ""

# Check what was actually installed/configured
echo "🛠️  CORE DEVELOPMENT TOOLS:"
if command -v brew &> /dev/null; then echo "  ✅ Homebrew package manager"; fi
if command -v git &> /dev/null; then echo "  ✅ Git $(git --version | cut -d' ' -f3)"; fi
if command -v gh &> /dev/null; then echo "  ✅ GitHub CLI $(gh --version | head -1 | cut -d' ' -f3)"; fi
if command -v node &> /dev/null; then echo "  ✅ Node.js $(node --version) (via nodenv)"; fi
if command -v ruby &> /dev/null; then echo "  ✅ Ruby $(ruby --version | cut -d' ' -f2) (via rbenv)"; fi
if command -v aws &> /dev/null; then echo "  ✅ AWS CLI $(aws --version | cut -d' ' -f1 | cut -d'/' -f2)"; fi
if command -v gcloud &> /dev/null; then echo "  ✅ Google Cloud SDK $(gcloud --version | head -1 | cut -d' ' -f4)"; fi

echo ""
echo "📱 APPLICATIONS:"
if [[ -d "/Applications/iTerm.app" ]]; then echo "  ✅ iTerm2 (configured with custom preferences)"; fi
if [[ -d "/Applications/Docker.app" ]]; then echo "  ✅ Docker Desktop"; fi
if command -v claude &> /dev/null; then echo "  ✅ Claude Code ($(claude --version | head -1))"; fi
if [[ -d "/Applications/Tuple.app" ]]; then echo "  ✅ Tuple"; fi
if [[ -d "/Applications/Slack.app" ]]; then echo "  ✅ Slack"; fi

echo ""
echo "📝 DEVELOPMENT ENVIRONMENT:"
if command -v nvim &> /dev/null; then echo "  ✅ Neovim $(nvim --version | head -1 | cut -d' ' -f2)"; fi
if [[ -L ~/.config/nvim ]]; then echo "    ├── Symlinked to: $(readlink ~/.config/nvim)"; fi
echo "    ├── Mason.nvim (auto-installs language servers)"
echo "    ├── LSP support (Lua, TypeScript, Ruby, Python)"
echo "    ├── Tokyo Night colorscheme"
echo "    ├── Lualine status bar"
echo "    ├── GitHub Copilot + Chat"
echo "    ├── File tree explorer"
echo "    ├── Cross-platform clipboard"
echo "    └── Auto-pairs"

echo ""
echo "🐚 SHELL CONFIGURATION:"
if [[ "$SHELL" == *"zsh"* ]]; then echo "  ✅ Zsh (default shell)"; fi
if [[ -d ~/.oh-my-zsh ]]; then echo "  ✅ Oh My Zsh"; fi
if [[ -L ~/.zshrc ]]; then echo "  ✅ Custom .zshrc symlinked to: $(readlink ~/.zshrc)"; fi

echo ""
echo "🔤 FONTS:"
if fc-list | grep -i "firacode" &> /dev/null || system_profiler SPFontsDataType | grep -i "firacode" &> /dev/null 2>/dev/null; then
    echo "  ✅ FiraCode Nerd Font"
fi

echo ""
echo "🔗 SYMLINKS CREATED:"
if [[ -L ~/.zshrc ]]; then echo "  • ~/.zshrc -> $(readlink ~/.zshrc)"; fi
if [[ -L ~/.config/nvim ]]; then echo "  • ~/.config/nvim -> $(readlink ~/.config/nvim)"; fi

echo ""
echo "📝 CONFIGURATION FILES:"
if [[ -f "$SCRIPT_DIR/iterm2-preferences.plist" ]]; then echo "  • iTerm2 preferences -> $SCRIPT_DIR/iterm2-preferences.plist"; fi
if [[ -f "$SCRIPT_DIR/zshrc" ]]; then echo "  • Zsh configuration -> $SCRIPT_DIR/zshrc"; fi
if [[ -d "$SCRIPT_DIR/nvim" ]]; then echo "  • Neovim configuration -> $SCRIPT_DIR/nvim/"; fi

echo ""
echo "⚠️  POST-SETUP ACTIONS REQUIRED:"
echo "================================"
echo "1. 🔄 Restart your terminal or run: source ~/.zshrc"
echo "2. 📺 Open iTerm2 and verify font is 'FiraCode Nerd Font'"
echo "3. 🐳 Start Docker Desktop if not running"
echo "4. 🔑 Set up your API keys:"
echo "   • Create ~/programming/anthropic_api_key for Claude Code"
echo "5. 🔐 Configure your cloud tools:"
echo "   • GitHub CLI: gh auth login"
echo "   • AWS CLI: aws configure"
echo "   • Google Cloud: gcloud init"
echo "6. 📝 Run 'nvim' to let lazy.nvim install plugins on first launch"
echo ""
echo "✨ Your MacBook Pro is now ready for development!"
echo ""
echo "🚀 Quick test commands:"
echo "  • nvim --version"
echo "  • claude --help"
echo "  • node --version"
echo "  • git --version"
echo ""