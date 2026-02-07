---
description: Create a commit from staged changes
model: google/gemini-2.0-flash
---

Create a single git commit for the currently staged changes.

Here are the staged changes:
!`git diff --cached`

Instructions:
1. Analyze the staged changes above
2. Write a clear, concise commit message following conventional commit format (e.g., feat:, fix:, docs:, refactor:, chore:)
3. The commit message should focus on the "why" rather than the "what"
4. Keep the subject line under 72 characters
5. Run `git commit -m "your message"` to create the commit
6. IMPORTANT: Do NOT stage any files. Only work with what is already staged.

If there are no staged changes, stage everything for me. If there are staged changes already, just look at the staged changes (do not stage any additional changes).
