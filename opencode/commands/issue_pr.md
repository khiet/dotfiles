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
   - Read the surrounding code the diff touches (callers, the module it lives in, related tests) when the diff alone does not explain what was broken and why it mattered. Skip this when the diff is self-explanatory. The point is to find a concrete symptom or scenario for the problem statement rather than describing the change abstractly.

3. **Analyze test coverage** for PR changes only (not full codebase)

4. **Find a Before/After.** Look through the diff for something observable that changed: an error message, a log line, an API response or payload shape, a function's return value, rendered UI, CLI output. This is almost always findable even for "internal" changes — pull the actual before and after strings/values from the code or tests, don't invent them.
   - If nothing observable changed (pure refactor, internal-only helper, CI/config-only change), skip the Before/After block and say so in one sentence instead.

5. **Generate PR title** following the PR Title rules below.

6. **Generate PR description** using the template below.
   - Total body (excluding code blocks) should read in about 15 seconds — roughly 80-120 words.
   - No section headers, no bullet lists, no checkboxes. Prose only.
   - Plain language a non-technical reader can follow for the problem statement and insight sentence; technical detail is fine in the closing `Fix:` sentence.
   - The insight sentence carries the essence, not the details. Name the rule or assumption that makes After right and Before wrong; do not restate what the Before/After block already shows.
   - Pull real before/after values from the diff/tests — never fabricate example output.

7. **Handle PR:**
   - Check if PR exists: `gh pr view`
   - If no PR exists: create with `gh pr create --draft --title "<conventional commit title>"`
   - If PR exists: output the generated description for user to review/copy. Also check the existing title — if it is missing a valid conventional commit prefix, show the suggested replacement and offer to run `gh pr edit --title "<conventional commit title>"`.

## PR Title

The title must be a valid [Conventional Commits](https://www.conventionalcommits.org/) subject: `type(optional-scope): description`.

This is not cosmetic. A squash merge uses the PR title as the commit subject, and release automation such as [release-please](https://github.com/googleapis/release-please) parses that subject to decide the version bump and changelog entry. A title without a valid prefix is silently skipped: no bump, no changelog line.

Rules:

- Pick the type from the dominant intent of the diff: `feat` (new user-facing capability), `fix` (bug fix), `refactor`, `perf`, `docs`, `test`, `build`, `ci`, `chore`, `style`, `revert`.
- When a diff spans several types, use the type of the change the PR exists to deliver, not the largest by line count. Incidental test or lint churn does not make it a `test` or `chore` PR.
- Add a scope when the repo already uses scopes consistently (check `git log --oneline -30`); otherwise omit it rather than inventing a taxonomy.
- Mark breaking changes with `!` before the colon (`feat(api)!: ...`) and add a `BREAKING CHANGE: <what breaks>` footer to the description. Without one of these, release automation issues a minor bump for a change that needs a major.
- Lowercase description, imperative mood, no trailing period, ideally under 72 characters total.
- Never include story, ticket, or issue keys in the title.

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

[1 sentence naming the insight: the rule or assumption that makes After correct
and Before wrong. Essence, not detail — do not restate the block above.]

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

In both cases, state the PR title used or suggested, and flag it when the existing title needed a conventional commit prefix.
