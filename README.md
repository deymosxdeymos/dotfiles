# Dotfiles

Managed with `chezmoi`. Version control can be `jj`; chezmoi only cares that this directory is its source state.

## First Machine Setup

```sh
./bootstrap.sh
chezmoi init --source "$PWD"
chezmoi diff
chezmoi apply
```

## New Machine Setup

```sh
sh -c "$(curl -fsLS get.chezmoi.io)"
chezmoi init --apply <git-remote-url>
```

## Scope

Tracked:

- Git and jj config
- Nushell config, aliases, and zoxide integration
- Neovim config
- Ghostty, Alacritty, tmux, Zellij, and Yazi config
- opencode config, local plugin, and instructions
- `~/.agents/skills`
- Pi agent extensions, custom agents, and non-secret settings

Not tracked:

- API keys, auth files, credentials, tokens, browser profiles, histories, logs, caches, and dependency folders
- `~/.bashrc` and `~/.npmrc` for now, because the current files contain secrets

## Notes

Run `chezmoi diff` before every broad apply. If a config contains a secret, move the secret to an external secret store or local untracked file before adding it here.
