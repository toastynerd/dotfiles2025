# Dotfiles 2025

Personal development environment configuration for macOS with both **Neovim** and **Doom Emacs** setups.

## Features

### Core Editors
- **🚀 Neovim Configuration**: Modern nvim setup with LSP support
- **🔥 Doom Emacs Configuration**: Comprehensive Emacs setup with Evil mode (Vim bindings)

### Language Support
- **TypeScript/JavaScript**: Full LSP, formatting (Prettier), refactoring, NPM integration
- **Python**: LSP with Pyright, Black formatting, Poetry/Pipenv support, auto-imports
- **Ruby/Rails**: Complete LSP support with Solargraph
- **Lua**: LSP optimized for Neovim development

### Development Features
- **🎨 Tokyo Night Theme**: Consistent across both editors
- **🤖 GitHub Copilot**: AI-powered code completion in both editors
- **🌳 Syntax Highlighting**: Tree-sitter enhanced parsing
- **📁 File Management**: File trees with git status indicators
- **🔧 LSP Integration**: IntelliSense, go-to-definition, refactoring
- **✨ Code Formatting**: Automatic formatting with Prettier, Black, etc.
- **📦 Dependency Management**: Poetry, Pipenv, NPM integration
- **🎯 Cross-platform Clipboard**: Works over SSH and various terminals
- **🔤 Nerd Font**: FiraCode for proper icon display

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

Both methods will install:
- **Homebrew** (package manager for macOS)
- **Neovim** with complete configuration
- **Emacs + Doom Emacs** with enhanced setup
- **Node.js** (required for Copilot and language servers)
- **Language servers** for TypeScript, Python, Ruby, Lua
- **FiraCode Nerd Font** for proper icon display

And create symlinks:
- `~/.config/nvim` → `./nvim` (Neovim config)
- `~/.config/doom` → `./doom` (Doom Emacs config)
- `~/.tmux.conf` → `./tmux.conf` (tmux config)

Existing configs are backed up automatically.

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

### Neovim Key Bindings

#### File Management
- **`Space + e`** - Toggle file tree
- **`Space + f`** - Find current file in tree

#### AI Assistance
- **`Ctrl + J`** - Accept Copilot suggestion (insert mode)
- **`Space + cc`** - Open Copilot Chat
- **`Space + ce`** - Explain selected code (visual mode)
- **`Space + cf`** - Fix selected code (visual mode)
- **`Space + co`** - Optimize selected code (visual mode)

#### Clipboard
- **`Space + z`** - Copy visual selection to system clipboard

#### LSP (Language Server Protocol)
- **`gd`** - Go to definition
- **`K`** - Show hover documentation
- **`Space + rn`** - Rename symbol
- **`Space + ca`** - Code actions
- **`gr`** - Find references

### Doom Emacs Key Bindings

#### File Management
- **`SPC e e`** - Toggle Treemacs file tree
- **`SPC f f`** - Find files
- **`SPC p p`** - Switch projects

#### AI Assistance (Copilot)
- **`TAB`** - Accept Copilot completion
- **`C-TAB`** - Accept Copilot by word

#### Language-Specific (Local Leader `SPC m`)
**Python:**
- **`SPC m f`** - Format with Black
- **`SPC m i`** - Fix imports
- **`SPC m r`** - Send to Python shell

**JavaScript/TypeScript:**
- **`SPC m f`** - Format with Prettier
- **`SPC m r`** - Refactoring menu
- **`SPC m n`** - NPM commands

#### Git Integration
- **`SPC g s`** - Magit status
- **`SPC g b`** - Git blame
- **`SPC g t`** - Git timemachine

#### General
- **`SPC z`** - Copy to system clipboard (visual mode)
- **`SPC h d h`** - Doom documentation

## Project Structure

```
/
├── nvim/                      # Neovim Configuration
│   ├── config/
│   │   └── lazy.lua          # Lazy.nvim plugin manager setup
│   ├── plugins/
│   │   ├── completion.lua    # GitHub Copilot + Copilot Chat + auto-pairs + clipboard
│   │   ├── lsp.lua          # Mason + LSP configuration with auto-installation
│   │   ├── syntax.lua       # Treesitter syntax highlighting
│   │   └── visual.lua       # Tokyo Night colorscheme + Lualine status bar + file tree
│   └── init.lua             # Main nvim configuration + clipboard settings
│
├── doom/                      # Doom Emacs Configuration
│   ├── init.el              # Doom modules configuration (languages, tools, UI)
│   ├── config.el            # Personal customizations and keybindings
│   └── packages.el          # Additional packages (Copilot, language tools)
│
├── tmux.conf                  # Tmux configuration with Vim bindings
├── setup.sh                  # Automated installation script
└── README.md                 # This file
```

## Configuration Features

### Doom Emacs Specific Features
- **Evil Mode**: Full Vim keybindings with Emacs power
- **LSP Integration**: Comprehensive language server support
- **GitHub Copilot**: Native AI code completion
- **Dependency Management**:
  - Python: Poetry, Pipenv, Conda support
  - JavaScript: NPM integration with local node_modules
- **Code Formatting**: Black (Python), Prettier (JS/TS), Apheleia framework
- **Git Integration**: Magit (the best Git interface ever made)
- **Project Management**: Projectile with workspace support
- **File Management**: Treemacs with git status indicators

## Manual Installation

If you prefer to set up manually:

1. **Install dependencies:**
   ```bash
   brew install neovim emacs node
   brew install --cask font-fira-code-nerd-font
   ```

2. **Install Doom Emacs:**
   ```bash
   git clone --depth 1 https://github.com/doomemacs/doomemacs ~/.config/emacs
   ~/.config/emacs/bin/doom install
   ```

3. **Create symlinks:**
   ```bash
   ln -s $(pwd)/nvim ~/.config/nvim
   ln -s $(pwd)/doom ~/.config/doom
   ln -s $(pwd)/tmux.conf ~/.tmux.conf
   ```

4. **Sync Doom configuration:**
   ```bash
   ~/.config/emacs/bin/doom sync
   ```

## Getting Started

### Choose Your Editor

**For Vim Users:** Start with Neovim - familiar bindings with modern features
```bash
nvim your-file.py
```

**For Emacs Users or Advanced Vim Users:** Try Doom Emacs for the ultimate power
```bash
emacs your-file.py
# or
~/.config/emacs/bin/doom run
```

### First Steps with Doom Emacs
1. **Open Doom:** Run `emacs` or `~/.config/emacs/bin/doom run`
2. **Get Help:** Press `SPC h d h` for comprehensive documentation
3. **File Tree:** Press `SPC e e` to toggle the file explorer
4. **Find Files:** Press `SPC f f` to quickly open files
5. **Git Status:** Press `SPC g s` to see git status with Magit

## Customization

### Neovim
- **Colorscheme**: Edit `nvim/plugins/visual.lua`
- **Language servers**: Edit `nvim/plugins/lsp.lua`
- **Keybindings**: Add to `nvim/init.lua`
- **Additional plugins**: Add to appropriate files in `nvim/plugins/`

### Doom Emacs
- **Enable/Disable Modules**: Edit `doom/init.el`
- **Personal Configuration**: Edit `doom/config.el`
- **Additional Packages**: Add to `doom/packages.el`
- **After Changes**: Run `~/.config/emacs/bin/doom sync`

## Why Two Editors?

This setup provides both editors because:
- **Neovim**: Fast, lightweight, great for quick edits and terminal workflows
- **Doom Emacs**: Powerful IDE-like experience with superior git integration, org-mode, and extensibility
- **Shared Features**: Both have Copilot, LSP, Tree-sitter, and consistent Tokyo Night theming
- **Smooth Transition**: Evil mode in Doom Emacs provides familiar Vim bindings

Pick the tool that fits your current task - or use both! 🚀