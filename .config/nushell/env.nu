# pnpm
$env.PNPM_HOME = "/home/deymos/.local/share/pnpm"
$env.PATH = ($env.PATH | split row (char esep) | prepend $env.PNPM_HOME )
# pnpm end

$env.PATH = ($env.PATH | prepend $"($env.HOME)/.npm-global/bin")
$env.PATH = ($env.PATH | split row (char esep) | prepend $"($env.HOME)/.local/bin")

# opencode
$env.PATH = ($env.PATH | split row (char esep) | prepend $"($env.HOME)/.opencode/bin")

# bun
$env.PATH = ($env.PATH | split row (char esep) | prepend $"($env.HOME)/.bun/bin")

# deno
$env.PATH = ($env.PATH | split row (char esep) | prepend $"($env.HOME)/.deno/bin")

# cargo/rust
$env.PATH = ($env.PATH | split row (char esep) | prepend $"($env.HOME)/.cargo/bin")

# go
$env.PATH = ($env.PATH | split row (char esep) | prepend $"($env.HOME)/.local/opt/go/bin")
$env.PATH = ($env.PATH | split row (char esep) | prepend $"($env.HOME)/go/bin")

# fnm
$env.PATH = ($env.PATH | split row (char esep) | prepend $"($env.HOME)/.local/share/fnm")
$env.PATH = ($env.PATH | split row (char esep) | prepend "/run/user/1000/fnm_multishells/6666_1756102377162/bin")
$env.FNM_MULTISHELL_PATH = "/run/user/1000/fnm_multishells/6666_1756102377162"
$env.FNM_VERSION_FILE_STRATEGY = "local"
$env.FNM_DIR = $"($env.HOME)/.local/share/fnm"
$env.FNM_LOGLEVEL = "info"
$env.FNM_NODE_DIST_MIRROR = "https://nodejs.org/dist"
$env.FNM_COREPACK_ENABLED = "false"
$env.FNM_RESOLVE_ENGINES = "true"
$env.FNM_ARCH = "x64"

# electron
$env.ELECTRON_OZONE_PLATFORM_HINT = "wayland"

# spicetify
$env.PATH = ($env.PATH | split row (char esep) | prepend $"($env.HOME)/.spicetify")

$env.EDITOR = "/usr/bin/nvim"
