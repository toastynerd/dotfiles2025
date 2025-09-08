# Path to your Oh My Zsh installation.
export ZSH="$HOME/.oh-my-zsh"

# Set theme
ZSH_THEME="robbyrussell"

# Plugins
plugins=(git)

source $ZSH/oh-my-zsh.sh

# Homebrew path
eval "$(/opt/homebrew/bin/brew shellenv)"

# Google Cloud SDK setup
if [[ -f "$(brew --prefix)/share/google-cloud-sdk/path.zsh.inc" ]]; then
    source "$(brew --prefix)/share/google-cloud-sdk/path.zsh.inc"
fi
if [[ -f "$(brew --prefix)/share/google-cloud-sdk/completion.zsh.inc" ]]; then
    source "$(brew --prefix)/share/google-cloud-sdk/completion.zsh.inc"
fi

# API Keys (customize as needed)
if [[ -f "$HOME/programming/anthropic_api_key" ]]; then
    export ANTHROPIC_API_KEY=$(cat $HOME/programming/artium-anthropic-key)
fi

# Preferred editor
export EDITOR='nvim'


alias gpfwl='git push --force-with-lease'

export PATH="$HOME/.asdf/shims:$PATH"
