---
description: Squash the current branch into one commit
allowed-tools: Bash(git branch:*), Bash(git diff:*), Bash(git log:*), Bash(git merge-base:*), Bash(git rev-parse:*), Bash(git reset:*), Bash(git status:*), Bash(git commit:*)
---

# Squash Into One Commit

Squash all commits on the current branch into one concise commit.

## Safety Rules

1. Reject immediately if the current branch is `main`.
2. Reject if the working tree has unstaged or uncommitted changes before squashing.
3. Do not push.
4. Do not use `git reset --hard`.
5. Preserve the branch's final file state exactly.

## Command Implementation

1. Determine the current branch:
   ```bash
   git branch --show-current
   ```
2. If the branch is `main`, stop and explain that squashing `main` is not allowed.
3. Confirm the working tree is clean:
   ```bash
   git status --short
   ```
   If there is any output, stop and ask the user to commit, stash, or discard the unrelated changes first.
4. Determine the branch base. Prefer `origin/main` if it exists, otherwise use local `main`:
   ```bash
   git rev-parse --verify origin/main
   git rev-parse --verify main
   ```
5. Find the merge base between the current branch and the selected base:
   ```bash
   git merge-base HEAD <base-ref>
   ```
6. Inspect the commits and combined diff being squashed:
   ```bash
   git log --oneline <merge-base>..HEAD
   git diff <merge-base>..HEAD
   ```
7. Soft reset to the merge base so all branch changes become staged as one commit:
   ```bash
   git reset --soft <merge-base>
   ```
8. Create one commit from the staged changes.

## Commit Message Format

Use a multi-line commit message with this structure:

```text
<type>: <one sentence summary>

TL;DR: <one sentence summary of the complete change>

<Detailed summary paragraph or bullets explaining the important changes and why they were made.>
```

Requirements:

1. Use Conventional Commits for the subject, such as `feat:`, `fix:`, `refactor:`, `docs:`, or `chore:`.
2. Keep the subject concise and under 72 characters.
3. Make the subject one sentence.
4. Include exactly one `TL;DR:` line after the subject.
5. Follow the `TL;DR:` with a detailed summary of the squashed branch changes.
6. Base the message on the commit log and combined diff, not just the latest commit.

Use `git commit` with multiple `-m` arguments, for example:

```bash
git commit -m "feat: add account export flow" \
  -m "TL;DR: Add the end-to-end account export flow and supporting UI." \
  -m "Adds export request handling, status rendering, and user-facing copy. Updates tests around export lifecycle behavior."
```

After committing, show:

```bash
git status --short
git log --oneline -1
```
