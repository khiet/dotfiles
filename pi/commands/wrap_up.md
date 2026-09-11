---
description: Close out a branch after implementation
argument-hint: "[spec]"
---

# Wrap Up

Run the post-implementation pass over the current branch, linting every commit it makes with auto-fix first.

$ARGUMENTS

The optional argument is the spec the branch implements: an issue reference such as `#99` or `ABC-123`, a URL, or a file path. Hand it to the `code-review` skill as the spec source.

## Review Findings

Sort every finding from the code review into one of three buckets. Steps 4 and 9 consume them.

- **Fix now:** a defect in code the current branch touched, where the correct fix is unambiguous and small enough to review in one commit.
- **Needs your decision:** the fix requires a product, API, or architecture choice, or it contradicts the plan the branch is implementing. Present it as a numbered question with lettered options carrying a one-clause trade-off each, two to four options including "leave as is" when viable, exactly one marked `(Recommended)`.
- **Out of scope:** a pre-existing issue, or a fix that would grow the branch beyond its plan. List it and offer to open a ticket.

## Process

Do not push. Decide each gate from the diff and report every skip with its gate.

1. **Resolve the branch**
   - `git branch --show-current`. Stop if it prints `main` or nothing (detached HEAD): wrap up needs a feature branch.
   - `git rev-parse --verify main`. Stop if `main` does not exist.
   - `git diff main...HEAD --stat`. Stop if it is empty.
   - `git status --short`. Stop if the working tree is dirty: wrap up needs a committed branch, since later steps commit.

2. **Evaluate the `test-gap` gate**
   - Run unless every changed path in the step 1 diff is documentation, or the project has no test suite. Refactors and removals run too, since removed code leaves stale tests behind and the skill reviews branch-introduced tests.
   - Record the decision and reason before running anything.

3. **Run `test-gap`** (if gated in)
   - Use the `test-gap` skill. Its commit carries a `test:` subject.

4. **Run `code-review`**
   - Use the `code-review` skill with `main` as the fixed point and the spec argument from above if one was given.
   - Sort every finding through Review Findings. Apply only the "fix now" findings and commit them on their own with a `fix:` or `refactor:` subject. Hold the other two buckets for step 9.

5. **Evaluate the `comment-refactor` gate**
   - `git diff main...HEAD --unified=0`. Run when the diff adds, modifies, or removes at least one comment line. Record the decision and reason.

6. **Run `comment-refactor`** (if gated in)
   - Use the `comment-refactor` skill with `main` as the base ref.
   - Commit the result on its own with a `docs:` subject.

7. **Lint**
   - Run the project's linter with auto-fix. Commit anything it changed with a `style:` subject.

8. **Run the test suite**
   - Run the project's tests, or record `skipped` when the project has no test suite. Report failures with the actual output.

9. **Report**
   - Print one line per step: `ran` with a one-line result, or `skipped` with the gate that caused it.
   - List the "needs your decision" findings, then the "out of scope" findings as a plain list. A non-empty decision list stops the run for an answer.
   - The branch is finished when the suite passes and the decision list is empty. Say so and point the user at `/issue_pr`.

## Ordering

`code-review` runs after `test-gap` so the review sees the final tests, and `comment-refactor` runs after both so it covers every comment the branch changes in one pass, including those from the review fixes. Lint runs last to catch anything the earlier steps wrote.
