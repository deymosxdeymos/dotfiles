# atuin: shell history (sqlite-backed, searchable). Binds Ctrl-R and Up.
# History was imported from nushell via `atuin import nu-hist-db`.
if status is-interactive; and command -q atuin
    atuin init fish | source
end
