---
name: test-gap
description: Find and fill valuable missing tests for the current branch, then review every branch-introduced test and fix what does not earn its place. Use when the user asks for test gaps, missing coverage, or `/test_gap`.
---

# Test Gap

Close the coverage gaps the branch left, then hold every branch-introduced test to the bar in [`REVIEW.md`](REVIEW.md). This skill edits tests, runs the suite, and commits.

## Workflow

1. Scope the branch and build the local pattern baseline, following the `Scope` section of [`REVIEW.md`](REVIEW.md).
   - The baseline serves both jobs ahead: it is the convention new tests must follow and the yardstick the review measures against.

2. Understand what changed.
   - Identify new functions, methods, classes, or modules added.
   - Identify modified logic, branching, or edge cases.
   - Note any changed public APIs or interfaces.
   - If the user provided a focus, use it to prioritize which changes to test.
   - Completion criterion: every added or modified non-test file is accounted for.

3. Identify test gaps.
   - Compare what the branch changed against what existing tests cover.
   - Flag new behavior with no tests, modified branches with no updated assertions, probable failures, and important error handling that are untested.
   - Prefer gaps tied to user-visible behavior, public API contracts, domain invariants, integration boundaries, or important side effects.
   - Treat a technical branch, private helper path, copied constant, or improbable micro-edge case as already covered.
   - If coverage is already comprehensive, record `no gaps` and go to step 5.

4. Write the missing tests.
   - Follow the baseline exactly: file naming, directory structure, imports, assertion style, helpers, setup, naming, and grouping.
   - Write focused, descriptive test names that explain the behavior being verified.
   - Cover happy paths and probable failures first.
   - Add edge cases only when they represent real user behavior, historically buggy behavior, security or data-loss risk, integration boundaries, or domain rules.
   - Extend existing tests rather than duplicating them.

5. Review every branch-introduced test against [`REVIEW.md`](REVIEW.md) — the tests you just wrote and the tests the branch already had, judged the same way.
   - Reviewing your own work is the weak link in this skill: the tests from step 4 get the rubric first and hardest, and having authored one is no evidence it earns its place.
   - Completion criterion: every branch-introduced test carries a verdict backed by a concrete local baseline.

6. Apply every verdict from step 5, including deletions and rewrites of tests the branch already had.
   - Completion criterion: no test is left on a non-`keep` verdict.

7. Validate.
   - Run the project's test suite to confirm all new and existing tests pass.
   - If any tests fail, fix them and re-run until green.
   - Commit the test changes as a single commit.

## Formatting

Always use backticks for code elements: class names, functions, file paths, commands, config keys.

## Status

Report what landed, the verdicts applied, and the suite result:

- `Tests added`: what behavior is now covered.
- `Tests revised`: what was rewritten, merged, moved, or deleted, and why.
- `No gaps found`: existing tests already cover the branch changes.
- `Issues remain`: what still needs attention.
