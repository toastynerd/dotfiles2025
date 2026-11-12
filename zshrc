# Path to your Oh My Zsh installation.
export ZSH="$HOME/.oh-my-zsh"

# Set theme
ZSH_THEME="robbyrussell"

# Plugins
plugins=(git)

source $ZSH/oh-my-zsh.sh

# add nodenv to path before homebrew
export PATH="$HOME/.nodenv/shims:$PATH"

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
# Disabled 2026-11-09: Claude Code signs in with `claude login` (a Claude account), not an API key.
# Uncomment to re-enable.
# if [[ -f "$HOME/programming/artium-anthropic-key" ]]; then
#     export ANTHROPIC_API_KEY=$(cat "$HOME/programming/artium-anthropic-key")
# fi

# Preferred editor
export EDITOR='nvim'

alias gpfwl='git push --force-with-lease'

clauded() {
  claude --dangerously-skip-permissions "$@"
}

. "$HOME/.local/bin/env"

export GOOGLE_GENAI_USE_VERTEXAI=true 
export GOOGLE_CLOUD_PROJECT=innov-connector-720215328878 
export GOOGLE_CLOUD_LOCATION=us-central1

export PATH="$PATH:/Users/tmorgan/go/bin"

