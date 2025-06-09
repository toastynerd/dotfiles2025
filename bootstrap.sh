#!/bin/bash

set -e

echo "MacBook Bootstrap Script"
echo "========================"
echo ""
echo "This script will download and run the complete MacBook provisioner"
echo "from GitHub without requiring any pre-installed tools."
echo ""

# Check if we're on macOS
if [[ "$OSTYPE" != "darwin"* ]]; then
    echo "ERROR: This script is designed for macOS only"
    exit 1
fi

# Prompt for confirmation
read -p "Do you want to proceed with setting up your MacBook? (y/N): " -n 1 -r
echo
if [[ ! $REPLY =~ ^[Yy]$ ]]; then
    echo "Setup cancelled"
    exit 1
fi

echo ""
echo "Starting MacBook setup..."

# Create a temporary directory
TEMP_DIR=$(mktemp -d)
echo "Using temporary directory: $TEMP_DIR"

# Change to temp directory
cd "$TEMP_DIR"

# Download the repository as a ZIP file (no git required)
echo "Downloading dotfiles repository..."
curl -L -o dotfiles.zip https://github.com/toastynerd/dotfiles2025/archive/refs/heads/master.zip

# Extract the ZIP file (no unzip dependency on macOS)
echo "Extracting files..."
ditto -xk dotfiles.zip .

# Find the extracted directory (it will be named dotfiles2025-master)
REPO_DIR="$TEMP_DIR/dotfiles2025-master"

if [[ ! -d "$REPO_DIR" ]]; then
    echo "ERROR: Failed to extract repository"
    exit 1
fi

# Make the provision script executable
chmod +x "$REPO_DIR/provision.sh"

echo ""
echo "Repository downloaded and extracted"
echo "Running provisioner..."
echo ""

# Run the provision script
cd "$REPO_DIR"
./provision.sh

# Ask if user wants to keep the files or move them to a permanent location
echo ""
echo "Setup complete! What would you like to do with the dotfiles?"
echo "1) Move them to ~/dotfiles2025 (recommended)"
echo "2) Move them to a custom location"
echo "3) Leave them in temporary directory (will be deleted on reboot)"
echo ""
read -p "Choose an option (1-3): " -n 1 -r
echo

case $REPLY in
    1)
        FINAL_DIR="$HOME/dotfiles2025"
        if [[ -d "$FINAL_DIR" ]]; then
            echo "Backing up existing dotfiles to ~/dotfiles2025.backup"
            mv "$FINAL_DIR" "$HOME/dotfiles2025.backup"
        fi
        echo "Moving dotfiles to $FINAL_DIR"
        mv "$REPO_DIR" "$FINAL_DIR"
        
        # Update symlinks to point to the new location
        echo "Updating symlinks..."
        rm -f ~/.zshrc ~/.config/nvim
        ln -s "$FINAL_DIR/zshrc" ~/.zshrc
        ln -s "$FINAL_DIR/nvim" ~/.config/nvim
        
        echo "SUCCESS: Dotfiles moved to $FINAL_DIR"
        ;;
    2)
        read -p "Enter the full path where you want to store dotfiles: " FINAL_DIR
        if [[ -d "$FINAL_DIR" ]]; then
            echo "ERROR: Directory already exists: $FINAL_DIR"
            echo "INFO: Dotfiles remain in temporary directory: $REPO_DIR"
        else
            echo "Moving dotfiles to $FINAL_DIR"
            mv "$REPO_DIR" "$FINAL_DIR"
            
            # Update symlinks to point to the new location
            echo "Updating symlinks..."
            rm -f ~/.zshrc ~/.config/nvim
            ln -s "$FINAL_DIR/zshrc" ~/.zshrc
            ln -s "$FINAL_DIR/nvim" ~/.config/nvim
            
            echo "SUCCESS: Dotfiles moved to $FINAL_DIR"
        fi
        ;;
    3)
        echo "INFO: Dotfiles remain in temporary directory: $REPO_DIR"
        echo "WARNING: This directory will be deleted when you reboot"
        ;;
    *)
        echo "ERROR: Invalid option. Dotfiles remain in temporary directory: $REPO_DIR"
        ;;
esac

# Clean up the temporary files (but not the repo if it wasn't moved)
echo ""
echo "Cleaning up temporary files..."
cd /
rm -f "$TEMP_DIR/dotfiles.zip"

echo ""
echo "Bootstrap complete!"
echo "=================="
echo ""
echo "Important next steps:"
echo "  1. Restart your terminal or run: source ~/.zshrc"
echo "  2. Open iTerm2 and verify the font is set to 'FiraCode Nerd Font'"
echo "  3. Start Docker Desktop if not already running"
echo "  4. Configure your tools:"
echo "     - GitHub CLI: gh auth login"
echo "     - AWS CLI: aws configure"
echo "     - Google Cloud: gcloud init"
echo "  5. Set up your API keys in ~/programming/anthropic_api_key if needed"
echo "  6. Run 'nvim' to let lazy.nvim install plugins"
echo ""
echo "SUCCESS: Your MacBook is now ready for development!"