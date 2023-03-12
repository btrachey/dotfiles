#! /bin/bash

echo_color() {
  # first arg is color name
  # second arg is the string to color
  CLEAR='\033[0m'
  COLOR="$CLEAR"
  if [ "$1" = "green" ]; then
    COLOR='\033[0;32m'
  elif [ "$1" = "red" ]; then
    COLOR='\033[0;31m'
  fi
  echo -e "$COLOR$2$CLEAR"
}

git push --set-upstream origin "$(git rev-parse --abbrev-ref HEAD)" 2>&1 | tee /tmp/git_push_output.txt

GIT_PUSH_URL="$(grep 'remote:' /tmp/git_push_output.txt | grep 'http.*merge_req' | cut -d ':' -f2- | sed -r 's/[[:space:]]*//g')"
if [ -n "$GIT_PUSH_URL" ]; then 
  echo_color green "Open MR URL?"
  read -rp 'y/n > ' OPEN
  if [ "$OPEN" == "y" ]; then
    open "$GIT_PUSH_URL"
  fi
fi
rm /tmp/git_push_output.txt

