# Dotfiles 2025

Personal development environment configuration for macOS.

## Features

- **Neovim Configuration**: Modern nvim setup with LSP support
- **Language Support**: TypeScript, JavaScript, Ruby, Python, Lua
- **Syntax Highlighting**: Treesitter-powered highlighting
- **Colorscheme**: Tokyo Night theme
- **Automated Setup**: One-command installation script

## Quick Start

```bash
git clone https://github.com/toastynerd/dotfiles2025.git
cd dotfiles2025
./setup.sh
```

The setup script will:
- Install Homebrew (if needed)
- Install Neovim (if needed)
- Install language servers for multiple languages
- Create symlinks from `~/.config/nvim` to this repo
- Backup existing nvim config to `~/.config/nvim.backup`

## Language Servers Included

- **lua-language-server** - Lua
- **typescript-language-server** - TypeScript/JavaScript
- **solargraph** - Ruby/Rails
- **pyright** - Python

## Recommended Terminal

For best color support, use iTerm2 instead of macOS Terminal:
```bash
brew install --cask iterm2
```

## Structure

```
nvim/
├── config/
│   └── lazy.lua          # Lazy.nvim plugin manager setup
├── plugins/
│   ├── completion.lua    # Completion configuration
│   ├── lsp.lua          # Language server configuration
│   ├── syntax.lua       # Treesitter syntax highlighting
│   └── visual.lua       # Colorscheme and UI
└── init.lua             # Main nvim configuration
```

## Manual Installation

If you prefer to set up manually:

1. Install dependencies:
   ```bash
   brew install neovim lua-language-server typescript-language-server solargraph pyright
   ```

2. Create symlink:
   ```bash
   ln -s $(pwd)/nvim ~/.config/nvim
   ```

## Customization

- **Colorscheme**: Edit `nvim/plugins/visual.lua`
- **Language servers**: Edit `nvim/plugins/lsp.lua`
- **Keybindings**: Add to `nvim/init.lua`
- **Additional plugins**: Add to appropriate files in `nvim/plugins/`