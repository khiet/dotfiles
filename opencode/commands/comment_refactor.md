---
description: Refactor newly added code comments against main so they explain intent, constraints, and domain terms clearly
---

# Comment Refactor

Review code comments added by a branch or commit, then update those comments in place so they follow `opencode/AGENTS.md` comment guidance.

Usage: `/comment_refactor [commit_hash|file_path|branch_name]`

$ARGUMENTS

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
   - Classify `$ARGUMENTS` as one of: empty, commit hash, existing file path, or branch name.
   - For branch targets, verify the branch exists with `git rev-parse --verify <branch_name>`.

2. **Collect added comments only**
   - For the default target, inspect `git diff main...HEAD --unified=0`.
   - For a file path, inspect `git diff main...HEAD --unified=0 -- <file_path>`.
   - For a branch, inspect `git diff main...<branch_name> --unified=0`.
   - For a commit hash, inspect `git diff <commit_hash>^! --unified=0`.
   - Consider only added comment lines from the diff. Ignore unchanged comments, deleted comments, generated files, vendored code, lockfiles, and minified files.
   - Include interface documentation, block comments, inline comments, docstrings, and language-specific comment forms.

3. **Evaluate each added comment**
   - Keep comments that explain non-obvious intent, invariants, constraints, tradeoffs, side effects, exceptions, caller obligations, or the meaning of a value.
   - Remove comments that merely repeat the code in different words.
   - For class comments, describe the abstraction the class provides.
   - For method and function comments, describe behavior, arguments, return value, side effects, exceptions, and preconditions when those are not obvious from the signature and surrounding code.
   - For variable comments, describe what the value represents rather than how the code mutates or uses it.
   - Keep public interface documentation focused on what callers need to know. Do not add implementation details unless they affect correct use.
   - Prefer comments a mid-level engineer new to the project can understand without private domain knowledge.
   - If a domain-specific term is necessary, explain the term briefly in the comment or replace it with plainer language.
   - Use low-level comments for precision and high-level comments for intuition.
   - Before changing a comment, identify what the surrounding code is trying to do, what single explanation covers the whole block, and what matters most for a future reader.

4. **Edit comments in place**
   - Modify only comments that were added by the target diff unless a nearby existing comment must be adjusted for grammar or consistency with the new comment.
   - Do not change runtime behavior.
   - Do not rename code, restructure logic, or refactor non-comment code.
   - Preserve the file's existing comment style, formatting conventions, and line length where practical.
   - Prefer simple ASCII punctuation unless the file already uses non-ASCII punctuation for comments.

5. **Validate**
   - Re-run the relevant diff command and confirm the edited added comments still appear in the target diff.
   - If the project has a cheap formatter or linter for the changed files, run it. Do not run expensive full-suite commands unless the change or project convention calls for it.
   - Review `git diff --check` for whitespace errors.

6. **Report status**
   - Summarize which files had comments updated.
   - If no added comments needed changes, say so explicitly.
   - If validation was skipped, explain why.

## Status

Report one of:

- `Done: updated added comments in <files>.`
- `No changes: added comments already follow the comment guidance.`
- `Skipped: target branch must be non-main.`
- `Error: <reason>.`
