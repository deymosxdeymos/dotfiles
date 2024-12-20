##############
# BASIC SETUP # Sets up core ZSH functionality and initializes color support
##############

typeset -U PATH           # Ensures PATH entries are unique
autoload colors; colors;  # Loads and initializes color functionality

##########
# HISTORY # Controls command history behavior and storage
##########

HISTFILE=$HOME/.zsh_history  # File where history is stored
HISTSIZE=50000              # Maximum history size in memory
SAVEHIST=50000             # Maximum size of history file

setopt INC_APPEND_HISTORY     # Immediately append to history file.
setopt EXTENDED_HISTORY       # Record timestamp in history.
setopt HIST_EXPIRE_DUPS_FIRST # Expire duplicate entries first when trimming history.
setopt HIST_IGNORE_DUPS       # Dont record an entry that was just recorded again.
setopt HIST_IGNORE_ALL_DUPS   # Delete old recorded entry if new entry is a duplicate.
setopt HIST_FIND_NO_DUPS      # Do not display a line previously found.
setopt HIST_IGNORE_SPACE      # Dont record an entry starting with a space.
setopt HIST_SAVE_NO_DUPS      # Dont write duplicate entries in the history file.
setopt SHARE_HISTORY          # Share history between all sessions.
unsetopt HIST_VERIFY          # Execute commands using history (e.g.: using !$) immediately

#############
# COMPLETION # Configures ZSH's powerful tab completion system
#############

# Speed up completion init, see: https://gist.github.com/ctechols/ca1035271ad134841284
autoload -Uz compinit     # Loads completion system
for dump in ~/.zcompdump(N.mh+24); do  # Only rebuild completion dump once per day
  compinit
done
compinit -C  # Load completions from cache

# unsetopt menucomplete
unsetopt flowcontrol    # Disable flow control commands (keeps CTRL+S/CTRL+Q from freezing everything)
setopt auto_menu       # Show completion menu on successive tab press
setopt complete_in_word # Allow completion from within a word/phrase
setopt always_to_end   # Move cursor to end of word when completing
setopt auto_pushd      # Make cd push old directory onto directory stack

zstyle ':completion:*' matcher-list 'm:{a-z}={A-Za-z}'  # Case-insensitive completion

###############
# KEY BINDINGS # Configure keyboard shortcuts and input behavior
###############

# Vim Keybindings
bindkey -v  # Enable vim mode

# This is a "fix" for zsh in Ghostty:
# Ghostty implements the fixterms specification https://www.leonerd.org.uk/hacks/fixterms/
# and under that `Ctrl-[` doesn't send escape but `ESC [91;5u`.
#
# (tmux and Neovim both handle 91;5u correctly, but raw zsh inside Ghostty doesn't)
#
# Thanks to @rockorager for this!
bindkey "^[[91;5u" vi-cmd-mode  # Fix for Ghostty terminal ESC key behavior

# Open line in Vim by pressing 'v' in Command-Mode
autoload -U edit-command-line   # Load the command-line editor
zle -N edit-command-line       # Create new widget
bindkey -M vicmd v edit-command-line  # Bind v in command mode to edit line

# Push current line to buffer stack, return to PS1
bindkey "^Q" push-input  # Save current command line and clear it

# Make up/down arrow put the cursor at the end of the line
# instead of using the vi-mode mappings for these keys
bindkey "\eOA" up-line-or-history    # Up arrow for previous history
bindkey "\eOB" down-line-or-history  # Down arrow for next history
bindkey "\eOC" forward-char          # Right arrow moves forward
bindkey "\eOD" backward-char         # Left arrow moves backward

# CTRL-R to search through history
bindkey '^R' history-incremental-search-backward  # Search backward in history
# CTRL-S to search forward in history
bindkey '^S' history-incremental-search-forward   # Search forward in history
# Accept the presented search result
bindkey '^Y' accept-search  # Accept the found history entry

# Use the arrow keys to search forward/backward through the history,
# using the first word of what's typed in as search word
bindkey '^[[A' history-search-backward  # Up arrow for history search backward
bindkey '^[[B' history-search-forward   # Down arrow for history search forward

# Use the same keys as bash for history forward/backward: Ctrl+N/Ctrl+P
bindkey '^P' history-search-backward  # Ctrl+P for previous matching command
bindkey '^N' history-search-forward   # Ctrl+N for next matching command

# Backspace working the way it should
bindkey '^?' backward-delete-char  # Backspace deletes backward
bindkey '^[[3~' delete-char       # Delete key deletes forward

# Some emacs keybindings won't hurt nobody
bindkey '^A' beginning-of-line  # Ctrl+A moves to start of line
bindkey '^E' end-of-line       # Ctrl+E moves to end of line

# Where should I put you?
bindkey -s '^F' "tmux-sessionizer\n"  # Ctrl+F runs tmux-sessionizer

#########
# Aliases # Shorthand commands for commonly used operations
#########

case $OSTYPE in
  linux*)
    local aliasfile="${HOME}/.zsh.d/aliases.Linux.sh"   # Linux-specific aliases
    [[ -e ${aliasfile} ]] && source ${aliasfile}
  ;;
  darwin*)
    local aliasfile="${HOME}/.zsh.d/aliases.Darwin.sh"  # MacOS-specific aliases
    [[ -e ${aliasfile} ]] && source ${aliasfile}
  ;;
esac

if type eza &> /dev/null; then
  alias ls=eza  # Use lsd instead of ls if available
fi
alias lls='ls -lh --sort=size --reverse'  # List files by size, largest first
alias llt='ls -sold'                       # List files by time, oldest first
alias bear='clear && echo "Clear as a bear!"'  # Clear screen with a message

alias history='history 1'  # Show all history
alias hs='history | grep '  # Search history

# Use rsync with ssh and show progress
alias rsyncssh='rsync -Pr --rsh=ssh'  # Rsync with SSH and progress bar

# Edit/Source vim config
alias ez='vim ~/.zshrc'    # Edit zshrc
alias sz='source ~/.zshrc' # Reload zshrc

# git
alias gst='git status'              # Git status
alias gaa='git add -A'             # Git add all
alias gc='git commit'              # Git commit
alias gcm='git checkout main'      # Switch to main branch
alias gd='git diff'                # Git diff
alias gdc='git diff --cached'      # Git diff staged changes
# [c]heck [o]ut
alias co='git checkout'            # Git checkout shorthand
# [f]uzzy check[o]ut
fo() {
  git branch --no-color --sort=-committerdate --format='%(refname:short)' | fzf --header 'git checkout' | xargs git checkout
}
# [p]ull request check[o]ut
po() {
  gh pr list --author "@me" | fzf --header 'checkout PR' | awk '{print $(NF-5)}' | xargs git checkout
}
alias up='git push'                # Git push
alias upf='git push --force'       # Git push force
alias pu='git pull'                # Git pull
alias pur='git pull --rebase'      # Git pull rebase
alias fe='git fetch'               # Git fetch
alias re='git rebase'              # Git rebase
alias lr='git l -30'               # Git log recent
alias cdr='cd $(git rev-parse --show-toplevel)' # cd to git Root
alias hs='git rev-parse --short HEAD'  # Get short commit hash
alias hm='git log --format=%B -n 1 HEAD'  # Get commit message

# tmux
alias tma='tmux attach -t'  # Attach to tmux session
alias tmn='tmux new -s'     # New tmux session
alias tmm='tmux new -s main'  # New main tmux session

# ceedee dot dot dot
alias -g ...='../..'       # Go up 2 directories
alias -g ....='../../..'   # Go up 3 directories
alias -g .....='../../../..'  # Go up 4 directories

# Notes
alias n='vim +Notes' # Opens Vim and calls `:Notes`

# Go
alias got='go test ./...'  # Run Go tests

alias k='kubectl'  # Kubernetes shorthand

alias -g withcolors="| sed '/PASS/s//$(printf "\033[32mPASS\033[0m")/' | sed '/FAIL/s//$(printf "\033[31mFAIL\033[0m")/'"  # Colorize test output

alias zedn='/Applications/Zed\ Nightly.app/Contents/MacOS/cli'  # Zed editor CLI
alias r='cargo run'         # Run Rust project
alias rr='cargo run --release'  # Run Rust project in release mode

##########
# FUNCTIONS # Custom shell functions for various tasks
##########

mkdircd() {
  mkdir -p $1 && cd $1  # Create directory and cd into it
}

render_dot() {
  local out="${1}.png"
  dot "${1}" \
    -Tpng \
    -Nfontname='JetBrains Mono' \
    -Nfontsize=10 \
    -Nfontcolor='#fbf1c7' \
    -Ncolor='#fbf1c7' \
    -Efontname='JetBrains Mono' \
    -Efontcolor='#fbf1c7' \
    -Efontsize=10 \
    -Ecolor='#fbf1c7' \
    -Gbgcolor='#1d2021' > ${out} && \
    kitty +kitten icat --align=left ${out}  # Render Graphviz dot file with specific styling
}

serve() {
  local port=${1:-8000}
  local ip=$(ipconfig getifaddr en0 2>/dev/null || hostname -I | awk '{print $1}') # Works on both macOS and Linux
  echo "Serving on http://${ip}:${port} ..."
  # Try python3 first, fall back to python if needed
  if command -v python3 &>/dev/null; then
    python3 -m http.server ${port}
  else
    python -m http.server ${port}
  fi
}

beautiful() {
  while
  do
    i=$((i + 1)) && echo -en "\x1b[3$(($i % 7))mo" && sleep .2  # Rainbow text animation
  done
}

spinner() {
  while
  do
    for i in "-" "\\" "|" "/"
    do
      echo -n " $i \r\r"
      sleep .1  # Spinning cursor animation
    done
  done
}

s3() {
  local route="s3.thorstenball.com/${1}"
  aws s3 cp ${1} s3://${route}
  echo http://${route} | pbcopy  # Upload to S3 and copy URL
}

# Open PR on GitHub
pr() {
  if type gh &> /dev/null; then
    gh pr view -w  # Open current PR in browser
  else
    echo "gh is not installed"
  fi
}

#########
# PROMPT # Configure shell prompt appearance
#########

setopt prompt_subst  # Enable prompt substitution

git_prompt_info() {
  local dirstatus=" OK"
  local dirty="%{$fg_bold[red]%} X%{$reset_color%}"

  if [[ ! -z $(git status --porcelain 2> /dev/null | tail -n1) ]]; then
    dirstatus=$dirty
  fi

  ref=$(git symbolic-ref HEAD 2> /dev/null) || \
  ref=$(git rev-parse --short HEAD 2> /dev/null) || return
  echo " %{$fg_bold[green]%}${ref#refs/heads/}$dirstatus%{$reset_color%}"  # Git branch and status in prompt
}

# local dir_info_color="$fg_bold[black]"

# This just sets the color to "bold".
# Future me. Try this to see what's correct:
#   $ print -P '%fg_bold[black] black'
#   $ print -P '%B%F{black} black'
#   $ print -P '%B black'
local dir_info_color="%B"  # Bold text for directory info

local dir_info_color_file="${HOME}/.zsh.d/dir_info_color"
if [ -r ${dir_info_color_file} ]; then
  source ${dir_info_color_file}  # Load custom color settings
fi

local dir_info="%{$dir_info_color%}%(5~|%-1~/.../%2~|%4~)%{$reset_color%}"  # Directory path in prompt
local promptnormal="φ %{$reset_color%}"  # Normal prompt symbol
local promptjobs="%{$fg_bold[red]%}φ %{$reset_color%}"  # Prompt symbol when jobs are running

PROMPT='${dir_info}$(git_prompt_info) ${nix_prompt}%(1j.$promptjobs.$promptnormal)'  # Final prompt configuration

simple_prompt() {
  local prompt_color="%B"
  export PROMPT="%{$prompt_color%}$promptnormal"  # Simplified prompt option
}

########
# ENV # Environment variable settings
########

export COLOR_PROFILE="dark"  # Set color theme preference

case $OSTYPE in
  linux*)
    local envfile="${HOME}/.zsh.d/env.Linux.sh"
    [[ -e ${envfile} ]] && source ${envfile}  # Linux environment settings
  ;;
  darwin*)
    local envfile="${HOME}/.zsh.d/env.Darwin.sh"
    [[ -e ${envfile} ]] && source ${envfile}  # MacOS environment settings
  ;;
esac

export LSCOLORS="Gxfxcxdxbxegedabagacad"  # Colors for ls output

# Reduce delay for key combinations in order to change to vi mode faster
# See: http://www.johnhawthorn.com/2012/09/vi-escape-delays/
# Set it to 10ms
export KEYTIMEOUT=1  # Faster vim mode switching

export PATH="$HOME/neovim/bin:$PATH"  # Add Neovim to path

if type nvim &> /dev/null; then
  alias vim="nvim"
  export EDITOR="nvim"
  export PSQL_EDITOR="nvim -c"set filetype=sql""
  export GIT_EDITOR="nvim"  # Use Neovim as default editor
else
  export EDITOR='vim'
  export PSQL_EDITOR='vim -c"set filetype=sql"'
  export GIT_EDITOR='vim'  # Fallback to Vim
fi

if [[ -e "$HOME/code/clones/lua-language-server/3rd/luamake/luamake" ]]; then
  alias luamake="$HOME/code/clones/lua-language-server/3rd/luamake/luamake"  # Lua language server setup
fi


# rustup
export PATH="$HOME/.cargo/bin:$PATH"  # Rust toolchain

# homebrew
export PATH="/usr/local/bin:$PATH"
export PATH="/opt/homebrew/opt/gnu-sed/libexec/gnubin:$PATH"  # GNU sed preference

# direnv
if type direnv &> /dev/null; then
  eval "$(direnv hook zsh)"  # Directory-specific environments
fi

# node.js
export NODE_PATH="/usr/local/lib/node_modules:$NODE_PATH"  # Node.js modules

# golang
export GOPATH="$HOME/code/go"
export GOBIN="$GOPATH/bin"
export PATH="$GOBIN:$PATH"  # Go development setup

# fzf
if type fzf &> /dev/null && type rg &> /dev/null; then
  export FZF_DEFAULT_COMMAND='rg --files --hidden --follow --glob "!.git/*" --glob "!vendor/*"'
  export FZF_CTRL_T_COMMAND='rg --files --hidden --follow --glob "!.git/*" --glob "!vendor/*"'
  export FZF_ALT_C_COMMAND="$FZF_DEFAULT_COMMAND"  # Fuzzy finder configuration
fi

# `z`
if [ -e /usr/local/etc/profile.d/z.sh ]; then
  source /usr/local/etc/profile.d/z.sh
fi

if [ -e /opt/homebrew/etc/profile.d/z.sh ]; then
  source /opt/homebrew/etc/profile.d/z.sh  # Directory jumper
fi

export PATH="$HOME/.yarn/bin:$HOME/.config/yarn/global/node_modules/.bin:$PATH"  # Yarn global packages

# Export my personal ~/bin as last one to have highest precedence
export PATH="$HOME/bin:$PATH"
export PATH=$HOME/.local/bin:$PATH  # Personal scripts

# Export Composer for Laravel
export PATH="$PATH:$HOME/.composer/vendor/bin"  # PHP Composer

# Zoxide
eval "$(zoxide init zsh)"  # Smart directory jumper

export PATH=$PATH:/home/deymos/.spicetify  # Spotify customization
export CLOUDSDK_PYTHON=/usr/bin/python3.11  # Google Cloud SDK Python

. "$HOME/.atuin/bin/env"
if type atuin &> /dev/null; then
  eval "$(atuin init zsh)"
fi
