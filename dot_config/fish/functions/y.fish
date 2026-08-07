# Launch yazi and cd to the directory it exits in.
# Ported from ~/.config/nushell/aliases.nu
function y -d "yazi with cwd follow"
    set -l tmp (mktemp -t yazi-cwd.XXXXXX)
    yazi $argv --cwd-file $tmp
    set -l cwd (command cat -- $tmp)
    if test -n "$cwd"; and test "$cwd" != "$PWD"; and test -d "$cwd"
        cd -- $cwd
    end
    rm -f -- $tmp
end
