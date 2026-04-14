#!/bin/bash

set -e

# Parse flags
SETUP_EMACS=false
for arg in "$@"; do
    case "$arg" in
        --emacs) SETUP_EMACS=true ;;
    esac
done

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

# Install tmux if not present
if ! command -v tmux &> /dev/null; then
    echo "🖥️  Installing tmux..."
    brew install tmux
else
    echo "✅ tmux already installed"
fi

if [[ "$SETUP_EMACS" == true ]]; then
    # Install Emacs if not present (for Doom Emacs)
    if ! command -v emacs &> /dev/null; then
        echo "📝 Installing Emacs..."
        brew install emacs
    else
        echo "✅ Emacs already installed"
    fi

    # Install Doom Emacs if not present
    if [[ ! -d ~/.config/emacs ]]; then
        echo "🔥 Installing Doom Emacs..."
        git clone --depth 1 https://github.com/doomemacs/doomemacs ~/.config/emacs
        ~/.config/emacs/bin/doom install
    else
        echo "✅ Doom Emacs already installed"
    fi
else
    echo "⏭️  Skipping Emacs setup (pass --emacs to include)"
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

# Install Prettier globally
if ! command -v prettier &> /dev/null; then
    echo "💅 Installing Prettier..."
    npm install -g prettier
else
    echo "✅ Prettier already installed"
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

# Backup existing tmux config if present
if [[ -f ~/.tmux.conf ]] && [[ ! -L ~/.tmux.conf ]]; then
    echo "📋 Backing up existing tmux config to ~/.tmux.conf.backup"
    mv ~/.tmux.conf ~/.tmux.conf.backup
fi

# Remove symlink if it exists
if [[ -L ~/.tmux.conf ]]; then
    echo "🔗 Removing existing tmux symlink"
    rm ~/.tmux.conf
fi

# Create symlink to this repo's tmux config
echo "🔗 Creating symlink from ~/.tmux.conf to $SCRIPT_DIR/tmux.conf"
ln -s "$SCRIPT_DIR/tmux.conf" ~/.tmux.conf

if [[ "$SETUP_EMACS" == true ]]; then
    # Backup existing doom config if present
    if [[ -d ~/.config/doom ]] && [[ ! -L ~/.config/doom ]]; then
        echo "📋 Backing up existing doom config to ~/.config/doom.backup"
        mv ~/.config/doom ~/.config/doom.backup
    fi

    # Remove symlink if it exists
    if [[ -L ~/.config/doom ]]; then
        echo "🔗 Removing existing doom symlink"
        rm ~/.config/doom
    fi

    # Create symlink to this repo's doom config
    echo "🔗 Creating symlink from ~/.config/doom to $SCRIPT_DIR/doom"
    ln -s "$SCRIPT_DIR/doom" ~/.config/doom
fi

# Setup Claude Code configuration
echo "🤖 Setting up Claude Code configuration..."
mkdir -p ~/.claude

# Backup and remove existing claude agents symlink if present
if [[ -L ~/.claude/agents ]]; then
    echo "🔗 Removing existing claude agents symlink"
    rm ~/.claude/agents
fi

# Backup and remove existing claude config symlink if present
if [[ -L ~/.claude/config ]]; then
    echo "🔗 Removing existing claude config symlink"
    rm ~/.claude/config
fi

# Create symlinks to this repo's claude config
echo "🔗 Creating symlink from ~/.claude/agents to $SCRIPT_DIR/claude/agents"
ln -s "$SCRIPT_DIR/claude/agents" ~/.claude/agents

echo "🔗 Creating symlink from ~/.claude/config to $SCRIPT_DIR/claude/config"
ln -s "$SCRIPT_DIR/claude/config" ~/.claude/config

# Symlink default claude settings
if [[ -L ~/.claude/default.settings.json ]]; then
    rm ~/.claude/default.settings.json
fi
echo "🔗 Creating symlink from ~/.claude/default.settings.json to $SCRIPT_DIR/claude/settings.json"
ln -s "$SCRIPT_DIR/claude/settings.json" ~/.claude/default.settings.json

# Bootstrap settings.json to default if not already a symlink
if [[ ! -L ~/.claude/settings.json ]]; then
    echo "🔗 Bootstrapping ~/.claude/settings.json -> default"
    ln -sf ~/.claude/default.settings.json ~/.claude/settings.json
fi

echo ""
echo "🎉 Setup complete!"
echo ""
echo "📋 Installed components:"
echo "  • Homebrew"
echo "  • Neovim"
echo "  • Emacs + Doom Emacs (if --emacs flag passed)"
echo "  • tmux"
echo "  • FiraCode Nerd Font (for icons)"
echo "  • Language servers:"
echo "    - lua-language-server (Lua)"
echo "    - typescript-language-server (TypeScript/JavaScript)"
echo "    - solargraph (Ruby/Rails)"
echo "    - pyright (Python)"
echo ""
echo "🔗 Symlinks created:"
echo "  • ~/.config/nvim -> $SCRIPT_DIR/nvim"
echo "  • ~/.config/doom -> $SCRIPT_DIR/doom (if --emacs flag passed)"
echo "  • ~/.tmux.conf -> $SCRIPT_DIR/tmux.conf"
echo "  • ~/.claude/agents -> $SCRIPT_DIR/claude/agents"
echo "  • ~/.claude/config -> $SCRIPT_DIR/claude/config"
echo "  • ~/.claude/default.settings.json -> $SCRIPT_DIR/claude/settings.json"
echo ""
echo "✨ Your development environment is ready!"