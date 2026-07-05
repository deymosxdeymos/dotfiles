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

# SSH / mosh (converted from nix ssh-client-desktop module)
alias mosh = mosh --no-init

def te [path: path = "."] {
  ^setsid --fork the-editor $path out> /dev/null err> /dev/null
}

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

# JJ aliases
alias jjj = jj
alias j = jj

alias cl = claude-slop
alias cy = codex --yolo

def --env y [...args] {
	let tmp = (mktemp -t "yazi-cwd.XXXXXX")
	^yazi ...$args --cwd-file $tmp
	let cwd = (open $tmp)
	if $cwd != $env.PWD and ($cwd | path exists) {
		cd $cwd
	}
	rm -fp $tmp
}
