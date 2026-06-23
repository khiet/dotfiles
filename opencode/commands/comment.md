---
description: Rewrite marked comments in a file according to a leading directive (S shorten, E elaborate, J junior-friendly)
---

# Comment

Scan a file for comments that begin with a directive marker, rewrite each marked comment as the marker asks, and remove the marker so the final comment is clean.

Usage: `/comment <file_path>`

$ARGUMENTS

## Markers

A marker is the first token inside a comment, written as a single uppercase letter followed by a colon. It applies to the comment it starts.

- `S:` Shorten. Make the comment as short as possible without losing essential meaning. Remove filler, redundant phrasing, and hedging first; drop lower-value detail only when needed to tighten it, as long as the core intent survives. Judge from context how much detail is essential.
- `E:` Elaborate. Expand with the context a reader is missing: intent, invariants, constraints, tradeoffs, side effects, edge cases, and the "why". Add information, do not just restate the existing text at greater length.
- `J:` Junior-friendly. Rewrite so a developer new to this codebase can follow it without private context. Spell out acronyms and jargon, explain domain terms briefly, and make the reason for the code explicit. May be longer than the original.

Markers are case-insensitive (`s:` works), but only `S`, `E`, `J` are recognized. A comment with any other leading letter, or no marker, is left untouched.

## Process

1. **Resolve the target**
   - Treat `$ARGUMENTS` as a single file path. If it is empty or the file does not exist, report the error and stop.
   - Skip generated files, vendored code, lockfiles, and minified files; if the target is one of these, report it and stop.

2. **Find marked comments**
   - A marker is the first non-whitespace token after a comment opener: `//`, `#`, `/*`, `/**`, `--`, `<!--`, or a docstring delimiter (`"""`, `'''`), matching the form `<S|E|J>:`.
   - For a block comment (`/* ... */`, `<!-- ... -->`, docstring), the marker on its first line governs the whole block.
   - For single-line comments, the marker governs the comment on that line. If a run of consecutive single-line comments forms one paragraph and the marker sits on the first line, treat the whole run as one comment.
   - Ignore markers that appear inside string literals or code rather than at the start of a comment.

3. **Rewrite each marked comment**
   - Apply the marker's directive to that comment only.
   - Follow the comment guidance in `opencode/AGENTS.md`: explain what is not obvious from the code, and do not restate the code or the symbol name.
   - Strip the `<letter>:` marker and any single following space from the result. The marker must not appear in the final comment.
   - Preserve the comment delimiter, indentation, line-length convention, and the file's existing comment style. For inline comments that follow code on the same line, leave the code untouched and rewrite only the comment portion.
   - Preserve any non-comment content; do not change runtime behavior, rename code, or restructure logic.

4. **Validate**
   - Confirm no recognized marker (`S:`, `E:`, `J:`) remains at the start of any comment in the file.
   - Run `git diff --check` for whitespace errors.
   - If the project has a cheap formatter or linter for the file, run it. Do not run expensive full-suite commands.

5. **Report status**

## Status

Report one of:

- `Done: rewrote <n> marked comment(s) in <file>.`
- `No changes: no recognized markers found in <file>.`
- `Error: <reason>.`
