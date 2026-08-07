# Open a path in the-editor, fully detached. Ported from ~/.config/nushell/aliases.nu
function te -d "Open path in the-editor, detached"
    set -l path $argv[1]
    test -z "$path"; and set path .
    setsid --fork the-editor $path >/dev/null 2>&1
end
