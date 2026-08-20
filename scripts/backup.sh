#!/usr/bin/env bash
# Re-capture the CURRENT machine state back into this repo.
# Run this after changing settings so the repo doesn't drift.
# Files that are already symlinks into the repo are skipped (nothing to copy).
set -euo pipefail

REPO="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"

copy() {  # $1=live path  $2=repo path
  local live="$1" dest="$REPO/$2"
  [ -e "$live" ] || { echo "  skip (not present): $live"; return; }
  if [ -L "$live" ]; then echo "  symlinked, nothing to copy: $2"; return; fi
  mkdir -p "$(dirname "$dest")"
  if [ -d "$live" ]; then rm -rf "$dest"; fi   # else cp -R would nest dir inside dir
  cp -R "$live" "$dest"
  echo "  captured: $2"
}

echo "==> Shell + git"
for f in .zshrc .zprofile .zshenv .zsh_functions .gitconfig .p10k.zsh; do copy "$HOME/$f" "home/$f"; done
copy "$HOME/.tmux.conf" "home/.tmux.conf"

echo "==> XDG"
copy "$HOME/.config/nvim"          "xdg/nvim"
copy "$HOME/.config/gh/config.yml" "xdg/gh/config.yml"
copy "$HOME/.config/git/ignore"    "xdg/git/ignore"
rm -rf "$REPO/xdg/nvim/.git"

echo "==> Apps"
copy "$HOME/Library/Application Support/com.mitchellh.ghostty/config" "apps/ghostty/config"
copy "$HOME/.claude/settings.json" "apps/claude/settings.json"
for pair in "Code:vscode" "Cursor:cursor"; do
  app="${pair%%:*}"; dir="${pair##*:}"
  base="$HOME/Library/Application Support/$app/User"
  copy "$base/settings.json"    "apps/$dir/settings.json"
  copy "$base/keybindings.json" "apps/$dir/keybindings.json"
  copy "$base/snippets"         "apps/$dir/snippets"
done

echo "==> Packages"
if command -v brew >/dev/null; then
  brew bundle dump --file="$REPO/packages/Brewfile" --force
fi
if command -v npm >/dev/null; then
  npm ls -g --depth=0 --json 2>/dev/null \
    | python3 -c "import json,sys; d=json.load(sys.stdin).get('dependencies',{}); [print(k) for k in sorted(d) if k!='npm']" \
    > "$REPO/packages/npm-global.txt"
fi
if command -v cargo >/dev/null; then
  cargo install --list 2>/dev/null | grep -E '^\S+ v' | awk '{print $1}' > "$REPO/packages/cargo-tools.txt"
fi
if command -v go >/dev/null; then
  # best effort: read the module path back out of each installed binary
  for b in "$(go env GOPATH)"/bin/*; do
    [ -f "$b" ] || continue
    go version -m "$b" 2>/dev/null | awk '$1=="path"{print $2; exit}'
  done | sort -u > "$REPO/packages/go-tools.txt"
fi
if command -v pipx >/dev/null; then
  pipx list --short 2>/dev/null | awk '{print $1}' > "$REPO/packages/pipx-tools.txt"
fi
command -v code   >/dev/null && code   --list-extensions > "$REPO/apps/vscode/extensions.txt" || true
command -v cursor >/dev/null && cursor --list-extensions > "$REPO/apps/cursor/extensions.txt" || true
find /Applications -maxdepth 1 -name '*.app' -exec basename {} .app \; | sort > "$REPO/docs/applications.txt"

echo
echo "==> Current macOS defaults (compare against macos/defaults.sh by hand)"
while read -r domain key; do
  [ -z "$domain" ] && continue
  printf "  %-32s %-38s = %s\n" "$domain" "$key" "$(defaults read "$domain" "$key" 2>/dev/null || echo UNSET)"
done <<'KEYS'
com.apple.dock autohide
com.apple.dock tilesize
com.apple.dock show-recents
com.apple.dock mru-spaces
com.apple.finder ShowPathbar
com.apple.finder ShowStatusBar
com.apple.finder FXPreferredViewStyle
NSGlobalDomain AppleShowAllExtensions
NSGlobalDomain AppleInterfaceStyle
NSGlobalDomain AppleShowScrollBars
NSGlobalDomain com.apple.swipescrolldirection
NSGlobalDomain ApplePressAndHoldEnabled
com.apple.screencapture location
KEYS

echo
echo "Done. Review with 'git -C $REPO diff' before committing."
