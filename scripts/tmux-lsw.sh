#!/usr/bin/env bash

# 1. Check if tmux is actually running
if [[ -z "$TMUX" ]]; then
  echo "Error: must be inside tmux"
  exit 1
fi

fzf_default_opts="--ansi --height 70% --tmux 90% --border --padding 1,2 --reverse \
  --bind '?:toggle-preview' \
  --bind 'alt-k:preview-half-page-up' \
  --bind 'alt-j:preview-half-page-down' \
  --preview-window 'right:40%:wrap' \
  --bind 'alt-w:toggle-preview-wrap'"
export FZF_DEFAULT_OPTS="$fzf_default_opts"
YELLOW=$'\033[33m'
RESET=$'\033[0m'
CYAN=$'\033[36m'

# 2. Select from window list
tmux_format="#{window_index}|${CYAN}#{?window_active,*,}${RESET}:${YELLOW}#{s|$HOME|~|:pane_current_path}${RESET} #{pane_current_command} #{?#{==:#{window_panes},1},[1 pane],[#{window_panes} panes]}\
#{?window_zoomed_flag,(ZOOMED),}"

fzf_preview='echo {} | cut -d "|" -f2 | awk -F ":" "{print \$2}" | cut -d " " -f1 | xargs -r fzf-preview'
window=$(tmux list-windows -F "$tmux_format" 2>/dev/null | fzf --preview "$fzf_preview" | cut -d '|' -f1)

# 3. Exit if the user cancelled fzf (variable is empty)
if [[ -z "windows" ]]; then
  exit 0
fi

tmux select-window -t "$window"
