---
name: jj
description: JJ workflow and commit conventions. Use when working in a Jujutsu (`jj`) repository, making a commit, shaping a JJ change stack, resolving JJ conflicts, or pushing JJ bookmarks.
---

Treat JJ changes as mutable working-copy commits. Shape them with `describe`, `new`, `edit`, `split`, and `squash`; a commit request normally means describing the intended JJ change, not staging files for `git commit`.

## Working loop

1. Establish stack context with `jj st`, `jj d`, and usually `jj ls` (`jj log --summary`). Use `jj lp` for the full patch.
   **Done when:** the working-copy change, its parents/children, and any conflicts are known.
2. Put work in the right change.
   - Name the current change: `jj describe -m "..."`.
   - Start follow-up work: `jj new -m "..."`.
   - Insert a predecessor: `jj new -B @ -m "..."`.
   - Move to a specific change: `jj edit <rev>`.
   - Reshape work: `jj squash`, `jj squash --interactive` (`jj si`), or `jj split`.
   **Done when:** each intended patch belongs to its intended, meaningfully described change.
3. Re-inspect with `jj d` or `jj lp` and `jj ls` after stack-changing operations.
   **Done when:** the resulting patches and stack order match the intended history.

## Commit requests

Use a Conventional Commits-style description:

```text
<type>(<scope>): <summary>
```

- Choose `feat` for a feature and `fix` for a bug fix; use `docs`, `refactor`, `chore`, `test`, or `perf` when appropriate.
- Keep `scope` optional and brief (for example, `api`, `parser`, or `ui`).
- Make the summary imperative, concise, at most 72 characters, and free of a trailing period.
- Add a body only when it clarifies the change. Separate it from the subject with a blank line and use short paragraphs.
- Use descriptions without breaking-change footers or sign-offs.

For every commit request:

1. Read the request for file paths/globs and commit guidance. Apply guidance to the type, scope, summary, and body.
2. Review the requested patch with `jj st` and `jj d` (or `jj lp`). When the requested files are ambiguous, ask which changes belong in the commit.
3. If paths/globs select only part of the working-copy change, isolate them with `jj split <fileset> -m "<subject>"`; use `jj split -i` when selection is by hunk. If the whole change is intended, use `jj describe -m "<subject>"`.
4. Verify the described change with `jj lp` and `jj ls`.
   **Done when:** exactly the intended patch is one described JJ change with a valid Conventional Commit description.

A commit request ends after local change shaping and verification. Push a bookmark only when separately requested.

## Local conventions

- Commits use `deymosxdeymos <galinnichola15@gmail.com>` as the configured identity.
- `jj ..` and `jj ,,` move to `@-` and `@+`.
- `jj a` abandons a scratch change; `jj u` undoes the latest JJ operation.
- `jj res` resolves conflicts; `jj resa` (`jj resolve-ast`) uses mergiraf for structured code conflicts.
- Conflict markers use JJ's `snapshot` style. Inspect and resolve them through `jj st`, `jj d`, and `jj res`, then verify with `jj lp` and `jj ls`.
- `jj git fetch` fetches `origin` and `upstream`; `jj git push` pushes to `origin`.

## Sharing

- Create a new PR bookmark from the working-copy change: `jj git push -c @`.
- Update an existing one: `jj bookmark set <bookmark>` followed by `jj git push`.
- Check bookmark placement with `jj ls` before pushing.
- Preserve shared history: ask before moving a bookmark backwards or rewriting a shared change unless the user explicitly requested it.
