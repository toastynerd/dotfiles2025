# Path to your Oh My Zsh installation.
export ZSH="$HOME/.oh-my-zsh"

# Set theme
ZSH_THEME="robbyrussell"

# Plugins
plugins=(git)

source $ZSH/oh-my-zsh.sh

# Nodenv setup
eval export PATH="/Users/$USER/.nodenv/shims:${PATH}"
export NODENV_SHELL=zsh
if command -v nodenv > /dev/null; then
    source "$(brew --prefix nodenv)/completions/nodenv.zsh"
    command nodenv rehash 2>/dev/null
    nodenv() {
      local command
      command="${1:-}"
      if [ "$#" -gt 0 ]; then
        shift
      fi

      case "$command" in
      rehash|shell)
        eval "$(nodenv "sh-$command" "$@")";;
      *)
        command nodenv "$command" "$@";;
      esac
    }
fi

# Google Cloud SDK setup
if [[ -f "$(brew --prefix)/share/google-cloud-sdk/path.zsh.inc" ]]; then
    source "$(brew --prefix)/share/google-cloud-sdk/path.zsh.inc"
fi
if [[ -f "$(brew --prefix)/share/google-cloud-sdk/completion.zsh.inc" ]]; then
    source "$(brew --prefix)/share/google-cloud-sdk/completion.zsh.inc"
fi

# API Keys (customize as needed)
if [[ -f "$HOME/programming/anthropic_api_key" ]]; then
    export ANTHROPIC_API_KEY=$(cat $HOME/programming/anthropic_api_key)
fi

# Preferred editor
export EDITOR='nvim'

# Homebrew path
eval "$(/opt/homebrew/bin/brew shellenv)"