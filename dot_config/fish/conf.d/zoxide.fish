# zoxide (cd replacement). Ported from ~/.config/nushell/zoxide.nu
# `cd`/`cdi` are overridden by zoxide's smart jumping (--cmd cd).
if command -q zoxide
    zoxide init fish --cmd cd | source
end
