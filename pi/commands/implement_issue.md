---
description: Implement a GitHub issue, wrap up the branch, and open a draft PR
argument-hint: "<issue-ref> [instructions]"
---

Implement GitHub issue `$1`. Treat a bare number as an issue number in the current repository.

Additional instructions, if provided: `${@:2}`

Use /tdd where possible, at pre-agreed seams. Run typechecking regularly, single test files regularly, and the full test suite once at the end. Use /code-review to review the work, then commit to the current branch.

When implementation is complete, run `/wrap_up $1`.

For decisions raised by code review or wrap-up, use your recommended approach by default. Ask me only when my input is genuinely required or the decision involves a meaningful product, API, architecture, scope, risk, or other tradeoff.

If no decision requires my input and the branch is ready for a PR, run `/issue_pr`, then run `open <PR-URL>` with the PR URL it returns.
