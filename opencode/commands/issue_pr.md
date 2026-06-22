---
description: Generate or create a pull request description for the current branch
---

# PR Description Generator

Generate a concise GitHub PR description based on the current branch and recent commits. If a PR doesn't exist, create one as a draft. If it exists, output the generated description for review (do not auto-update to preserve any manual edits like screenshots) and confirm if I want to overwrite.

## Process

1. **Prepare codebase with separate commits**
   - Whenever making any changes to the codebase (e.g., adding a missing test, linting, or other fixes), create a separate commit for each logical change.

2. **Gather branch information:**
   ```bash
   git log --oneline -10
   git diff main...HEAD --name-only
   git diff main...HEAD --stat
   ```

3. **Check for a repository PR template:**
   - Look for `.github/pull_request_template.md`.
   - If present, read it and use its headings, checklists, prompts, and ordering as the structure for the generated PR description.
   - Fill template sections with concrete details from the branch, commits, changed files, and verification performed.
   - Preserve checklist items from the template. Mark an item checked only when the branch evidence or performed verification supports it; otherwise leave it unchecked and add a brief note where useful.
   - Do not invent answers for compliance, monitoring, rollout, or dependency questions. If the evidence is unclear, keep the item unchecked and state the uncertainty concisely.
   - If the template has placeholder guidance text, replace it with the generated content when possible rather than leaving generic instructions in the final PR body.

4. **Analyze test coverage** for PR changes only (not full codebase)

5. **Generate PR description:**
   - If `.github/pull_request_template.md` exists, follow that repository template.
   - Otherwise, follow the fallback template below.

6. **Handle PR:**
   - Check if PR exists: `gh pr view`
   - If no PR exists: create with `gh pr create --draft`
   - If PR exists: output the generated description for user to review/copy

## Fallback PR Template

```markdown
## Summary

TL;DR: [One or two sentence outcome-focused summary]

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
- "✅ **Created new draft PR**: <URL>"
- "📋 **PR exists**: <URL> — Generated description below for review"
