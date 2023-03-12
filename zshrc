# start ZSH profiler
#zmodload zsh/zprof
# ZSH options
source "$HOME"/.zsh_opts
# ZSH input options
source "$HOME"/.zsh_input_opts
# aliases
source "$HOME"/.aliases

# source personal things
source "$HOME"/.personalrc

# pyenv setup
export PYENV_ROOT="$HOME/.pyenv"

# add other executables to path
path=( "$HOME/protenus/workspace/my-scripts/"
       "$PYENV_ROOT/bin"
       "$HOME/protenus/workspace/pythongmailapi"
       "$HOME/Library/Application Support/Coursier/bin"
       "$HOME/protenus/workspace/dotfiles/path_scripts"
       "$HOME/protenus/workspace/toolbox-installer"
       "/usr/local/opt/mongodb-community@4.2/bin"
       "/opt/homebrew/opt/mongodb-community@4.2/bin"
       "$HOME/.cargo/bin" # Rust
       "${path[@]}" )

# add custom functions from fpath
fpath=( "$HOME/.zshfn"
        "/opt/homebrew/share/zsh/site-functions"
        "${fpath[@]}" )
autoload -Uz $fpath[1]/*(.:t)
## load zsh colors
autoload -U colors && colors
## execute spectrum command to support color escape code shortcuts
spectrum

# pyenv setup
eval "$(pyenv init -)"
eval "$(pyenv init --path)"
eval "$(pyenv virtualenv-init -)"

# The following lines were added by compinstall

zstyle ':completion:*' auto-description 'specify: %d'
zstyle ':completion:*' completer _complete _ignored _correct
zstyle ':completion:*' completions 0
zstyle ':completion:*' expand prefix suffix
zstyle ':completion:*' insert-unambiguous true
zstyle ':completion:*' list-colors ${(s.:.)LS_COLORS}
zstyle ':completion:*' list-prompt '%SAt %p: Hit TAB for more, or the character to insert%s'
zstyle ':completion:*' list-suffixes true
zstyle ':completion:*' matcher-list 'm:{[:lower:]}={[:upper:]}'
zstyle ':completion:*' max-errors 10
zstyle ':completion:*' menu select=1
zstyle ':completion:*' original false
zstyle ':completion:*' preserve-prefix '//[^/]##/'
zstyle ':completion:*' select-prompt '%SScrolling active: current selection at %p%s'
zstyle ':completion:*' squeeze-slashes true
zstyle ':completion:*' use-compctl true
zstyle ':completion:*' verbose true
zstyle :compinstall filename '/Users/brian.tracey/.zshrc'

autoload -Uz compinit
compinit
# End of lines added by compinstall

# source zsh prompt file with functions stolen from bubblify oh-my-zsh theme https://github.com/hohmannr/bubblified/blob/master/bubblified.zsh-theme
source "$HOME"/.zsh_prompt_file

# THIS MUST BE AT THE END OF THE FILE FOR SDKMAN TO WORK!!!
export SDKMAN_DIR="/Users/brian.tracey/.sdkman"
[[ -s "/Users/brian.tracey/.sdkman/bin/sdkman-init.sh" ]] && source "/Users/brian.tracey/.sdkman/bin/sdkman-init.sh"

# iterm shell integration
test -e "${HOME}/.iterm2_shell_integration.zsh" && source "${HOME}/.iterm2_shell_integration.zsh"

# homebrew setup
eval "$(/opt/homebrew/bin/brew shellenv)"

# fzf setup
[ -f ~/.fzf.zsh ] && source ~/.fzf.zsh

# Protenus specific
## protenus tokens
source "$HOME"/.protenus_tokens
## protenus preferences
source "$HOME"/.protenusrc
# end ZSH profiler
#zprof

source /Users/brian.tracey/.docker/init-zsh.sh || true # Added by Docker Desktop
