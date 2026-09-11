---
name: test-gap
description: Close behavioral test gaps on the current branch and review added or modified tests. Use when asked to find or fill missing test coverage.
---

# Test Gap

Close the coverage gaps the branch left, then hold every branch-introduced test to the bar in [`REVIEW.md`](REVIEW.md). This skill edits tests, runs the suite, and commits. The optional argument is a focus; use it to prioritize which changes to test while still running the full workflow.

## Workflow

1. Scope the branch and build the local pattern baseline.
   - Compare against the merge base with the upstream default branch. If the default branch cannot be determined, use the branch point or ask one concise question.
   - If the working tree is dirty, stop and ask whether to include those changes, since later steps commit.
   - Build the baseline: read nearby existing tests for the same feature, layer, framework, or file naming convention, and note assertion style, setup style, fixture/factory usage, helper usage, mocking style, test naming, test structure, file placement, and execution scope.
   - Completion criterion: every added, modified, or removed file in the branch is split into source and test files, and each reviewed test has a concrete local baseline that cites a specific nearby test.

2. Understand what changed.
   - Completion criterion: every added, modified, or removed behavior in non-test files is listed. Removed behavior counts because it leaves stale tests behind.

3. Identify test gaps.
   - Pick gaps by the Behavioral value and Redundancy rules in [`REVIEW.md`](REVIEW.md).
   - Completion criterion: every listed behavior resolves to covered, test to add, or omitted by choice. Omissions go to `Residual risks`.
   - If every behavior is covered, record `no gaps` and go to step 5.

4. Write the missing tests.
   - Match the baseline; a new pattern needs a Pattern fit justification. With no local precedent, use the framework's documented default and record that under `Residual risks`.
   - Cover happy paths and probable failures first.
   - Extend existing tests rather than duplicating them.
   - Completion criterion: every gap from step 3 has a test.

5. Review every branch-introduced test against [`REVIEW.md`](REVIEW.md). The tests from step 4 get the rubric first.
   - Completion criterion: every branch-introduced test carries a verdict backed by a concrete local baseline.

6. Apply every verdict from step 5, including deletions and rewrites of tests the branch already had.
   - Completion criterion: every verdict applied.

7. Validate.
   - Run the project's test suite.
   - Failures caused by this run's changes are yours to fix with the behavioral assertions intact. Pre-existing or environmental failures go in the report.
   - Commit the test changes as a single commit.

## Status

Report what landed, the verdicts applied, and the suite result:

- `Tests added`: what behavior is now covered.
- `Tests revised`: what was rewritten, merged, moved, or deleted, and why.
- `No gaps found`: existing tests already cover the branch changes.
- `Issues remain`: what still needs attention, including failures left unfixed.

Close every run with `Residual risks`: what this run could still be wrong about, such as behavior omitted by choice, a baseline read from thin or absent local precedent, or a verdict that was a close call. A run that found nothing owes this section the most.
