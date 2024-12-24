#! /bin/zsh

cd ${0:A:h}
# check if need to pull; this is very naive, should probably make it better
LOCAl=$(git rev-parse @)
REMOTE=$(git rev-parse @{u})
BASE=$(git merge-base @ @{u})
if [ $LOCAl != $REMOTE ] && [ $LOCAl = $BASE ] then
  git stash
  git pull
  git stash pop
fi
brew bundle dump --force --file "${0:A:h}/Brewfile"
git submodule update --remote
git add -A
git commit -m "backup commit from $(hostname)"
git push
source ~/.zshrc
notifySlack "weekly backup of dotfiles complete"
