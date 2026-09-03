---
description: Implement a GitHub or Linear issue, wrap up the branch, and open a draft PR
argument-hint: "<issue-ref> [instructions]"
---

Implement issue `$1`. Additional instructions, if provided: `${@:2}`

## Issue reference

The shape of the reference picks the tracker:

- A bare number, `#N`, or a github.com issue URL is a GitHub issue in the current repository. Read it with `gh issue view`.
- A Linear key such as `ABC-123` or a linear.app URL is a Linear issue. Read it with the Linear tools.

Put the reference in every commit message footer (`Closes #N` for GitHub, `Fixes ABC-123` for Linear) so wrap-up, code review, and the PR description can find the spec.

## Steps

1. If the current branch is `main`, create a branch named from the issue: Linear's suggested branch name for a Linear issue, `<type>/<issue-number>-<short-slug>` for a GitHub issue.
2. Read the issue and pick the seams to test at. Use /tdd at those seams.
3. Typecheck and run the touched test file after each change. Implementation is complete when every acceptance criterion in the issue has a passing test and the full suite is green.
4. Commit to the branch.
5. Run `/wrap_up $1`. It sorts review findings itself; carry its "needs your decision" and "out of scope" lists into your final report unchanged.
6. If the "needs your decision" list is empty and wrap-up reports the tests passing, run `/issue_pr`, then `open <PR-URL>` with the URL it returns. An "out of scope" list alone still opens the PR. Otherwise stop and present the "needs your decision" list.
