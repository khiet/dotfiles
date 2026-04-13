---
description: Find and fill missing tests for the last commit
---

# Test Gap Filler

Look at the last commit and fill in any missing tests for the changes made.

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

3. **Find existing tests**
   - Locate the project's test directory and testing framework (e.g., Jest, pytest, Go test, Vitest).
   - Find any existing tests that already cover the changed files.
   - Read those test files to understand the project's testing conventions, patterns, and helpers.

4. **Identify test gaps**
   - Compare what the last commit changed against what existing tests cover.
   - Flag: new code paths with no tests, modified branches with no updated assertions, edge cases and error handling that are untested.
   - If coverage is already comprehensive, say so and stop.

5. **Write the missing tests**
   - Follow the project's existing testing conventions exactly (file naming, directory structure, imports, assertion style, helpers).
   - Write focused, descriptive test names that explain the behaviour being verified.
   - Cover: happy path, edge cases, error/failure modes, and boundary conditions as appropriate.
   - Do NOT rewrite or duplicate tests that already exist.

6. **Validate**
   - Run the project's test suite to confirm all new and existing tests pass.
   - If any tests fail, fix them and re-run until green.
   - If you add tests, make a single commit containing those test changes.

## Formatting

Always use backticks for code elements: class names, functions, file paths, commands, config keys.

## Status

Report one of:
- "✅ **Tests added**: [brief summary of what was covered] — all passing"
- "✅ **No gaps found**: existing tests already cover the last commit"
- "⚠️ **Tests added, issues remain**: [brief summary] — [what still needs attention]"
