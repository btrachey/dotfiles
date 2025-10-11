#!/bin/bash

branch=${1:-""}

# if no branch name given, fzf over all branches
if [ -z "$branch" ]; then
  selected_branch="$(git branch --all | fzf | tr -d '[:space:]')"
  if [ -z "$selected_branch" ]; then
    exit 0
  fi
  if [[ "$selected_branch" =~ "remotes/origin/" ]]; then
    git switch "${selected_branch//remotes\/origin\//}"
  else
    git switch "$selected_branch"
  fi
else
  # if given branch name matches a local or remote branch, immediately switch to it
  if git show-ref --quiet refs/heads/"$branch" || git show-ref --quiet remotes/origin/"$branch"; then
    git switch "$branch"
  # if given branch name matches a branch via fzf, select it there
  elif git branch --all | fzf -f "$branch" &> /dev/null; then
    selected_branch="$(git branch --all | fzf -q "$branch" -1 | tr -d '[:space:]')"
    if [ -z "$selected_branch" ]; then
      exit 0
    fi
    if [[ "$selected_branch" =~ "remotes/origin/" ]]; then
      git switch "${selected_branch//remotes\/origin\//}"
    else
      git switch "$selected_branch"
    fi
  # none of the other conditions match, this is a brand new branch
  else
    # branch name must be no more than 37 characters long
    if [ ${#branch} -gt 37 ]; then
      over_by=$((${#branch} - 37))
      echo "branch name is too long by $over_by characters"
    # branch name cannot contain underscores
    elif [[ $branch =~ "_" ]]; then
      echo "branch name cannot contain underscores"
    else
      git switch -c "$branch"
    fi
  fi
fi
