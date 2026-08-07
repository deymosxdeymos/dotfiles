# Create a directory, cd into it and colocate-init jj. Ported from ~/.config/nushell/config.nu
function mcg -d "mkdir + cd + jj git init --colocate"
    mkdir -p -- $argv[1]; and cd -- $argv[1]; and jj git init --colocate
end
