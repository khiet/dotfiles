---
name: comment-refactor
description: Fact-check and simplify the comments a branch changed. Use when asked to clean up a branch's comments.
---

# Comment Refactor

Fact-check the current branch's comment changes, then keep only useful reasons
and hidden contracts in plain English. This skill edits comments and commits.
The optional argument is the base ref.

## 1. Fix the scope

- Read the repository instructions and snapshot the current HEAD and worktree
  diff.
- Use the supplied base ref. Otherwise use `main`. Ask only when neither
  exists.
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

## 3. Edit, verify, and commit

Apply the dispositions only within the inventoried scope.

Compare the final diff with the starting snapshot. Proceed only when every new
edit maps to an inventoried comment change, unchanged comments and code are
untouched, and each retained sentence passes the comment rules below.

Stage only the files this pass changed and commit them on their own with a
`docs:` subject, so the comment edits stay separable from the code they
describe. Skip the commit when nothing was edited.

Report changed files, unresolved claims, and design signals with evidence
locations. If nothing needed editing, say so explicitly.

## Comment rules

- **Reason or contract only.** A comment on a field, local, or statement
  survives only if it carries a reason or a hidden contract the code cannot
  express; the name and body already say what.
  `assignee: EncounterAssignee | null` needs no "who is working the encounter"
  gloss, even when neighboring fields have comments. It does earn "null until
  triage claims the encounter", because the type says null is possible, not
  when.
- **Interface comments complete the abstraction.** A comment on a class,
  module, or exported function survives when it lets a caller use the thing
  without reading the body: behavior, arguments, return value, side effects,
  errors, and preconditions. Trim the parts that describe how the body works;
  a caller does not need them and they go stale first.
- **One sentence per decision.** Keep a single "because" the code cannot express:
  "Keep disabled members listed because hiding them leaves the current assignee
  unexplained." A distinct hidden contract earns its own sentence.
- **Examples when needed.** If a hidden rule remains unclear, keep the reason to
  one sentence and add one short, concrete example showing its consequence.
- **Plain English.** Use direct words, exact identifiers, and the codebase's domain
  terms. Cut filler, ticket IDs, historical narration, and speculative rationale.
  Explain necessary caller obligations or invariants.
- **Flag design signals instead of padding.** When a changed comment cannot be
  made both simple and complete, or exists only to compensate for a vague name,
  the fix is a rename or a design change outside the editable lines. Report it
  with its location; do not write a longer comment around it.
