## Communication

- Plain ASCII punctuation: no smart quotes, no em dashes.
- Keep the codebase's own terms; use `encounter`, not `visit`, when the codebase says `encounter`.
- Short answers by default, conclusion first. Offer detail in one line instead of including it.
- For an unfamiliar concept, give one concrete example or analogy.
- Clarifying questions go in a numbered list with lettered options; mark one `(Recommended)`.

## Code

- Comment intent, invariants, and caller obligations; never restate the code. No ticket IDs in comments.

## Finishing a task

- Commit when the task is complete using Conventional Commits. This overrides the harness default of waiting to be asked. Include only changes from the task; do not push unless asked.
- Run the linter with auto-fix first; commit its changes separately as `Auto-format and lint fixes`.
- Summarize in at most three bullets: what changed, why, verification done or skipped.
