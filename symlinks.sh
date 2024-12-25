#!/bin/zsh

dots_dir=${0:A:h}

declare -A links

links=( 
  [config]="$HOME/.config"
  [root/aliases]="$HOME/.aliases"
  [root/fzf.zsh]="$HOME/.fzf.zsh"
  [root/mongoshrc.js]="$HOME/.mongoshrc.js"
  [root/personalrc]="$HOME/.personalrc"
  [root/zsh_input_opts]="$HOME/.zsh_input_opts"
  [root/zsh_opts]="$HOME/.zsh_opts"
  [root/zshrc]="$HOME/.zshrc"
  [sbt/1.0/config.sbt]="$HOME/.sbt/1.0/config.sbt"
  [sbt/1.0/global.sbt]="$HOME/.sbt/1.0/global.sbt"
  [ssh/config]="$HOME/.ssh/config"
  [zshfn]="$HOME/.zshfn" 
  [zsh]="$HOME/.zsh"
  [wezterm.sh]="$HOME/.wezterm.sh"
  [launchagents/brian.tracey.dotfiles-autoupdate.plist]="$HOME/Library/LaunchAgents/brian.tracey.dotfiles-autoupdate.plist"
)

for k v in ${(kv)links}; do
  if ! [ -d $(dirname $v) ]; then
    mkdir -p $(dirname $v)
  fi
  rm -rf "$v"
  ln -svw "$dots_dir/$k" "$v"
done
