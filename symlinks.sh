#!/bin/zsh

dots_dir=${0:A:h}

declare -A links

links=( 
  [config]="$HOME/.config"
  [root/zsh_aliases]="$HOME/.zsh_aliases"
  [root/mongoshrc.js]="$HOME/.mongoshrc.js"
  [root/zsh_env]="$HOME/.zsh_env"
  [root/zsh_input_opts]="$HOME/.zsh_input_opts"
  [root/zsh_opts]="$HOME/.zsh_opts"
  [root/zshrc]="$HOME/.zshrc"
  [sbt]="$HOME/.sbt"
  [ssh/config]="$HOME/.ssh/config"
  [zshfn]="$HOME/.zshfn" 
  [zsh]="$HOME/.zsh"
  [root/wezterm.sh]="$HOME/.wezterm.sh"
  [launchagents/brian.tracey.dotfiles-autoupdate.plist]="$HOME/Library/LaunchAgents/brian.tracey.dotfiles-autoupdate.plist"
)

for k v in ${(kv)links}; do
  if ! [ -d $(dirname $v) ]; then
    mkdir -p $(dirname $v)
  fi
  rm -rf "$v"
  ln -svw "$dots_dir/$k" "$v"
done
