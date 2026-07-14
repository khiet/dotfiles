---
description: Find and fill valuable missing tests for the last commit
---

# Test Gap Filler

Look at the last commit and fill in valuable missing tests for the changes made.

Usage: `/test_gap [optional instruction]`

If an instruction is provided, use it to guide what aspects of the changes to focus testing on. Otherwise, use your best judgement to identify untested or under-tested code paths.

$ARGUMENTS

## Process

1. **Examine the last commit**
   ```bash
   git log -1 --format="%H %s"
   git diff HEAD~1..HEAD
   git diff HEAD~1..HEAD --name-only
   ```

2. **Understand what changed**
   - Identify new functions, methods, classes, or modules added.
   - Identify modified logic, branching, or edge cases.
   - Note any changed public APIs or interfaces.
   - If an instruction was provided above, use it to prioritise which changes to focus on.

3. **Find existing tests and local patterns**
   - Locate the project's test directory and testing framework (e.g., Jest, pytest, Go test, Vitest).
   - Find any existing tests that already cover the changed files.
   - Read nearby existing tests to understand the project's testing conventions, patterns, and helpers.
   - Note file naming, directory placement, describe/context structure, setup style, assertion style, helper usage, fixtures/factories, and mocking style.

4. **Identify test gaps**
   - Compare what the last commit changed against what existing tests cover.
   - Flag: new behavior with no tests, modified branches with no updated assertions, probable failures, and important error handling that are untested.
   - Prefer gaps tied to user-visible behavior, public API contracts, domain invariants, integration boundaries, or important side effects.
   - Do not treat every technical branch, private helper path, copied constant, or improbable micro-edge case as a test gap.
   - If coverage is already comprehensive, say so and stop.

5. **Write the missing tests**
   - Follow the project's existing testing conventions exactly (file naming, directory structure, imports, assertion style, helpers, setup, naming, and grouping).
   - Write focused, descriptive test names that explain the behaviour being verified.
   - Cover happy paths and probable failures first.
   - Add edge cases only when they represent real user behavior, historically buggy behavior, security/data-loss risk, integration boundaries, or domain rules.
   - Avoid tests that mostly freeze implementation details, private methods, internal collaborator choreography, framework behavior, or low-probability inputs.
   - Do NOT rewrite or duplicate tests that already exist.

6. **Validate**
   - Run the project's test suite to confirm all new and existing tests pass.
   - If any tests fail, fix them and re-run until green.
   - If you add tests, make a single commit containing those test changes.

## Formatting

Always use backticks for code elements: class names, functions, file paths, commands, config keys.

## Status

Report one of:
- "✅ **Tests added**: [brief summary of what was covered] - all passing"
- "✅ **No gaps found**: existing tests already cover the last commit"
- "⚠️ **Tests added, issues remain**: [brief summary] - [what still needs attention]"
