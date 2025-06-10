# Dotfiles 2025

Personal development environment configuration for macOS.

## Features

- **Neovim Configuration**: Modern nvim setup with LSP support
- **Language Support**: TypeScript, JavaScript, Ruby, Python, Lua
- **Syntax Highlighting**: Treesitter-powered highlighting
- **Colorscheme**: Tokyo Night theme with proper 24-bit color support
- **Status Line**: Lualine with git branch, file path, and diff indicators
- **GitHub Copilot**: AI-powered code completion (Ctrl+J to accept)
- **Copilot Chat**: AI assistant for code explanation and optimization
- **Auto-pairs**: Automatic bracket and quote completion
- **File Tree**: nvim-tree explorer with git status indicators
- **Cross-platform Clipboard**: Copy to system clipboard from visual mode
- **Nerd Font**: FiraCode Nerd Font for proper icon display
- **Automated Setup**: One-command installation script

## Quick Start

### Option 1: Fresh MacBook (No Tools Installed)
Run this single command in Terminal on a brand new Mac:

```bash
curl -fsSL https://raw.githubusercontent.com/toastynerd/dotfiles2025/master/bootstrap.sh | bash
```

### Option 2: If You Already Have Git
```bash
git clone https://github.com/toastynerd/dotfiles2025.git
cd dotfiles2025
./provision.sh
```

Both methods will:
- Install Homebrew (if needed)
- Install Neovim (if needed)
- Install Node.js (required for Copilot)
- Install language servers for multiple languages
- Install FiraCode Nerd Font for proper icon display
- Create symlinks from `~/.config/nvim` to this repo
- Backup existing nvim config to `~/.config/nvim.backup`

## Language Servers (Auto-Installed by Mason)

Mason.nvim automatically installs and manages language servers when you open files:

- **lua_ls** - Lua (with Neovim configuration)
- **tsserver** - TypeScript/JavaScript
- **solargraph** - Ruby/Rails
- **pyright** - Python

No manual installation required! Just open a file and Mason handles the rest.

## Recommended Terminal Setup

For best experience:

1. **Use iTerm2** for proper 24-bit color support (macOS Terminal has poor color handling):
   ```bash
   brew install --cask iterm2
   ```

2. **Set Font in iTerm2**: Go to iTerm2 → Preferences → Profiles → Text → Font and select "FiraCode Nerd Font"

## Key Bindings

### File Management
- **`Space + e`** - Toggle file tree
- **`Space + f`** - Find current file in tree

### AI Assistance
- **`Ctrl + J`** - Accept Copilot suggestion (insert mode)
- **`Space + cc`** - Open Copilot Chat
- **`Space + ce`** - Explain selected code (visual mode)
- **`Space + cf`** - Fix selected code (visual mode)
- **`Space + co`** - Optimize selected code (visual mode)

### Clipboard
- **`Space + z`** - Copy visual selection to system clipboard

### LSP (Language Server Protocol)
- **`gd`** - Go to definition
- **`K`** - Show hover documentation
- **`Space + rn`** - Rename symbol
- **`Space + ca`** - Code actions
- **`gr`** - Find references

## Structure

```
nvim/
├── config/
│   └── lazy.lua          # Lazy.nvim plugin manager setup
├── plugins/
│   ├── completion.lua    # GitHub Copilot + Copilot Chat + auto-pairs + clipboard
│   ├── lsp.lua          # Mason + LSP configuration with auto-installation
│   ├── syntax.lua       # Treesitter syntax highlighting
│   └── visual.lua       # Tokyo Night colorscheme + Lualine status bar + file tree
└── init.lua             # Main nvim configuration + clipboard settings
```

## Manual Installation

If you prefer to set up manually:

1. Install dependencies:
   ```bash
   brew install neovim node
   brew install --cask font-fira-code-nerd-font
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