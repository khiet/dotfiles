---
description: Implement a GitHub or Linear issue, wrap up the branch, and open a draft PR
argument-hint: "<issue-ref> [instructions]"
---

Implement issue `$1`. Additional instructions, if provided: `${@:2}`

## Issue reference

The shape of the reference picks the tracker:

- A bare number, `#N`, or a github.com issue URL is a GitHub issue in the current repository. Read it with `gh issue view`.
- A Linear key in either case, such as `ABC-123` or `abc-123`, or a linear.app URL is a Linear issue. Read it with the Linear tools.

Put the reference in every commit message footer (`Closes #N` for GitHub, `Fixes ABC-123` for Linear) so wrap-up, code review, and the PR description can find the spec.

## Steps

1. Read the issue, then check out its branch before changing any file. The branch checked out now, worktree or not, is a candidate to replace.
   - Name the branch: Linear's `gitBranchName` verbatim for a Linear issue; `<type>/<issue-number>-<short-slug>` for a GitHub issue, with `<type>` the Conventional Commits type the work fits.
   - Stop if `git status --short` shows a dirty tree. Run `git fetch origin`; `origin/main` is the base.
   - Act on the first case that matches:
     - **The named branch exists** locally or on `origin`: ask whether to continue on it or reset it to `origin/main`, then check it out.
     - **On `main`**: `git switch -c <name> origin/main --no-track`.
     - **No commits ahead of `origin/main`** (a fresh worktree branch): `git branch -m <name>` and `git reset --hard origin/main`, so the worktree keeps its checkout.
     - **Commits ahead of `origin/main`**: stop and ask; the branch holds unrelated work.
   - For a GitHub issue, link the branch with `gh issue develop <issue-number> --name <name> --base main`, unless `gh issue develop --list <issue-number>` already shows it. This creates the link only; the local branch is already checked out.
   - Done when `git branch --show-current` prints the named branch and its base is `origin/main`.
2. Pick the seams to test at from the issue. Use /tdd at those seams.
3. Typecheck and run the touched test file after each change. Implementation is complete when every acceptance criterion in the issue has a passing test and the full suite is green. A removal is the exception: the compiler enforces it, so test what the removal changed in surviving behavior instead, and keep an absence assertion only for a contract the product still requires.
4. Commit to the branch.
5. Run `/wrap_up $1`. It sorts review findings itself; carry its "needs your decision" and "out of scope" lists into your final report unchanged.
6. If the "needs your decision" list is empty and wrap-up reports the tests passing, open the PR. An "out of scope" list alone still opens the PR. Otherwise stop and present the "needs your decision" list.
   - Run `git fetch origin`, then write the PR body with the `pr` skill, from the diff against `origin/main` and the issue, and save it to a temp file. GitHub diffs against `origin/main`, so a stale local `main` would misdescribe the PR.
   - Push the branch.
   - If `gh pr view` finds no PR, run `gh pr create --draft --title "<Conventional Commits title summarizing the branch>" --body-file <file>`. If a PR exists, print the body and confirm before running `gh pr edit --body-file`, so manual edits survive.
   - Run `open <PR-URL>`.
