#!/usr/bin/env bash
# Symlink tracked config files into their live locations.
# Existing real files are moved aside to <file>.backup-<timestamp> first.
# Safe to re-run: correct symlinks are left alone.
set -euo pipefail

REPO="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"
STAMP="$(date +%Y%m%d-%H%M%S)"
DRY_RUN="${DRY_RUN:-0}"

link() {
  local src="$1" dest="$2"
  [ -e "$src" ] || { echo "  skip (missing in repo): $src"; return; }

  if [ -L "$dest" ] && [ "$(readlink "$dest")" = "$src" ]; then
    echo "  ok:   $dest"
    return
  fi

  if [ "$DRY_RUN" = "1" ]; then
    echo "  would link: $dest -> $src"
    return
  fi

  mkdir -p "$(dirname "$dest")"
  if [ -e "$dest" ] || [ -L "$dest" ]; then
    mv "$dest" "$dest.backup-$STAMP"
    echo "  backed up existing $dest -> $dest.backup-$STAMP"
  fi
  ln -s "$src" "$dest"
  echo "  link: $dest -> $src"
}

echo "==> Shell + git (\$HOME)"
for f in .zshrc .zprofile .zshenv .zsh_functions .gitconfig .p10k.zsh .tmux.conf; do
  link "$REPO/home/$f" "$HOME/$f"
done

echo "==> XDG (~/.config)"
link "$REPO/xdg/nvim"          "$HOME/.config/nvim"
link "$REPO/xdg/gh/config.yml" "$HOME/.config/gh/config.yml"
link "$REPO/xdg/git/ignore"    "$HOME/.config/git/ignore"

echo "==> Apps"
link "$REPO/apps/ghostty/config" "$HOME/Library/Application Support/com.mitchellh.ghostty/config"
link "$REPO/apps/claude/settings.json" "$HOME/.claude/settings.json"

for pair in "Code:vscode" "Cursor:cursor"; do
  app="${pair%%:*}"; dir="${pair##*:}"
  base="$HOME/Library/Application Support/$app/User"
  link "$REPO/apps/$dir/settings.json"    "$base/settings.json"
  link "$REPO/apps/$dir/keybindings.json" "$base/keybindings.json"
  if [ -d "$REPO/apps/$dir/snippets" ]; then link "$REPO/apps/$dir/snippets" "$base/snippets"; fi
done

echo
echo "Done. Open a new shell (or 'exec zsh') to pick up shell changes."
