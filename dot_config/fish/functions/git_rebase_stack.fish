function git_rebase_stack -d "Rebase a branch stack onto its base and push it"
  argparse 'b/base=' 'd/dry-run' -- $argv
  or return 1

  set -l original_branch (__git.current_branch)
  test -n "$original_branch"; or begin
    echo "Not currently on a branch"
    return 1
  end

  set -l base $_flag_base
  if test (count $argv) -eq 0
    set argv (__git_rebase_stack.detect $original_branch)
    if test (count $argv) -eq 0
      echo "No open PR stack detected from $original_branch"
      return 1
    end

    if test -z "$base"
      set base (gh pr view $argv[1] --json baseRefName --jq .baseRefName 2>/dev/null)
    end
  end

  if test -z "$base"
    set base (__git.default_branch)
  end

  echo "Base: $base"
  echo "Stack: "(string join ' -> ' $argv)
  set -q _flag_dry_run; and return 0

  git fetch origin $base; or return 1

  for i in (seq (count $argv))
    set -l branch $argv[$i]
    set -l rebase_onto origin/$base
    if test $i -gt 1
      set rebase_onto $argv[(math $i - 1)]
    end

    echo "Rebasing $branch onto $rebase_onto"
    git switch $branch; or return 1
    git rebase $rebase_onto; or begin
      echo "Rebase stopped on $branch; resolve it or run git rebase --abort"
      return 1
    end
    git push --force-with-lease origin $branch; or return 1
  end

  git switch $original_branch
end

function __git_rebase_stack.detect -d "Detect the open PR stack containing a branch" -a branch
  set -l prs (gh pr list --author @me --state open \
    --json headRefName,baseRefName 2>/dev/null)
  or return 1

  set -l heads (echo $prs | jq -r '.[].headRefName')
  set -l bases (echo $prs | jq -r '.[].baseRefName')
  contains -- $branch $heads; or return 1

  set -l bottom $branch
  while true
    set -l index (contains -i -- $bottom $heads)
    set -l parent $bases[$index]
    contains -- $parent $heads; or break
    set bottom $parent
  end

  set -l stack $bottom
  set -l current $bottom
  while contains -- $current $bases
    set -l index (contains -i -- $current $bases)
    set current $heads[$index]
    set -a stack $current
  end

  printf '%s\n' $stack
end

complete -c git_rebase_stack -x -a "(git branch --format='%(refname:short)')"
complete -c git_rebase_stack -s b -l base -d "Base branch" -xa "(git branch --format='%(refname:short)')"
complete -c git_rebase_stack -s d -l dry-run -d "Show stack without changing it"
