---
description: Refactor newly added code comments against main so they explain intent, constraints, and domain terms clearly
---

# Comment Refactor

Use the `comment-refactor` skill to review the comments added by a branch or commit and rewrite them in place so they follow the comment guidance in `pi/AGENTS.md`.

Usage: `/comment_refactor [commit_hash|file_path|branch_name]`

With no argument, the skill uses the current branch diffed against `main`.

$ARGUMENTS
