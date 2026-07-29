# Environment variables and PATH.
# Ported from ~/.config/nushell/env.nu

set -gx PNPM_HOME "$HOME/.local/share/pnpm"

# Preferred user/system paths, highest priority first.
# fish_add_path prepends (first arg ends up highest priority) and de-dupes.
fish_add_path --global --prepend \
    "$HOME/.nix-profile/bin" \
    /nix/var/nix/profiles/default/bin \
    "$HOME/.config/emacs/bin" \
    "$HOME/.radicle/bin" \
    "$HOME/.spicetify" \
    "$HOME/go/bin" \
    "$HOME/.local/opt/go/bin" \
    "$HOME/.cargo/bin" \
    "$HOME/.deno/bin" \
    "$HOME/.nub/bin" \
    "$HOME/.bun/bin" \
    "$HOME/.vite-plus/bin" \
    "$HOME/.opencode/bin" \
    "$HOME/.local/bin" \
    "$HOME/.local/npm/bin" \
    "$PNPM_HOME"

# electron
set -gx ELECTRON_OZONE_PLATFORM_HINT wayland

# editor
set -gx EDITOR hx

# qt theme
set -gx QT_QPA_PLATFORMTHEME kde
set -gx QT_STYLE_OVERRIDE Breeze

# local temp dir (same filesystem as home/project to avoid cross-mount rename fallback)
set -gx TMPDIR "$HOME/.tmp"

set -gx GHIDRA_HOME "$HOME/opt/ghidra"
set -gx JAVA_HOME /usr/lib/jvm/java-21-openjdk

set -gx HELIX_RUNTIME "$HOME/helix/runtime"

# aws / bedrock
set -gx AWS_REGION ap-southeast-1

# Keep API keys and other secrets out of version control.
# Source a local-only file if present.
set -l local_env "$HOME/.config/fish/local-env.fish"
if test -f $local_env
    source $local_env
end
