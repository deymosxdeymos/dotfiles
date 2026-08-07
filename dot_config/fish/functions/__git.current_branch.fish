function __git.current_branch -d "Print the current Git branch"
  command git branch --show-current 2>/dev/null
end
