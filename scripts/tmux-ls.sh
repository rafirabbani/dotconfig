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
  echo "tmux is not running.  starting tmux-sessionizer."
  tmux-sessionizer
  exit 0
fi

# 2. Select the session
# -F "#{session_name}" gives us clean output
session=$(tmux list-sessions -F "#{session_name} #{?session_attached,(active),}" 2>/dev/null | fzf --preview-window=hidden --exit-0 | cut -d ' ' -f1)

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
