---
description: Close out a branch after implementation by filling test gaps, refactoring comments, and handing off to code review
---

# Wrap Up

Run the post-implementation pass over the current branch: close test gaps, refactor added comments, lint, and hand off to `/code-review`.

Usage: `/wrap_up [review]`

$ARGUMENTS

Pass `review` to force the code review handoff even when this branch has already been handed off.

## Safety Rules

1. Reject immediately if the current branch is `main`.
2. Do not push.
3. Never fold "needs your decision" or "out of scope" findings into this branch. Report them and stop.
4. Skip a step only for the mechanical reasons below, and always report the skip.

## Review Marker

The command cannot observe whether `/code-review` actually ran, only that it handed off. A marker records the handoff.

- Path: `<git-dir>/wrap_up/<branch>`, where `<git-dir>` comes from `git rev-parse --git-dir` and `/` in the branch name becomes `-`.
- Contents: the HEAD SHA at the moment of handoff.
- The marker lives inside `.git`, so it never enters the working tree and never reaches a commit.

Mode selection:

- **Marker absent, or `$ARGUMENTS` is `review`:** handoff mode. Finish with the `/code-review` handoff and write the marker.
- **Marker present:** post-review mode. Skip the handoff and report the marker SHA instead.

On every run, delete markers whose branch no longer exists (`git branch --list <branch>` returns nothing) so they do not accumulate.

## Step Gates

Decide each gate mechanically. Do not judge whether a story "feels like" it needs a step.

- **`test_gap`:** run unless every changed file in the branch diff is documentation, configuration, or comment-only. Run it for refactors and removals too, since removed code leaves stale tests behind and the skill reviews branch-introduced tests. If the project has no test suite at all, skip and say so.
- **`comment_refactor`:** run only when the branch diff adds at least one comment line. Zero added comments, skip.
- **`/code-review` handoff:** governed by the marker, not by the diff. Never gated on the size or kind of change.

## Process

1. **Resolve branch and mode**
   - `git branch --show-current`. If it is `main`, stop and explain that wrap up needs a feature branch.
   - `git rev-parse --verify main`. If `main` does not exist, report and stop.
   - `git status --short`. If the working tree is dirty, ask whether to include those changes before proceeding, since later steps commit.
   - Read the marker to select handoff or post-review mode.

2. **Evaluate the gates**
   - `git diff main...HEAD --stat` for the changed-file gate.
   - `git diff main...HEAD --unified=0` for the added-comment gate.
   - Record the decision and reason for each step before running anything.

3. **Run `test_gap`** (if gated in)
   - Use the `test-gap` skill.
   - In post-review mode, pass `prioritize changes since <marker SHA>` as the focus so the second pass leads with the review fixes. The skill still diffs the whole branch against `main`.
   - Commit the result on its own with a `test:` subject.

4. **Run `comment_refactor`** (if gated in)
   - Use the `comment_refactor` skill with no argument so it covers the whole branch.
   - Commit the result on its own with a `docs:` subject.

5. **Lint**
   - Run the project's linter with auto-fix.
   - If it changed files, commit them separately with the message `Auto-format and lint fixes`.

6. **Run the test suite**
   - Run the project's tests. Report failures with the actual output. Do not describe a failing branch as finished.

7. **Report**
   - Print one line per step: `ran` with a one-line result, or `skipped` with the gate that caused it.
   - In handoff mode, write the marker with the current HEAD SHA and tell the user to run `/code-review`, then feed the findings back through the triage rule in `opencode/AGENTS.md`.
   - In post-review mode, print `code-review: skipped, handed off at <sha> (<n> commits ago)`. State it as a fact, do not ask the user to act on it.
   - If both steps made no changes, the linter made no changes, and the tests pass, say the branch is clean and point the user at `/issue_pr`.

## Ordering

`comment_refactor` runs after `test_gap` so it also covers comments the new tests introduced.

In handoff mode it runs before the review rather than after it, which means review fixes land with unrefactored comments. The post-review run closes that gap: it re-runs `comment_refactor` over the whole branch, including the review fixes. This is why re-running `/wrap_up` after `/code-review` matters, and why a branch is not finished until a post-review run comes back clean.
