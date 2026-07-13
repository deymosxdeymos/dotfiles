# Normalize PATH once, then prepend our preferred user/system paths.
let base_path = if (($env.PATH | describe) | str contains "list") {
  $env.PATH
} else {
  $env.PATH | split row (char esep)
}

$env.PNPM_HOME = $"($env.HOME)/.local/share/pnpm"

let extra_paths = [
  $"($env.HOME)/.nix-profile/bin"
  "/nix/var/nix/profiles/default/bin"
  $"($env.HOME)/.config/emacs/bin"
  $"($env.HOME)/.radicle/bin"
  $"($env.HOME)/.spicetify"
  $"($env.HOME)/go/bin"
  $"($env.HOME)/.local/opt/go/bin"
  $"($env.HOME)/.cargo/bin"
  $"($env.HOME)/.deno/bin"
  $"($env.HOME)/.bun/bin"
  $"($env.HOME)/.vite-plus/bin"
  $"($env.HOME)/.opencode/bin"
  $"($env.HOME)/.local/bin"
  $"($env.HOME)/.local/npm/bin"
  $env.PNPM_HOME
]

$env.PATH = ($extra_paths | append $base_path | uniq)

# electron
$env.ELECTRON_OZONE_PLATFORM_HINT = "wayland"

# nvim
$env.EDITOR = "hx"

# qt theme
$env.QT_QPA_PLATFORMTHEME = "kde"
$env.QT_STYLE_OVERRIDE = "Breeze"

# local temp dir (same filesystem as home/project to avoid cross-mount rename fallback)
$env.TMPDIR = $"($env.HOME)/.tmp"

$env.GHIDRA_HOME = $"($env.HOME)/opt/ghidra"
$env.JAVA_HOME = "/usr/lib/jvm/java-21-openjdk"

$env.HELIX_RUNTIME = ($env.HOME | path join "helix" "runtime")

# aws / bedrock
$env.AWS_REGION = "ap-southeast-1"

# Keep API keys and other secrets out of chezmoi. Source a local-only file if needed.
let local_env = ($env.HOME | path join ".config" "nushell" "local-env.nu")
if ($local_env | path exists) {
  source $local_env
}
