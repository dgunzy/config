# Working in this repo

This is Dan's Mac setup repo. Its one job: **a dead laptop can be replaced from
`git clone` + `./bootstrap.sh` + `docs/MANUAL.md`.** Judge every change against
that.

## Layout

```
bootstrap.sh          entry point; calls the scripts below in order
scripts/
  install-packages.sh brew + oh-my-zsh + language package managers + editor extensions
  link-dotfiles.sh    symlinks repo files -> live locations
  backup.sh           reverse of link-dotfiles: live locations -> repo
macos/defaults.sh     `defaults write` for system preferences
home/                 files that live directly in $HOME (dotfiles)
xdg/                  files that live in ~/.config
apps/                 per-application config (ghostty, vscode, cursor, claude)
packages/             Brewfile + npm/cargo/go/pipx manifests
docs/MANUAL.md        secrets + steps no script can do
```

## Adding something new

Adding a config file means touching **three** places. Missing one is the usual bug:

1. Drop the file in `home/`, `xdg/`, or `apps/<app>/`
2. Add a `link` line in `scripts/link-dotfiles.sh`
3. Add a matching `copy` line in `scripts/backup.sh`

Then run `DRY_RUN=1 ./scripts/link-dotfiles.sh` and confirm the new path appears.

For a new tool/package: add it to the right file in `packages/` **and** make sure
`backup.sh` regenerates that file, so it doesn't silently go stale.

## Rules

- **Never commit a secret.** Not keys, tokens, `hosts.yml`, `credentials`,
  `auth.json`, `.netrc`, kubeconfigs. They belong in `docs/MANUAL.md` as a
  *pointer* to where they live and how to regenerate them. `.gitignore` is a
  backstop, not permission to be careless.
- **Everything idempotent.** Every script gets re-run on a working machine.
  Check before you create; never clobber without backing up first.
- **No hardcoded `/Users/danguns`** in scripts — use `$HOME` and the `$REPO`
  variable each script already computes. (Note `home/.zshrc` *does* contain
  absolute paths; that's a captured file, left verbatim on purpose.)
- **Fail loudly, continue sensibly.** Scripts use `set -euo pipefail`, but a
  single package failing to install shouldn't abort the whole run — that's why
  the per-manager loops in `install-packages.sh` end in `|| echo ...`.
- **Don't commit unless asked.**

## Checking your work

```sh
bash -n bootstrap.sh scripts/*.sh macos/defaults.sh   # syntax
shellcheck bootstrap.sh scripts/*.sh                  # if installed
DRY_RUN=1 ./scripts/link-dotfiles.sh                  # safe end-to-end
git status --porcelain                                # nothing unexpected staged
```

A real end-to-end test needs a fresh macOS user account or VM; short of that,
`DRY_RUN=1` plus a careful read is the bar.

## Known gaps

- Mac App Store apps aren't captured (`mas` isn't installed). Non-brew apps are
  listed for reference in `docs/applications.txt`.
- `macos/defaults.sh` covers only settings deliberately changed from Apple's
  defaults; `backup.sh` prints current values but does **not** rewrite the script
  — reconcile drift by hand.
- iTerm2 preferences aren't captured. If they start mattering, point iTerm at a
  plist inside this repo (Preferences → General → Settings → "Load preferences
  from a custom folder").
- `~/.config/nvim` is captured as plain files, not as its upstream git repo.
