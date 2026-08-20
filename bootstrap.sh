#!/usr/bin/env bash
# One-shot setup for a fresh Mac. Run from inside the repo:
#   ./bootstrap.sh
# Steps are independent and idempotent - re-run any of them alone if one fails.
set -euo pipefail

REPO="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
cd "$REPO"

echo "############################################"
echo "#  Dan's Mac setup                         #"
echo "############################################"
echo
echo "This will:"
echo "  1. install Xcode command line tools"
echo "  2. install Homebrew + all packages, plugins, editor extensions"
echo "  3. symlink dotfiles into place (existing files backed up)"
echo "  4. apply macOS system preferences"
echo
echo "It does NOT restore secrets - see docs/MANUAL.md for those."
read -rp "Continue? [y/N] " reply
[[ "$reply" =~ ^[Yy]$ ]] || { echo "Aborted."; exit 0; }

echo
echo "=== 1/4 Xcode command line tools ==="
xcode-select -p >/dev/null 2>&1 || xcode-select --install || true

echo
echo "=== 2/4 Packages ==="
./scripts/install-packages.sh

echo
echo "=== 3/4 Dotfiles ==="
./scripts/link-dotfiles.sh

echo
echo "=== 4/4 macOS defaults ==="
./macos/defaults.sh

cat <<'NEXT'

############################################
#  Done. Remaining manual steps:           #
############################################
  - Read docs/MANUAL.md  (SSH keys, GPG signing key, logins, non-brew apps)
  - Restart the terminal, or: exec zsh
  - Open nvim once so lazy.nvim installs plugins
  - gh auth login
NEXT
