#!/usr/bin/env bash
# Editor wrapper for Claude Code (ctrl+g). Used as EDITOR/VISUAL via ~/.claude/settings.json.
# Inside tmux: edit in a side-by-side split that closes when the editor exits.
# Outside tmux: edit in the current terminal (fallback).
file="$1"
[ -n "$file" ] || exit 1

if [ -n "$TMUX" ]; then
  pane=$(tmux split-window -h -c "$PWD" -P -F '#{pane_id}' "nvim $(printf %q "$file")") || exit 1
  # Block until the split pane is gone so Claude reads the file after the edit.
  while tmux list-panes -a -F '#{pane_id}' | grep -qx "$pane"; do
    sleep 0.2
  done
else
  exec nvim "$file"
fi
