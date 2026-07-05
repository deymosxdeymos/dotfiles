#!/bin/sh
set -eu

if command -v chezmoi >/dev/null 2>&1; then
  chezmoi --version
  exit 0
fi

sh -c "$(curl -fsLS get.chezmoi.io)" -- -b "$HOME/.local/bin"

case ":$PATH:" in
  *":$HOME/.local/bin:"*) ;;
  *)
    printf '%s\n' 'chezmoi was installed to ~/.local/bin. Add it to PATH if your shell does not already include it.'
    ;;
esac
