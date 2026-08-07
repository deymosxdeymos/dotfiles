# Prompt via starship. Config lives at ~/.config/starship.toml
# (borrowed from github.com/dmmulroy/.dotfiles).
if status is-interactive; and command -q starship
    starship init fish | source
end
