function __git.default_branch -d "Resolve the repository's default branch"
  command git rev-parse --git-dir &>/dev/null; or return 1

  if set -l remote_default (command git symbolic-ref --quiet --short refs/remotes/origin/HEAD 2>/dev/null)
    string replace 'origin/' '' -- $remote_default
  else if set -l configured (command git config --get init.defaultBranch)
    echo $configured
  else if command git show-ref --quiet --verify refs/heads/main
    echo main
  else
    echo master
  end
end
