#!/usr/bin/env bash
# Compose text in nvim in a side-by-side split, then paste it into the originating pane.
# Bound in tmux.conf as: bind g run-shell -b "tmux-claude-edit '#{pane_id}'"
# Unlike Claude's ctrl+g, the target pane stays visible while you edit.
target="$1"
[ -n "$target" ] || exit 1

tmp=$(mktemp --suffix=.md) || exit 1
trap 'rm -f "$tmp"' EXIT
dir=$(tmux display-message -p -t "$target" '#{pane_current_path}')

pane=$(tmux split-window -h -c "$dir" -P -F '#{pane_id}' "nvim $(printf %q "$tmp")") || exit 1
while tmux list-panes -a -F '#{pane_id}' | grep -qx "$pane"; do
  sleep 0.2
done

tmux select-pane -t "$target"
if [ -s "$tmp" ]; then
  # Strip trailing newlines so the paste doesn't submit; user presses Enter.
  printf %s "$(cat "$tmp")" | tmux load-buffer -b claude-edit -
  tmux paste-buffer -p -d -b claude-edit -t "$target"
fi
