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
if [[ -f "$HOME/programming/anthropic_api_key" ]]; then
    export ANTHROPIC_API_KEY=$(cat $HOME/programming/artium-anthropic-key)
fi

# Preferred editor
export EDITOR='nvim'

alias gpfwl='git push --force-with-lease'

claude-auth() {
  local dir="$HOME/.claude"
  local settings="$dir/settings.json"
  local name="${1:-default}"
  local target="$dir/${name}.settings.json"

  if [[ ! -f "$target" ]]; then
    echo "Error: $target not found" >&2
    echo "Available configs:" >&2
    ls "$dir"/*.settings.json 2>/dev/null | xargs -I{} basename {} .settings.json >&2
    return 1
  fi

  ln -sf "$target" "$settings"
  echo "Activated ${name} settings"
}

. "$HOME/.local/bin/env"

export GOOGLE_GENAI_USE_VERTEXAI=true 
export GOOGLE_CLOUD_PROJECT=innov-connector-720215328878 
export GOOGLE_CLOUD_LOCATION=us-central1

export PATH="$PATH:/Users/tmorgan/go/bin"

