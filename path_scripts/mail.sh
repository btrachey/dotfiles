#!/bin/bash

# if no branch name given, fzf over all branches
selected_acct="$(printf "brianwtracey@gmail.com\nbrian@brianwtracey.com\nbrian@grenadilla-studios.com\nbwt@engineering.upenn.edu" | fzf | tr -d '[:space:]')"
if [ -z "$selected_acct" ]; then
  exit 0
fi
himalaya-tui "$selected_acct"
