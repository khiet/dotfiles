---
name: comment-refactor
description: Refactor code comments added by a branch or commit into concise reasons and hidden contracts. Use when the user asks to clean up, review, or refactor comments, or runs `/comment_refactor`.
---
# Comment Refactor

Review code comments added by a branch or commit, then update them in place using the rules below and `pi/AGENTS.md`.

Invoke via `/comment_refactor [target]` or `/skill:comment-refactor [target]`. The optional target is a commit hash, a file path, or a branch name.

## Comment Rules

1. **Trust names and types.** Leave clearly named fields, props, and parameters uncommented: `assignee: EncounterAssignee | null` needs no "who is assigned to work on the encounter" gloss.
2. **Skip introductions.** Start with the hidden constraint or reason, not a summary of the function, hook, route, or class; skip what names, types, and code already say.
3. **One sentence per decision.** State the reason and its consequence, not a paragraph of design rationale: "Keep disabled members listed because hiding them leaves the current assignee unexplained."
4. **Document hidden facts.** Use one concise sentence for a contract the types cannot express, such as the keys inside a `Json` column, or a dependency that makes apparently removable code necessary, such as a handler required elsewhere on the page. Preserve necessary contracts when shortening; accuracy takes precedence over the sentence limit.
5. **Match sibling coverage.** When every member of the immediate block has a comment, give new members the same concise treatment; silence would read as an omission. This is an exception to leaving clear names uncommented, not permission to copy noisy conventions across the project.

Use exact identifiers rather than vague references or invented synonyms, and briefly explain necessary domain terms. Name the cause of non-obvious behavior, not just its symptom.

Remove redundant narration, boilerplate, commented-out code, migration history, reviewer notes, and volatile measurements; retain durable constraints instead. If an unclear name still needs explanation, keep the useful comment and suggest a rename in the report without changing code.

## Target Rules

- With no argument, use the current branch and diff against `main`.
- With a commit hash, review comments added by that commit only.
- With a file path, use the current branch diff against `main`, limited to that file.
- With a branch name, diff `main...<branch_name>`.
- If the current branch is `main` and no branch or commit target is provided, report that the branch has to be non-main and stop.
- If the target branch argument is `main`, report that the branch has to be non-main and stop.
- If a branch target is provided and it is not the currently checked-out branch, do not switch branches automatically when the worktree has uncommitted changes. Ask the user to switch or confirm before proceeding.

## Process

1. **Resolve the target**
   - Run `git rev-parse --abbrev-ref HEAD` to identify the current branch.
   - Run `git rev-parse --verify main` to verify `main` exists. If it does not, report the error and stop.
   - Classify the target argument as one of: empty, commit hash, existing file path, or branch name.
   - For branch targets, verify the branch exists with `git rev-parse --verify <branch_name>`.

2. **Collect added comments only**
   - For the default target, inspect `git diff main...HEAD --unified=0`.
   - For a file path, inspect `git diff main...HEAD --unified=0 -- <file_path>`.
   - For a branch, inspect `git diff main...<branch_name> --unified=0`.
   - For a commit hash, inspect `git diff <commit_hash>^! --unified=0`.
   - Consider only added comment lines from the diff. Ignore unchanged comments, deleted comments, generated files, vendored code, lockfiles, and minified files.
   - Include interface documentation, block comments, inline comments, docstrings, and language-specific comment forms.

3. **Evaluate each added comment**
   - Read the surrounding implementation and verify every claim, including implied claims in words such as "also", "usually", and "still". Trace referenced dependencies when the reason lives elsewhere.
   - Apply the Comment Rules to decide whether to keep, shorten, correct, or remove each comment.
   - Finish when each retained comment is accurate and carries a necessary reason, hidden fact, or immediate sibling convention.

4. **Edit comments in place**
   - Modify only comments that were added by the target diff unless a nearby existing comment must be adjusted for grammar or consistency with the new comment.
   - Do not change runtime behavior.
   - Do not rename code, restructure logic, or refactor non-comment code.
   - Preserve the file's existing comment style, formatting conventions, and line length where practical.
   - Rewrap edited comments to the file's comment width; one sentence may span physical lines.
   - Prefer simple ASCII punctuation unless the file already uses non-ASCII punctuation for comments.

5. **Validate**
   - Re-run the relevant diff command and confirm changes stay within the allowed comment scope, including deliberate removals.
   - If the project has a cheap formatter or linter for the changed files, run it with auto-fix. Do not run expensive full-suite commands unless the change or project convention calls for it.
   - Review `git diff --check` for whitespace errors.

6. **Report status**
   - Summarize which files had comments updated.
   - List any names that comments were compensating for, as rename suggestions for the user.
   - If no added comments needed changes, say so explicitly.
   - If validation was skipped, explain why.

## Status

Report one of:

- `Done: updated added comments in <files>.`
- `No changes: added comments already follow the comment guidance.`
- `Skipped: target branch must be non-main.`
- `Error: <reason>.`
