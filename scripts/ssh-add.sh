#!/usr/bin/env bash
echo "$SSH_AUTH_SOCK"

if [ -n "$TMUX" ]; then
  echo "Inside tmux session"
  if [ -z "$SSH_AUTH_SOCK" ]; then
    eval $(ssh-agent -s) && ssh-add ~/.ssh/id_ecdsa
    ssh-add ~/.ssh/id_rsa_github
  fi
fi
