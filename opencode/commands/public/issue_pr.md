# PR Description Generator

Generate a concise GitHub PR description based on the current branch and recent commits. If a PR doesn't exist, create one. If it exists, output the generated description for review (do not auto-update to preserve any manual edits like screenshots).

## Process

1. **Run linter/formatter and commit any changes**
   - Run the project's linter with auto-fix enabled
   - If changes were made, commit with message: "Auto-format and lint fixes"

2. **Gather branch information:**
   ```bash
   git log --oneline -10
   git diff main...HEAD --name-only
   git diff main...HEAD --stat
   ```

3. **Analyze test coverage** for PR changes only (not full codebase)

4. **Generate PR description** following the template below

5. **Handle PR:**
   - Check if PR exists: `gh pr view`
   - If no PR exists: create with `gh pr create` and open in browser
   - If PR exists: output the generated description for user to review/copy

## PR Template

```markdown
## Summary

- [Main change - concise, actionable]
- [Additional changes if needed]
- [Max 3 bullets]

## Test Plan

- [ ] Verified existing tests pass
- [ ] [Specific verification steps for the changes]
- [ ] [Note any missing test coverage]
```

## Formatting

Always use backticks for code elements: class names, functions, file paths, commands, config keys.

## Status

Report one of:
- "✅ **Created new PR**: <URL>"
- "📋 **PR exists**: <URL> — Generated description below for review"
