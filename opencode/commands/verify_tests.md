---
description: Review branch-introduced tests for pattern fit, value, redundancy, and improbable edge cases
---

# Verify Tests

Use the `verify-tests` skill to review tests introduced or modified on this branch. For a pass that also fills coverage gaps and applies the fixes, use `/test_gap` instead.

Usage: `/verify_tests [optional focus]`

If a focus is provided, prioritize it while still applying the full skill workflow.

$ARGUMENTS

Return findings only. Do not edit files unless explicitly asked after the review.
