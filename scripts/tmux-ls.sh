#!/usr/bin/env bash

# 1. Check if tmux is actually running
is_tmux_running() {
  tmux_running=$(pgrep tmux)

  if [[ -z $TMUX ]] && [[ -z $tmux_running ]]; then
    return 1
  fi
  return 0
}

if ! is_tmux_running; then
  echo "tmux is not running.  please start tmux-sessionizer."
  exit 1
fi

fzf_default_opts="--ansi --height 70% --tmux 90% --border --padding 1,2 --reverse --preview-window 'hidden'"
export FZF_DEFAULT_OPTS="$fzf_default_opts"

# Use the $'' syntax to ensure these are actual escape codes
GREEN=$'\033[32m'
YELLOW=$'\033[33m'
CYAN=$'\033[36m'
RESET=$'\033[0m'

# The format string
format="${CYAN}#{?session_attached,*, }${RESET}${GREEN}#{session_name}${RESET} ${YELLOW}#{s|$HOME|~|:pane_current_path}${RESET}"

# pipe into fzf.
# We use awk '{print $2}' because field 1 is the * symbol.
session=$(tmux list-sessions -F "$format" 2>/dev/null | fzf --exit-0 | awk '{print $1}')

# 3. Exit if the user cancelled fzf (variable is empty)
if [[ -z "$session" ]]; then
  exit 0
fi

# 4. Handle context (Inside vs Outside Tmux)
if [[ -n "$TMUX" ]]; then
  # If already inside a tmux session, switch to the new one
  tmux switch-client -t "$session"
else
  # If outside, attach to it
  tmux attach-session -t "$session"
fi
