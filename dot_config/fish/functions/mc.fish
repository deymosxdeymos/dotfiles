# Create a directory and cd into it. Ported from ~/.config/nushell/config.nu
function mc -d "mkdir + cd"
    mkdir -p -- $argv[1]; and cd -- $argv[1]
end
