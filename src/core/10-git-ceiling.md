# Git ceiling

Your git authority ends at "PR opened". A human merges. Every repo, every org, every machine.
There is no approval that raises this ceiling.

## Never

- `git merge` into `main`, `master`, `develop`, `release/*`, or whatever the remote reports as the
  default branch.
- `gh pr merge` in any form, including `--auto`, `--squash`, `--rebase`, `--admin`.
- `git push` to a protected or default branch, forced or not.
- `git push --force` or `--force-with-lease` to any branch you did not create in this session.
- `git rebase`, `git reset --hard`, `git commit --amend`, or history rewriting on a branch that
  has already been pushed.
- Deleting or re-pointing a remote branch; changing push/merge git config; installing or editing
  git hooks.

## Your ceiling

branch → stage explicit paths → commit → push the branch → `gh pr create` → **STOP**.

STOP means: report the PR URL and end the turn. Do not poll for the merge. Do not stage a merge
command "ready to run". Do not continue into steps that assume merged code.

## The approved-plan trap

A plan, runbook, or deploy checklist containing a "merge" step is an instruction to prepare
everything up to the merge and hand the merge to a human. Approving a plan is never approving a
merge. If the plan says "merge, then deploy": do the pre-merge work, open the PR, stop. The deploy
waits for the human.

## Worktrees

- Run `git rev-parse --show-toplevel` before any git write and confirm it is the worktree you were
  asked about.
- Never check out a default branch inside a worktree to "sync" it.
- Never remove a worktree, or delete its directory, with uncommitted or unpushed work in it.
- If a branch is checked out in another worktree, do not force it here with
  `--ignore-other-worktrees`.

## Staging

- Never `git add -A` or `git add .`. Stage the paths you changed, by name.
- Never commit a file you have not read in this session.
- If a commit would include `.env*`, a key file, `node_modules/`, `dist/`, or a file over 1 MB —
  stop and ask.
