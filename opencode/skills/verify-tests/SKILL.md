---
name: verify-tests
description: Review tests introduced on the current branch for project-pattern fit, behavioral value, redundancy, and over-specific improbable edge-case coverage.
---

# Verify Tests

Review only. Do not edit tests unless the user explicitly asks for fixes after the review.

## Goal

Judge whether branch-introduced tests are worth keeping as written:

- They follow existing local test patterns.
- They verify behavior through the right public seam.
- They cover probable happy paths and likely failures.
- They avoid redundant, implementation-coupled, or improbable edge-case coverage.

## Workflow

1. Establish the comparison range.
   - Prefer the merge base with the upstream default branch.
   - If the default branch cannot be determined, use the branch point or ask one concise question.
   - Completion criterion: every added or modified test file in the branch is identified.

2. Build the local pattern baseline.
   - Read nearby existing tests for the same feature, layer, framework, or file naming convention.
   - Note assertion style, setup style, fixture/factory usage, helper usage, mocking style, test naming, file placement, and execution scope.
   - Completion criterion: each reviewed test has a concrete local baseline, not a generic testing preference.

3. Review introduced tests against the baseline.
   - Flag any new pattern introduced by the branch, even if it seems reasonable.
   - Distinguish necessary new patterns from accidental novelty.
   - Completion criterion: every new or changed test pattern is classified as existing, justified new, or suspicious new.

4. Review behavioral value.
   - Tie each test to a user-visible behavior, public API contract, domain invariant, or important side effect changed by the branch.
   - Prefer happy paths and probable cases over exhaustive edge cases.
   - Flag tests that assert implementation details, private methods, internal collaborator choreography, framework behavior, or constants copied from the implementation.
   - Completion criterion: every test has a clear reason to exist, or is flagged.

5. Review redundancy and probability.
   - Flag tests already covered by an equivalent existing test at the same or stronger seam.
   - Flag micro-edge cases that are technically possible but not probable enough to justify ongoing maintenance.
   - Keep edge cases when they represent real user behavior, historically buggy behavior, security/data-loss risk, integration boundaries, or domain rules.
   - Completion criterion: every flagged redundancy or edge case includes why it is low value in this codebase.

6. Report findings in code-review format.
   - Findings first, ordered by severity.
   - Include file and line references where possible.
   - If no problems are found, say that explicitly and mention residual risks.

## Review Heuristics

- A test is strong when it would fail for a real behavior regression and survive an internal refactor.
- A test is weak when it mostly freezes current structure, duplicates another test, or documents an input nobody reasonably expects.
- A new pattern is suspicious when existing tests solve the same problem with established helpers, factories, matchers, or seams.
- A new pattern may be justified when the branch introduces a genuinely new seam, integration boundary, domain concept, or test framework capability.

## Output Shape

Use this structure:

```markdown
Findings
- Severity: `high|medium|low`
- File: `path:line`
- Issue: what is wrong
- Why it matters: maintenance, correctness, or signal cost
- Recommendation: keep, rewrite, move to another seam, merge with another test, or delete

Pattern Notes
- Existing patterns followed: ...
- New patterns introduced: ...
- Justified new patterns: ...

Coverage Judgment
- Valuable cases: ...
- Redundant or improbable cases: ...
- Missing probable happy paths, if any: ...
```

If there are no findings, keep the response short:

```markdown
No findings.

Pattern Notes
- ...

Residual Risks
- ...
```
