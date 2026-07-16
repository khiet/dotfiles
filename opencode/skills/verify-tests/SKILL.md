---
name: verify-tests
description: Review branch-introduced tests and report findings without editing. Use when the user asks for a test review, or `/verify_tests`.
---

# Verify Tests

The review half of `test-gap`, run on its own: judge the branch's tests, report, change nothing. Fix findings only when the user asks after the review.

## Workflow

1. Scope the branch and build the local pattern baseline, following the `Scope` section of [`../test-gap/REVIEW.md`](../test-gap/REVIEW.md).

2. Judge every branch-introduced test against the `Pattern fit`, `Behavioral value`, and `Redundancy and probability` sections of the same file.
   - Completion criterion: every branch-introduced test carries a verdict backed by a concrete local baseline.

3. Report missing coverage as a finding rather than writing the test. Point the user to `/test_gap` when the branch has real gaps.

4. Report in the output shape below, findings first, ordered by severity.

## Output Shape

```markdown
Findings
- Severity: `high|medium|low`
- File: `path:line`
- Issue: what is wrong
- Why it matters: maintenance, correctness, or signal cost
- Verdict: `keep|rewrite|move|merge|delete`

Pattern Notes
- Existing patterns followed: ...
- New patterns introduced: ...
- Naming and structure consistency: ...
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
