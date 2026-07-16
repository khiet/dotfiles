---
description: Generate or create a pull request description for the current branch
---

# PR Description Generator

Generate a short, elevator-pitch-style GitHub PR description based on the current branch and recent commits. Write for a broad audience, including non-technical reviewers. If a PR doesn't exist, create one as a draft. If it exists, output the generated description for review (do not auto-update to preserve any manual edits like screenshots) and confirm if I want to overwrite.

Always use the PR Template below — do not use `.github/pull_request_template.md` or any other repo checklist template, even if one is present. No headers, no checkboxes.

## Process

1. **Prepare codebase with separate commits**
   - Whenever making any changes to the codebase (e.g., adding a missing test, linting, or other fixes), create a separate commit for each logical change.

2. **Gather branch information:**
   ```bash
   git log --oneline -10
   git diff main...HEAD --name-only
   git diff main...HEAD --stat
   ```

3. **Analyze test coverage** for PR changes only (not full codebase)

4. **Find a Before/After.** Look through the diff for something observable that changed: an error message, a log line, an API response or payload shape, a function's return value, rendered UI, CLI output. This is almost always findable even for "internal" changes — pull the actual before and after strings/values from the code or tests, don't invent them.
   - If nothing observable changed (pure refactor, internal-only helper, CI/config-only change), skip the Before/After block and say so in one sentence instead.

5. **Generate PR description** using the template below.
   - Total body (excluding code blocks) should read in about 15 seconds — roughly 80-120 words.
   - No section headers, no bullet lists, no checkboxes. Prose only.
   - Plain language a non-technical reader can follow for the problem statement and insight sentence; technical detail is fine in the closing `Fix:` sentence.
   - Pull real before/after values from the diff/tests — never fabricate example output.

6. **Handle PR:**
   - Check if PR exists: `gh pr view`
   - If no PR exists: create with `gh pr create --draft`
   - If PR exists: output the generated description for user to review/copy

## PR Template

```markdown
[1-2 sentence problem statement: what was broken or missing, and why it mattered.
Be concrete — cite a specific symptom, incident, or scenario if one exists rather
than describing the change abstractly.]

**Before** [short qualifier if useful, e.g. "(canned text, same for every X)"]:
```
[actual before behavior/output, pulled from the code or tests]
```

**After** [short qualifier if useful]:
```
[actual after behavior/output, pulled from the code or tests]
```

[1 sentence naming the insight: why After is correct and Before was wrong.]

Fix: [1-2 sentences: the mechanism of the fix, an explicit scope boundary
(what did NOT change, so reviewers know the blast radius), and a test
coverage note, e.g. "9 new unit tests cover it."]
```

If no Before/After applies (step 4), drop that block and keep the rest:

```markdown
[1-2 sentence problem statement.]

Fix: [mechanism + scope boundary + test coverage note.]
```

## Formatting

Always use backticks for code elements: class names, functions, file paths, commands, config keys.

## Status

Report one of:
- "✅ **Created new draft PR**: <URL>"
- "📋 **PR exists**: <URL> — Generated description below for review"
