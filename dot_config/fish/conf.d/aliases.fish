# Shell aliases and small functions.
# Ported from ~/.config/nushell/aliases.nu

# ls family
alias la 'ls --all'
alias ll 'ls -l'
alias lla 'ls -la'
alias sl 'ls'

# file ops (note: system cp has no --progress like nushell's builtin)
alias cp 'cp --recursive --verbose'
alias mk 'mkdir'
alias mv 'mv --verbose'
alias rm 'rm --recursive --verbose'

alias pstree 'pstree -g 3'
alias tree 'eza --tree --git-ignore --group-directories-first'

# editor
alias vim 'nvim'

# ssh / mosh
alias mosh 'mosh --no-init'

# git
alias g 'git'
alias gst 'git status'
alias gsb 'git status --short --branch'
alias gc 'git commit --verbose'
alias s 'git status'
alias gaa 'git add -A'
alias gap 'git add --patch'
alias co 'git switch'
alias gco 'git switch'
alias gcb 'git switch --create'
alias gcm 'git switch (__git.default_branch)'
alias gd 'git diff'
alias gdc 'git diff --cached'
alias up 'git push'
alias upf 'git push --force-with-lease'
alias gpu 'git push --set-upstream origin (__git.current_branch)'
alias pu 'git pull'
alias pur 'git pull --rebase'
alias fe 'git fetch'
alias gfa 'git fetch --all --prune'
alias re 'git rebase'
alias grbi 'git rebase --interactive'
alias glog 'git log --oneline --decorate --graph'
alias gloga 'git log --oneline --decorate --graph --all'
alias lr 'git l -30'
alias hs 'git rev-parse --short HEAD'
alias hm 'git log --format=%B -n 1 HEAD'

# jj
alias jjj 'jj'
alias j 'jj'

# misc
alias cl 'claude-slop'
alias cy 'codex --yolo'
