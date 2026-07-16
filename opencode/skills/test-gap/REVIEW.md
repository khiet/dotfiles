# Test Review Reference

Shared reference for judging branch-introduced tests. Read by [`test-gap`](SKILL.md), which fixes what it finds, and by `verify-tests`, which reports without editing. This file holds the judgment criteria only; each skill sets its own edit policy.

## Scope

1. Establish the comparison range.
   - Prefer the merge base with the upstream default branch.
   - If the default branch cannot be determined, use the branch point or ask one concise question.
   - Completion criterion: every added or modified file in the branch is identified and split into source files and test files.

2. Build the local pattern baseline.
   - Read nearby existing tests for the same feature, layer, framework, or file naming convention.
   - Note assertion style, setup style, fixture/factory usage, helper usage, mocking style, test naming, test structure, file placement, and execution scope.
   - Completion criterion: each reviewed test has a concrete local baseline, not a generic testing preference.

## Pattern fit

- Classify every new or changed test pattern as existing, justified new, or suspicious new.
- A pattern is suspicious when existing tests solve the same problem with established helpers, factories, matchers, or seams, or when nearby tests already provide a naming and structure convention this test departs from.
- A pattern is justified when the branch introduces a genuinely new seam, integration boundary, domain concept, or test framework capability.

## Behavioral value

- Tie each test to a user-visible behavior, public API contract, domain invariant, or important side effect changed by the branch.
- A test is strong when it would fail for a real behavior regression and survive an internal refactor.
- A test is weak when it freezes implementation details, private methods, internal collaborator choreography, framework behavior, or constants copied from the implementation.
- Completion criterion: every test has a clear reason to exist, or carries a verdict.

## Redundancy and probability

- Flag tests already covered by an equivalent existing test at the same or stronger seam.
- Flag micro-edge cases that are technically possible but not probable enough to justify ongoing maintenance.
- Keep edge cases that represent real user behavior, historically buggy behavior, security or data-loss risk, integration boundaries, or domain rules.
- Completion criterion: every flagged redundancy or edge case includes why it is low value in this codebase.

## Verdicts

Every branch-introduced test lands on one:

- `keep`: earns its place as written.
- `rewrite`: right behavior, wrong pattern or wrong assertions.
- `move`: right behavior, wrong seam.
- `merge`: duplicates another test; fold them together.
- `delete`: redundant, implementation-coupled, or improbable enough that maintenance outweighs signal.
