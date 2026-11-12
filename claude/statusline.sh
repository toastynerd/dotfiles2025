#!/usr/bin/env bash
# Claude Code status line. Claude pipes session JSON on stdin; first line of stdout is shown.
# Format: <model> │ <dir> │ <git branch>[*] │ <context tokens>/<window> (<n>%) │ 7d <n>%
input=$(cat)

model=$(jq -r '.model.display_name // "Claude"' <<<"$input")
cwd=$(jq -r '.workspace.current_dir // .cwd // empty' <<<"$input")
ctx=$(jq -r '.context_window.used_percentage // empty' <<<"$input")
used=$(jq -r '.context_window.total_input_tokens // empty' <<<"$input")
size=$(jq -r '.context_window.context_window_size // empty' <<<"$input")
week=$(jq -r '.rate_limits.seven_day.used_percentage // empty' <<<"$input")
week_reset=$(jq -r '.rate_limits.seven_day.resets_at // empty' <<<"$input")

dir="${cwd/#"$HOME"/\~}"

branch=""
if [[ -n "$cwd" ]] && git -C "$cwd" rev-parse --is-inside-work-tree &>/dev/null; then
  branch=$(git -C "$cwd" symbolic-ref --short HEAD 2>/dev/null || git -C "$cwd" rev-parse --short HEAD 2>/dev/null)
  [[ -n $(git -C "$cwd" status --porcelain 2>/dev/null | head -1) ]] && branch="${branch}*"
fi

out=$'\e[35m'"$model"$'\e[0m │ \e[34m'"$dir"$'\e[0m'
[[ -n "$branch" ]] && out+=$' │ \e[32m '"$branch"$'\e[0m'
# Tokens in the current context window, e.g. "85k/200k (42%)"
k() { awk -v n="$1" 'BEGIN { if (n >= 1000000) printf "%.1fM", n/1000000; else if (n >= 1000) printf "%dk", n/1000; else printf "%d", n }'; }
if [[ -n "$used" && -n "$size" ]]; then
  tok="$(k "$used")/$(k "$size")"
  [[ -n "$ctx" ]] && tok+=" (${ctx%.*}%)"
  out+=$' │ \e[33m'"$tok"$'\e[0m'
fi
# Weekly plan usage (only present for subscribers, after the first API response)
if [[ -n "$week" ]]; then
  wk="7d ${week%.*}%"
  [[ -n "$week_reset" ]] && wk+=" ↻$(date -r "$week_reset" +%a)"
  out+=$' │ \e[36m'"$wk"$'\e[0m'
fi
printf '%s\n' "$out"
