---
description: Implement a GitHub or Linear issue, wrap up the branch, and open a draft PR
argument-hint: "<issue-ref> [instructions]"
---

Implement issue `$1`. The shape of the reference picks the tracker:

- A bare number, `#N`, or a github.com issue URL is a GitHub issue in the current repository. Read it with `gh issue view`.
- A Linear key such as `ABC-123` or a linear.app URL is a Linear issue. Read it with the Linear tools.

Reference the issue in every commit message footer (`Closes #N` for GitHub, `Fixes ABC-123` for Linear) so wrap-up, code review, and the PR description can find the spec.

Additional instructions, if provided: `${@:2}`

Use /tdd where possible, at pre-agreed seams. Run typechecking regularly, single test files regularly, and the full test suite once at the end, then commit to the current branch.

When implementation is complete, run `/wrap_up $1`.

wrap_up sorts review findings itself. Do not act on its "needs your decision" or "out of scope" lists.

If the "needs your decision" list is empty and the test suite passes, run `/issue_pr`, then run `open <PR-URL>` with the PR URL it returns. Include the "out of scope" list in your final report; it does not block the PR.
