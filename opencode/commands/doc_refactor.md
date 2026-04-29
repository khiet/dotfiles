---
description: Refactor a document for clarity, grammar, and spelling without changing its meaning
model: openai/gpt-5.5
---

# Doc Refactor

Refactor a document in place - fix grammar, spelling, typos, and formatting while preserving the original meaning and information.

Usage: `/doc_refactor <file_path>`

$ARGUMENTS

## Process

1. **Validate the argument**
   - A file path must be provided. If `$ARGUMENTS` is empty, ask the user for the file path and stop.
   - Verify the file exists. If it does not, report an error and stop.

2. **Check git status of the file**
   - Run `git status --porcelain -- <file_path>` to check if the file has uncommitted changes.
   - If the file shows as untracked (`??`) or has unstaged modifications (`M` or ` M`), **warn the user**:
     "⚠️ `<file_path>` has uncommitted changes. Proceeding will overwrite your unsaved edits. Continue? (y/n)"
   - Wait for confirmation before continuing. If the user declines, stop.

3. **Read the document**
   - Read the full contents of the file.

4. **Refactor the document**
   - Fix spelling mistakes and typos.
   - Fix grammatical errors.
   - Improve sentence clarity and readability where awkward phrasing exists.
   - Write like a good editor: make the document clearer, plainer, and more direct without making it sound like someone else wrote it.
   - Prefer concrete language over vague phrasing.
   - Remove unnecessary words, hedging, and jargon when doing so does not change meaning.
   - Avoid AI slop: remove or replace generated-looking punctuation and filler, including smart quotes, em dashes, ornamental phrasing, and vague summary language, when a plain alternative preserves the meaning.
   - Prefer simple ASCII punctuation unless the document already depends on non-ASCII characters.
   - Normalise inconsistent formatting (e.g., heading levels, list styles, whitespace).
   - Preserve all original markdown structure (headings, links, code blocks, frontmatter).
   - Do NOT add, remove, or alter any information. The meaning must remain identical.
   - Do NOT change code snippets inside fenced code blocks unless there is a clear typo in a comment.
   - Preserve the author's voice, intent, and level of formality.

5. **Write the changes**
   - Edit the file in place with the refactored content.

6. **Commit the change**
   - Stage the file: `git add <file_path>`
   - Commit with message: `docs: refactor <filename> for grammar and clarity`

7. **Report status**
   - Output one of the status lines below when done.

## Status

Report one of:
- "Done: refactored `<file_path>` and committed."
- "Skipped: user declined to overwrite uncommitted changes in `<file_path>`."
- "Error: `<file_path>` does not exist."
