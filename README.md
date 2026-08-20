# config

My Mac setup, in one repo. If this laptop dies, a fresh machine gets back to
usable with:

```sh
git clone git@github.com:dgunzy/config.git ~/config
cd ~/config
./bootstrap.sh
```

Then work through **[docs/MANUAL.md](docs/MANUAL.md)** for the things a script
can't do — SSH keys, the GPG signing key, app logins.

> No secrets are in this repo, by design. See `.gitignore` and `docs/MANUAL.md`.

## What's here

| Path | What it is |
|---|---|
| `bootstrap.sh` | Full fresh-Mac setup. Runs the three scripts below in order. |
| `scripts/install-packages.sh` | Homebrew + Brewfile, oh-my-zsh + plugins, npm/cargo/go/pipx tools, editor extensions |
| `scripts/link-dotfiles.sh` | Symlinks everything in `home/`, `xdg/`, `apps/` into place (backs up what's already there) |
| `scripts/backup.sh` | The reverse: pulls current machine state back into this repo. Run it after you change a setting. |
| `macos/defaults.sh` | System preferences — Dock, Finder, key repeat, screenshot location |
| `home/` | `$HOME` dotfiles: zsh, git, p10k, tmux |
| `xdg/` | `~/.config`: nvim (LazyVim), gh, git ignore |
| `apps/` | ghostty, VS Code, Cursor, Claude Code |
| `packages/` | Brewfile + npm / cargo / go / pipx manifests |
| `docs/MANUAL.md` | Secrets and manual steps |
| `docs/applications.txt` | Everything that was in `/Applications`, for reference |

## Running pieces separately

Each script is standalone and idempotent — re-run any of them alone.

```sh
./scripts/link-dotfiles.sh          # apply
DRY_RUN=1 ./scripts/link-dotfiles.sh   # show what it would do, change nothing
./scripts/install-packages.sh
./macos/defaults.sh
```

## Keeping it current

```sh
./scripts/backup.sh
git diff          # review
git add -A && git commit
```

`backup.sh` skips anything already symlinked into the repo (there's nothing to
copy — the live file *is* the repo file), and prints current macOS defaults so
you can spot drift from `macos/defaults.sh` by eye.

## Shell layout, briefly

- `.zprofile` — Homebrew shellenv (login shells)
- `.zshenv` — foundry on PATH (all shells)
- `.zshrc` — oh-my-zsh, powerlevel10k, PATH, `k` alias, `git pushc` wrapper
- `.zsh_functions` — `amend` (sign + force-push) and `merge` (squash-merge current PR via `gh`)
