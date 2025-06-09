#!/bin/bash

set -e

echo "🚀 Setting up development environment..."

# Check if we're on macOS
if [[ "$OSTYPE" != "darwin"* ]]; then
    echo "❌ This script is designed for macOS only"
    exit 1
fi

# Install Homebrew if not present
if ! command -v brew &> /dev/null; then
    echo "📦 Installing Homebrew..."
    /bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"
    eval "$(/opt/homebrew/bin/brew shellenv)"
else
    echo "✅ Homebrew already installed"
fi

# Install Neovim if not present
if ! command -v nvim &> /dev/null; then
    echo "📝 Installing Neovim..."
    brew install neovim
else
    echo "✅ Neovim already installed"
fi

# Install Nerd Font for icons
echo "🔤 Installing Nerd Font for icons..."
if ! brew list --cask font-fira-code-nerd-font &> /dev/null; then
    echo "📥 Installing FiraCode Nerd Font..."
    brew install --cask font-fira-code-nerd-font
else
    echo "✅ FiraCode Nerd Font already installed"
fi

# Install Node.js if not present (required for Copilot)
if ! command -v node &> /dev/null; then
    echo "📦 Installing Node.js..."
    brew install node
else
    echo "✅ Node.js already installed"
fi

# Install language servers
echo "🔧 Installing language servers..."

declare -a servers=(
    "lua-language-server"
    "typescript-language-server" 
    "solargraph"
    "pyright"
)

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
SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
echo "🔗 Creating symlink from ~/.config/nvim to $SCRIPT_DIR/nvim"
ln -s "$SCRIPT_DIR/nvim" ~/.config/nvim

echo ""
echo "🎉 Setup complete!"
echo ""
echo "📋 Installed components:"
echo "  • Homebrew"
echo "  • Neovim"
echo "  • FiraCode Nerd Font (for icons)"
echo "  • Language servers:"
echo "    - lua-language-server (Lua)"
echo "    - typescript-language-server (TypeScript/JavaScript)"
echo "    - solargraph (Ruby/Rails)"
echo "    - pyright (Python)"
echo ""
echo "🔗 Symlinks created:"
echo "  • ~/.config/nvim -> $SCRIPT_DIR/nvim"
echo ""
echo "✨ Your development environment is ready!"