---
description: Close out a branch after implementation
argument-hint: "[issue-ref]"
---

# Wrap Up

Run the post-implementation pass over the current branch, then lint the whole branch once at the end with auto-fix.

Issue reference, if provided: `$1`

## Review Findings

A finding is one reported problem with a location in the diff and the claim made about it. Treat each item the review reports as one finding however the review groups them (by axis, file, or severity). Sort every finding into one of three buckets. Steps 5, 11, and 12 consume them.

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

4. **Resolve the spec**
   - The issue is `$1` when given, otherwise the reference in the branch's commit footers. Read it from its tracker.
   - Record `no spec` when there is none. The review still runs and reports the missing spec itself.

5. **Run `code-review`**
   - Use the `code-review` skill with `main` as the fixed point. Hand it the fetched issue contents as the spec so it does not go looking for one.
   - Sort every finding through Review Findings. Apply only the "fix now" findings and commit them on their own with a `fix:` or `refactor:` subject. Hold the other two buckets for step 12.

6. **Evaluate the `comment-refactor` gate**
   - `git diff main...HEAD --unified=0`. Run when the diff adds, modifies, or removes at least one comment line. Record the decision and reason.

7. **Run `comment-refactor`** (if gated in)
   - Use the `comment-refactor` skill. Its commit carries a `docs:` subject.

8. **Lint**
   - Run the project's linter with auto-fix. Commit anything it changed with a `style:` subject.

9. **Run the test suite**
   - Run the project's tests, or record `skipped` when the project has no test suite. Report failures with the actual output.

10. **Evaluate the `smoke-test` gate**
    - Run when step 9 passed (or was skipped for lack of a suite) and at least one changed path renders UI, as step 1 of the `smoke-test` skill defines UI. Record the decision and reason; a failed suite is a skip with that gate.

11. **Run `smoke-test`** (if gated in)
    - Use the `smoke-test` skill.
    - Sort its `Failed` findings through Review Findings. Apply only the "fix now" findings, commit them on their own with a `fix:` subject, then re-run step 8's linter and step 9's suite once. Hold the other two buckets for step 12.

12. **Report**
    - Print one line per step: `ran` with a one-line result, or `skipped` with the gate that caused it. The smoke line names the screenshot dir so `/pr_screenshots` can find it.
    - State the suite result on its own line, from the latest run: step 9, or the step 11 re-run when a smoke fix landed.
    - List the "needs your decision" findings, then the "out of scope" findings as a plain list. A non-empty decision list stops the run for an answer.
    - The branch is finished when the suite passes and the decision list is empty. Say so.

## Ordering

`code-review` runs after `test-gap` so the review sees the final tests, and `comment-refactor` runs after both so it covers every comment the branch changes in one pass, including those from the review fixes. Lint runs last to catch anything the earlier steps wrote. `smoke-test` runs after the suite so a browser session is only spent on a green branch, and after lint so it drives the code that ships; a smoke fix re-runs lint and the suite once, so every result in the report comes from the commit that ships.
