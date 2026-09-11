---
name: comment-refactor
description: Fact-check and simplify the comments a branch changed. Use when asked to clean up a branch's comments.
---

# Comment Refactor

Fact-check the current branch's comment changes, then keep only useful reasons
and hidden contracts in plain English. The optional argument is the base ref.

## 1. Fix the scope

- Read the repository instructions and snapshot the current HEAD and worktree
  diff.
- Use the supplied base ref, otherwise the repository's default branch. If the
  default cannot be established, ask for a base rather than guessing.
- Resolve `git merge-base <base-ref> HEAD` once and save it as `<base>`.
- Inventory comment additions, removals, and updates from
  `git diff --find-renames --unified=0 <base> HEAD`, covering every comment form
  the language has, docstrings included. Exclude generated and vendored files.
- Executable code, runtime-significant docstrings, license notices, and tool
  directives such as lint suppressions are out of scope; flag them if they need
  a semantic change.
- Only lines changed by this branch are editable; unchanged comments, including
  context lines in a changed block, are read for context only. If a disposition
  needs an edit outside those lines, flag it instead of applying it.
- Uncommitted changes are outside this review. If they overlap a candidate edit,
  stop and ask how to proceed; preserve all unrelated work.

Proceed when the base is fixed and every changed comment is inventoried. If the
branch has no comment changes, report that and stop.

## 2. Fact-check every change

Read each full comment and its surrounding implementation on both sides of the
diff. Trace referenced callers, types, tests, and dependencies until each factual
claim has evidence, including qualifiers such as "always", "still", and "only".
A plausible explanation is not evidence of intent.

- **Added or updated:** choose keep, correct, shorten, or remove using the
  comment rules below. Delete unsupported rationale rather than inventing a
  replacement. If a potentially necessary contract cannot be verified, leave it
  and flag the claim as unresolved with the evidence needed.
- **Removed:** check whether the deleted reason or contract still applies. Keep
  redundant or obsolete comments deleted; restore a concise version only when
  evidence shows a necessary hidden constraint was lost. Flag uncertain removals.

Finish when every changed comment has a disposition and every factual claim is
supported or explicitly unresolved.

## 3. Edit and verify

Apply the dispositions only within the inventoried scope.

Compare the final diff with the starting snapshot. Finish only when every new
edit maps to an inventoried comment change, unchanged comments and code are
untouched, and each retained sentence passes the comment rules below.

Report changed files and unresolved claims with evidence locations. If nothing
needed editing, say so explicitly.

## Comment rules

- **Reason or contract only.** A comment survives only if it carries a reason or
  a hidden contract the code cannot express; names, signatures, and bodies
  already say what. `assignee: EncounterAssignee | null` needs no "who is
  working the encounter" gloss, even when neighboring fields have comments.
- **One sentence per decision.** Keep a single "because" the code cannot express:
  "Keep disabled members listed because hiding them leaves the current assignee
  unexplained." A distinct hidden contract earns its own sentence.
- **Examples when needed.** If a hidden rule remains unclear, keep the reason to
  one sentence and add one short, concrete example showing its consequence.
- **Plain English.** Use direct words, exact identifiers, and the codebase's domain
  terms. Cut filler, ticket IDs, historical narration, and speculative rationale.
  Explain necessary caller obligations or invariants.
