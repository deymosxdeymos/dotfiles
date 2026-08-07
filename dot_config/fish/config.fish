# Interactive shell configuration.
# Ported from ~/.config/nushell/config.nu (prompt handled by starship).

if status is-interactive
    mise activate fish | source

    # No banner / greeting (nu: show_banner = false)
    set -g fish_greeting

    # vi edit mode (nu: edit_mode = "vi")
    fish_vi_key_bindings

    # Cursor shapes per mode (nu: cursor_shape.vi_insert = line, vi_normal = block)
    set -g fish_cursor_default block
    set -g fish_cursor_insert line
    set -g fish_cursor_replace_one underscore
    set -g fish_cursor_visual block

    # Case-insensitive / substring-ish completion behaviour is fish's default.
end

# Terminal title: show the running command (nu: pre_execution hook set
# the OSC title to "<cmd> — nu"). fish_title receives the command as $argv[1].
function fish_title
    set -l cmd $argv[1]
    if test -n "$cmd"
        echo "$cmd — fish"
    else
        echo (prompt_pwd)
    end
end
