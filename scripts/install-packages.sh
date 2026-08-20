#!/usr/bin/env bash
# Install Homebrew + everything in packages/.
# Idempotent: re-running only installs what's missing.
set -euo pipefail

REPO="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"

if ! command -v brew >/dev/null 2>&1; then
  echo "==> Installing Homebrew"
  /bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"
  eval "$(/opt/homebrew/bin/brew shellenv)"
fi
eval "$(/opt/homebrew/bin/brew shellenv)"

echo "==> brew bundle (this takes a while)"
brew bundle install --file="$REPO/packages/Brewfile"

echo "==> oh-my-zsh"
if [ ! -d "$HOME/.oh-my-zsh" ]; then
  RUNZSH=no KEEP_ZSHRC=yes sh -c "$(curl -fsSL https://raw.githubusercontent.com/ohmyzsh/ohmyzsh/master/tools/install.sh)"
fi
ZSH_CUSTOM="$HOME/.oh-my-zsh/custom"
clone_if_missing() {  # $1=repo url  $2=dest
  [ -d "$2" ] || git clone --depth=1 "$1" "$2"
}
clone_if_missing https://github.com/romkatv/powerlevel10k.git            "$ZSH_CUSTOM/themes/powerlevel10k"
clone_if_missing https://github.com/zsh-users/zsh-autosuggestions.git    "$ZSH_CUSTOM/plugins/zsh-autosuggestions"
clone_if_missing https://github.com/zsh-users/zsh-syntax-highlighting.git "$ZSH_CUSTOM/plugins/zsh-syntax-highlighting"

echo "==> npm globals"
if command -v npm >/dev/null 2>&1; then
  xargs -n1 npm install -g < "$REPO/packages/npm-global.txt" || echo "  (some npm installs failed - see above)"
fi

echo "==> cargo tools"
if command -v cargo >/dev/null 2>&1; then
  xargs -n1 cargo install < "$REPO/packages/cargo-tools.txt" || echo "  (some cargo installs failed)"
else
  echo "  skip: no cargo. Install rust first: https://rustup.rs"
fi

echo "==> go tools"
if command -v go >/dev/null 2>&1; then
  while read -r mod; do
    [ -n "$mod" ] || continue
    go install "$mod@latest" || echo "  failed: $mod"
  done < "$REPO/packages/go-tools.txt"
else
  echo "  skip: no go on PATH"
fi

echo "==> pipx tools"
if command -v pipx >/dev/null 2>&1; then
  xargs -n1 pipx install < "$REPO/packages/pipx-tools.txt" || true
fi

echo "==> editor extensions"
for pair in "code:vscode" "cursor:cursor"; do
  cli="${pair%%:*}"; dir="${pair##*:}"
  if command -v "$cli" >/dev/null 2>&1; then
    while read -r ext; do
      [ -n "$ext" ] || continue
      "$cli" --install-extension "$ext" --force || echo "  failed: $ext"
    done < "$REPO/apps/$dir/extensions.txt"
  else
    echo "  skip $cli: CLI not on PATH (install it from the app's command palette: 'Shell Command: Install ... in PATH')"
  fi
done

echo
echo "Packages done."
