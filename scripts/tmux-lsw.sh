#!/usr/bin/env bash

# 1. Check if tmux is actually running
if [[ -z "$TMUX" ]]; then
  echo "Error: must be inside tmux"
  exit 1
fi

# 2. Select from window list
tmux_format="#{window_index}|#{?window_active,*,}pwd:#{pane_current_path} cmd:#{pane_current_command} #{?#{==:#{window_panes},1},[1 pane],[#{window_panes} panes]}\
#{?window_zoomed_flag,(ZOOMED),}"

fzf_preview='echo {} | cut -d "|" -f2 | awk -F ":" "{print \$2}" | cut -d " " -f1 | xargs -r fzf-preview'
window=$(tmux list-windows -F "$tmux_format" 2>/dev/null | fzf --preview "$fzf_preview" --delimiter '|' --with-nth 2.. --exit-0 | cut -d '|' -f1)

# 3. Exit if the user cancelled fzf (variable is empty)
if [[ -z "windows" ]]; then
  exit 0
fi

tmux select-window -t "$window"
