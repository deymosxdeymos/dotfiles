# Version Control

Use `jj` for version-control operations. Do not use `git` commands.

Before running `jj` in a repository, load the `jj` skill and follow its guidance.

Common substitutions:

- Use `jj status` instead of `git status`.
- Use `jj diff` instead of `git diff`.
- Use `jj log` instead of `git log`.
- Use `jj describe` instead of `git commit`.
- Use `jj git push` only when the user explicitly asks to push.

If a task appears to require a Git operation that has no obvious `jj` equivalent, ask the user before running any VCS command.
