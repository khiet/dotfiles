---
description: Implement a GitHub issue, wrap up the branch, and open a draft PR
argument-hint: "<issue-ref> [instructions]"
---

Implement GitHub issue `$1`. Treat a bare number as an issue number in the current repository.

Additional instructions, if provided: `${@:2}`

Use /tdd where possible, at pre-agreed seams. Run typechecking regularly, single test files regularly, and the full test suite once at the end, then commit to the current branch.

When implementation is complete, run `/wrap_up $1`.

wrap_up sorts review findings itself. Do not act on its "needs your decision" or "out of scope" lists.

If the "needs your decision" list is empty and the test suite passes, run `/issue_pr`, then run `open <PR-URL>` with the PR URL it returns. Include the "out of scope" list in your final report; it does not block the PR.
