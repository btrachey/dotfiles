# Source Code for Extra Git Commands

The sources files for custom git sub-commands lives here. Symlink these files into the `path_scripts` directory
with the name `git-?`, where `?` is the subcommand you want to use with git. E.g., the `fzf-checkout.sh` script
here is used as `git ck ...`, so the symlink in `path_scripts` needs to be `git-ck`.

`fzf-worktree.sh` is used as `git wk [branch]` — same fzf-picker style as `git ck`, but creates a
`git worktree` (as a sibling directory of wherever `.git` lives) instead of switching in place. It reuses an
existing local or remote branch of that name if one exists, otherwise branches off HEAD. `git wk` only creates
the worktree and prints its path — it can't `cd` your shell itself, so use the `wk` zsh function
(`zshfn/wk`) instead if you want to land in the new worktree directly.

`git wk init <repo>` bootstraps a brand-new project directory in the bare-repo + worktree layout (`.bare/`
holding the repo, a `.git` file pointing at it, and each branch checked out as a sibling directory) — run it
from wherever you keep projects, not from inside an existing repo. `<repo>` takes one of two forms:
- a full URL ending in `.git` (anything plain `git clone` accepts) — the directory is named after its basename
- `user/repo` shorthand — resolved to `https://github.com/user/repo.git`, directory named `repo`

It resolves the default branch from the remote (same `git remote show origin` trick as the `clean-repo`/`ckd`
aliases) and creates a worktree for it, so `git wk`'s remote-branch reuse works against repos it initializes.
Dispatched from `fzf-worktree.sh` (`git wk init ...`); implemented in `bare-init.sh`.
