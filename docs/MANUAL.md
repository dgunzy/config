# Manual restore steps

Everything here is either a **secret** (never commit it) or something no script can
do for you. Work top to bottom after `./bootstrap.sh` finishes.

---

## 1. Secrets — where they live and how to get them back

None of these are in this repo. Keep a copy in **Bitwarden** (or an encrypted USB
drive) and restore them by hand.

| What | Path on this Mac | How to restore |
|---|---|---|
| SSH key (GitHub) | `~/.ssh/id_ed25519{,.pub}` | Restore from backup, or `ssh-keygen -t ed25519 -C danbguns@gmail.com` and add the new pubkey to GitHub |
| SSH key (polytrader/flux) | `~/.ssh/polytrader_flux_ed25519{,.pub}` | Restore from backup — this one authorises a deployment, regenerating means re-registering it |
| SSH config | `~/.ssh/config` | Recreate — see snippet below |
| GPG signing key | keyring, key ID `A4A63406F0E8A225` | `gpg --import private.asc` then `gpg --edit-key A4A63406F0E8A225 trust` |
| SOPS age key | `~/.sops/age.agekey` | Restore from backup. Without it you cannot decrypt any sops-encrypted repo |
| GitHub CLI token | `~/.config/gh/hosts.yml` | Don't restore — just run `gh auth login` |
| GitHub PAT | `~/.githubtoken` | Regenerate at github.com/settings/tokens |
| netrc | `~/.netrc` | Regenerate the credentials it holds |
| AWS credentials | `~/.aws/credentials` | Regenerate keys in the AWS console |
| Kubeconfigs | `~/.kube/config` | Re-fetch from each cluster |
| Docker registry auth | `~/.docker/config.json` | `docker login` |
| Claude Code auth | `~/.claude/.credentials.json` | Just run `claude` and log in |
| Codex auth | `~/.codex/auth.json` | Log in through the app |

**Permissions matter.** After restoring SSH material:

```sh
chmod 700 ~/.ssh
chmod 600 ~/.ssh/id_ed25519 ~/.ssh/polytrader_flux_ed25519
chmod 644 ~/.ssh/*.pub ~/.ssh/config
```

`~/.ssh/config` currently contains only:

```
Host github.com
  AddKeysToAgent yes
  IdentityFile ~/.ssh/id_ed25519
```

### Verify signing works

`~/.gitconfig` sets `commit.gpgsign = true`, so **every commit fails until GPG is
restored**. Check with:

```sh
echo test | gpg --clearsign        # must not error
git commit --allow-empty -S -m "signing check"
```

If GPG asks for a passphrase in the wrong place, confirm `export GPG_TTY=$(tty)`
is in `~/.zshrc` (it is) and that `pinentry-mac` is installed (it's in the Brewfile).

---

## 2. Apps not installed by Homebrew

`docs/applications.txt` is the full list of what was in `/Applications`. The ones
that matter and are **not** covered by `packages/Brewfile`:

- Bitwarden — install first; everything else needs the passwords in it
- Alfred, Rectangle, AppCleaner — small utilities, big quality-of-life
- Cursor, Visual Studio Code — settings and extensions restore from `apps/`
- Docker Desktop, Postman, Android Studio, LM Studio
- Obsidian — vault lives in `~/obsidian-files`, restore from your sync/backup
- Microsoft Office suite, OneDrive, Teams, Outlook — sign in with the work account
- Adobe Creative Cloud, Lightroom, Pixelmator Pro — license/subscription logins
- Signal, Slack, Discord, Telegram, WhatsApp, Zoom, Webex, Spotify
- Firefox, Google Chrome

---

## 3. Things that live outside this repo

- `~/network-debug/` — home-network investigation notes and `netmon.sh` / `netreport.sh`. Its own repo.
- `~/dotfiles` — the older dotfiles repo (`git@github.com:dgunzy/dotfiles.git`); only ever held `.tmux.conf`, which now also lives here in `home/`.
- `~/obsidian-files`, `~/notes` — notes; back these up separately.
- Project checkouts under `~/Projects`, `~/OpenSource`, `~/PersonalProjects`, etc. — all in git, re-clone them.

---

## 4. Known quirks carried over from this machine

- `apps/vscode/settings.json` sets `esbenp.prettier-vscode` as the formatter for
  html/gohtml/css/javascript, but Prettier **is not installed in VS Code** (it is
  in Cursor). Either `code --install-extension esbenp.prettier-vscode` or drop
  those `[lang]` blocks.
- `home/.zshrc` adds `~/.local/bin` to PATH twice and hardcodes
  `/Users/danguns/...` in several `export PATH` lines. Captured verbatim on
  purpose — clean it up here if you want, then `./scripts/link-dotfiles.sh`.
- `home/.tmux.conf` is the copy that was live in `$HOME`. The older
  `~/dotfiles` repo has a near-identical version that additionally sets
  `set -g mouse on`; the live one does not. If you want mouse mode, add it here.

---

## 5. Post-install checklist

- [ ] `exec zsh` — prompt is powerlevel10k, no errors
- [ ] `nvim` — lazy.nvim installs plugins on first launch, then `:checkhealth`
- [ ] `gh auth login`
- [ ] `git commit -S` on a scratch repo succeeds (GPG restored)
- [ ] `ssh -T git@github.com` says "successfully authenticated"
- [ ] `k get ns` against a real cluster (kubeconfig restored)
- [ ] Set the terminal font to a Nerd Font — p10k needs it for its glyphs (`brew list --cask` / p10k will offer to install one via `p10k configure`)
