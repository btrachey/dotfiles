#!/bin/bash

git reset --soft head~1
git stash
git pull
git stash pop
git add .
git commit --reuse-message=HEAD@{1}
