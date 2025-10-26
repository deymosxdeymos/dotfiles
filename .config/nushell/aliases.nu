# Shell aliases
alias la = ls --all
alias ll = ls --long
alias lla = ls --long --all
alias sl = ls

alias cp = cp --recursive --verbose --progress
alias mk = mkdir
alias mv = mv --verbose
alias rm = rm --recursive --verbose

alias pstree = pstree -g 3
alias tree = eza --tree --git-ignore --group-directories-first

# Editor aliases
alias vim = nvim

# Git aliases
alias gst = git status
alias gc = git commit
alias s = git status
alias gaa = git add -A
alias co = git checkout
alias gcm = git checkout main
alias gd = git diff
alias gdc = git diff --cached
alias up = git push
alias upf = git push --force
alias pu = git pull
alias pur = git pull --rebase
alias fe = git fetch
alias re = git rebase
alias lr = git l -30
alias hs = git rev-parse --short HEAD
alias hm = git log --format=%B -n 1 HEAD

alias c = claude --dangerously-skip-permissions

alias ccusage-codex = bunx @ccusage/codex@latest

alias ccusage = bunx ccusage
