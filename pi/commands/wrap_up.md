---
description: Close out a branch after implementation by filling test gaps, reviewing against standards and spec, refactoring comments, and linting
---

# Wrap Up

Run the post-implementation pass over the current branch: close test gaps, review the branch with the `code-review` skill, apply the findings that are safe to apply, refactor added comments, lint, and run the tests.

Usage: `/wrap_up [spec]`

$ARGUMENTS

The optional argument is the spec the branch implements: an issue reference such as `#99`, a URL, or a file path. It is handed to the `code-review` skill as the spec source. Without it, the skill looks for issue references in the commit messages and falls back to asking.

## Safety Rules

1. Reject immediately if the current branch is `main`.
2. Do not push.
3. Skip a step only for the mechanical reasons below, and always report the skip.

## Review Findings

Sort every finding from the code review into one of three buckets and act on only the first.

- **Fix now:** a defect in code the current branch touched, where the correct fix is unambiguous and small enough to review in one commit. Fix it.
- **Needs your decision:** the fix requires a product, API, or architecture choice, or it contradicts the plan the branch is implementing. Present the options and the tradeoff. Do not pick one.
- **Out of scope:** a pre-existing issue, or a fix that would grow the branch beyond its plan. List it and offer to open a ticket. Do not fix it.

Never fold a "needs your decision" or "out of scope" finding into the branch. Hold both buckets for the report in step 9, and surface them there as explicit lists rather than burying them in a summary.

## Step Gates

Decide each gate mechanically. Do not judge whether a story "feels like" it needs a step.

- **`test-gap`:** run unless every changed file in the branch diff is documentation, configuration, or comment-only. Run it for refactors and removals too, since removed code leaves stale tests behind and the skill reviews branch-introduced tests. If the project has no test suite at all, skip and say so.
- **`code-review`:** always run. Never gated on the size or kind of change.
- **`comment-refactor`:** run only when the branch diff adds at least one comment line. Evaluate this gate after the review fixes have landed, since those fixes can add comments. Zero added comments, skip.

## Process

1. **Resolve the branch**
   - `git branch --show-current`. If it is `main`, stop and explain that wrap up needs a feature branch.
   - `git rev-parse --verify main`. If `main` does not exist, report and stop.
   - `git status --short`. If the working tree is dirty, ask whether to include those changes before proceeding, since later steps commit.

2. **Evaluate the `test-gap` gate**
   - `git diff main...HEAD --stat` for the changed-file gate.
   - Record the decision and reason before running anything.

3. **Run `test-gap`** (if gated in)
   - Use the `test-gap` skill.
   - Commit the result on its own with a `test:` subject.

4. **Run `code-review`**
   - Use the `code-review` skill with `main` as the fixed point, so it reviews `git diff main...HEAD`.
   - Pass the spec argument from above if one was given.
   - Sort every finding through the Review Findings rule above.
   - Apply the "fix now" findings and commit them on their own with a `fix:` or `refactor:` subject. Hold the other two buckets for the report.

5. **Evaluate the `comment-refactor` gate**
   - `git diff main...HEAD --unified=0` for the added-comment gate. Record the decision and reason.

6. **Run `comment-refactor`** (if gated in)
   - Use the `comment-refactor` skill with no argument so it covers the whole branch, including comments the new tests and review fixes introduced.
   - Commit the result on its own with a `docs:` subject.

7. **Lint**
   - Run the project's linter with auto-fix.
   - If it changed files, commit them separately with the message `Auto-format and lint fixes`.

8. **Run the test suite**
   - Run the project's tests. Report failures with the actual output. Do not describe a failing branch as finished.

9. **Report**
   - Print one line per step: `ran` with a one-line result, or `skipped` with the gate that caused it.
   - List the "needs your decision" and "out of scope" findings from step 4 as two explicit lists, then stop for an answer. Do not act on them.
   - If no step made changes, the linter made no changes, the tests pass, and both finding lists are empty, say the branch is clean and point the user at `/issue_pr`.

## Ordering

`code-review` runs after `test-gap` so the review sees the final tests, and `comment-refactor` runs after both so it covers every comment the branch adds in one pass, including those from the review fixes. Lint runs last so it formats everything the earlier steps wrote.
