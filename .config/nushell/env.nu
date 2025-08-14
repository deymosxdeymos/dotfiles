# pnpm
$env.PNPM_HOME = "/home/deymos/.local/share/pnpm"
$env.PATH = ($env.PATH | split row (char esep) | prepend $env.PNPM_HOME )
# pnpm end

$env.PATH = ($env.PATH | prepend $"($env.HOME)/.npm-global/bin")
$env.XDG_CURRENT_DESKTOP = "GNOME"
$env.PATH = ($env.PATH | split row (char esep) | prepend $"($env.HOME)/.local/bin")
