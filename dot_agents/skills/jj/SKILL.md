---
name: jj
description: Read this skill before using jj in a repository
---

Use JJ-native workflows when working in a `jj` repo. Prefer `describe`, `new`, `edit`, and `squash` over Git-style staging mental models.

## Local conventions

- User identity: `deymosxdeymos <galinnichola15@gmail.com>`.
- Useful aliases:
  - `jj a` = `abandon`
  - `jj c` = `commit`
  - `jj ci` = `commit --interactive`
  - `jj d` = `diff`
  - `jj e` = `edit`
  - `jj l` = `log`
  - `jj ls` = `log --summary`
  - `jj lp` = `log --patch`
  - `jj r` = `rebase`
  - `jj res` = `resolve`
  - `jj resa` / `jj resolve-ast` = `resolve --tool mergiraf`
  - `jj s` / `jj si` = `squash` / `squash --interactive`
  - `jj t` / `jj tug` = move the nearest pushable bookmark forward
  - `jj u` = `undo`
  - `jj ..` / `jj ,,` = `edit @-` / `edit @+`
- Revset aliases:
  - `closest(to)` = `heads(::to & bookmarks())`
  - `closest_pushable(to)` = `heads(::to & ~description(exact:"") & (~empty() | merges()))`
- `jj git fetch` fetches from both `origin` and `upstream`.
- `jj git push` defaults to `origin`.
- Default log revset:
  - `present(@) | present(trunk()) | ancestors(remote_bookmarks().. | @.., 8)`
- UI defaults that matter:
  - builtin diff editor
  - `difft` as diff formatter
  - `snapshot` conflict markers
  - curved graph style

## Preferred habits

- Prefer `jj ls` for quick stack context.
- Prefer `jj lp` when reviewing the actual patch.
- Prefer `jj ..` and `jj ,,` for stack navigation.
- Prefer `jj describe`, `jj new`, `jj squash`, and `jj edit` over `jj commit` unless the user explicitly wants commit-style flows.

## Workflow

1. Inspect with `jj st`, `jj d`, and usually `jj ls`.
2. If the current change should hold the work, use `jj describe -m "..."`.
3. If starting follow-up work, use `jj new -m "..."`.
4. If a new change must come before the current one, use `jj new -B @ -m "..."`.
5. Shape changes with `jj squash`, `jj si`, and `jj e <rev>`.
6. Use `jj a` to discard scratch changes and `jj u` to undo the last JJ operation.

## Conflicts

- Start with `jj st`, `jj d`, and usually `jj ls`.
- Default flow: `jj res`.
- Prefer `jj resa` when `mergiraf` should help with structured code conflicts.
- Because conflict markers are `snapshot` style, do not assume Git-style `<<<<<<<` markers.
- After resolving, re-check with `jj st`, then `jj lp` or `jj d`, then `jj ls`.

## Sharing

- New PR/bookmark from current change: `jj git push -c @`.
- Existing PR/bookmark: `jj bookmark set <bookmark>` then `jj git push`.
- Verify bookmark placement with `jj ls` or `jj l` before pushing.
- Confirm before moving bookmarks backwards or rewriting shared history unless the user explicitly asked.
