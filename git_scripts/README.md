# Source Code for Extra Git Commands

The sources files for custom git sub-commands lives here. Symlink these files into the `path_scripts` directory
with the name `git-?`, where `?` is the subcommand you want to use with git. E.g., the `fzf-checkout.sh` script
here is used as `git ck ...`, so the symlink in `path_scripts` needs to be `git-ck`.
