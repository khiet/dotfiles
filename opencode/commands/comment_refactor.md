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
   - Fact-check every comment against the code it describes. Read the surrounding implementation and confirm the claim is still true. Fix or remove comments that are stale, wrong, or describe behavior the code no longer has.
   - Keep comments that explain non-obvious intent, invariants, constraints, tradeoffs, side effects, exceptions, caller obligations, or the meaning of a value.
   - Remove or rewrite comments that match any pattern in the "Low-Value Comment Patterns" section below.
   - Remove comments that merely repeat the code in different words, or that state anything a reader would learn by reading the code itself.
   - Remove details that do not matter to a future reader, such as migration history, how the code came to be written, or notes aimed at the original reviewer. Unimportant detail adds complexity, so leave it out.
   - For class comments, describe the abstraction the class provides.
   - For method and function comments, describe behavior, arguments, return value, side effects, exceptions, and preconditions when those are not obvious from the signature and surrounding code.
   - For variable comments, describe what the value represents rather than how the code mutates or uses it.
   - Keep public interface documentation focused on what callers need to know. Do not add implementation details unless they affect correct use.
   - Prefer comments a mid-level engineer new to the project can understand without private domain knowledge.
   - If a domain-specific term is necessary, explain the term briefly in the comment or replace it with plainer language.
   - Use low-level comments for precision and high-level comments for intuition. Default to the highest level of abstraction that still builds the reader's intuition, and keep the wording concise.
   - Add a short example when prose alone will not land, such as an algorithm that manipulates a data structure or a branching condition with several interacting cases. Show a representative input and the resulting output or branch taken. Keep the example small enough to read at a glance.
   - Look at similar code in the project, such as comparable service objects, components, controllers, or modules, and align with their established commenting style when it is clear and useful.
   - Before changing a comment, identify what the surrounding code is trying to do, what single explanation covers the whole block, and what matters most for a future reader.
   - **Referent check.** Reread each edited comment alone, without the code around it. List every noun phrase and pronoun; each must resolve to an identifier in the same file, a term the same sentence defines, or plain English. One that resolves only through knowledge you happen to hold is a rewrite, not a judgement call.
   - **One idea per paragraph.** Split a paragraph carrying a rule, its cause, and its exception into separate paragraphs.
   - Apply the rule of thumb: good comments explain why; poor comments explain what. If removing a comment does not make the code any harder to understand, remove it.

4. **Edit comments in place**
   - Modify only comments that were added by the target diff unless a nearby existing comment must be adjusted for grammar or consistency with the new comment.
   - Do not change runtime behavior.
   - Do not rename code, restructure logic, or refactor non-comment code.
   - Preserve the file's existing comment style, formatting conventions, and line length where practical.
   - After editing, rewrap the paragraph to the file's comment width. Formatters do not reflow comments, so an edit leaves ragged lines behind.
   - Prefer simple ASCII punctuation unless the file already uses non-ASCII punctuation for comments.

5. **Validate**
   - Re-run the relevant diff command and confirm the edited added comments still appear in the target diff.
   - If the project has a cheap formatter or linter for the changed files, run it. Do not run expensive full-suite commands unless the change or project convention calls for it.
   - Review `git diff --check` for whitespace errors.

6. **Report status**
   - Summarize which files had comments updated.
   - List any names that comments were compensating for, as rename suggestions for the user.
   - If no added comments needed changes, say so explicitly.
   - If validation was skipped, explain why.

## Low-Value Comment Patterns

From John Ousterhout's "A Philosophy of Software Design": a comment earns its place only when it carries information the code itself cannot easily express. Remove or rewrite added comments that match any of these patterns.

1. **Redundant comments** repeat exactly what the code already says.

   ```java
   i++; // Increment i
   ```

2. **Obvious interface comments** explain parameters or return values already clear from good names and types.

   ```java
   // Returns the user's name.
   String getUserName();
   ```

3. **Implementation narration** describes each step of the algorithm instead of the overall intent.

   ```java
   // Loop through the list.
   // Check each item.
   // Add matching items.
   for (...) { ... }
   ```

4. **Comments compensating for poor names** exist only because a variable or method is named unclearly. `int x; // Number of active users` should be `int activeUserCount;`. Since this command must not rename code, remove or improve the comment as far as possible and flag the naming problem in the final report instead of renaming.

5. **Outdated or misleading comments** no longer reflect the code's behavior. These are worse than no comment at all; fix or delete them.

6. **Boilerplate or auto-generated comments** add no information beyond the signature.

   ```java
   /**
    * Gets the value.
    *
    * @return the value
    */
   ```

7. **Noise comments** state trivial facts every reader can infer.

   ```java
   // Default constructor.
   MyClass() {}
   ```

8. **Commented-out code** keeps old code in comments instead of relying on version control. Delete it and let Git preserve the history.

9. **Line-by-line commentary** explains every individual statement rather than the overall idea.

What good comments provide instead: the why behind the code, design decisions and rationale, assumptions, constraints, invariants, edge cases, performance tradeoffs, and non-obvious behavior.

## Unresolvable Reference Patterns

These read fine to the author, who holds the whole model in their head, and stall the reader, who does not. Rewrite added comments matching any of them.

1. **Positional back-reference** points at an earlier item by position: "the Sync writes the first from the second", "the latter". Name the thing each time, even at the cost of repetition.

2. **Vague stand-in for a named symbol** says "this list" or "the submission" where the code says `claims` and `ClaimSubmission.denialReceivedAt`. A comment beside code may repeat the code's names.

3. **Invented synonym** calls `externalEncounterId` "the visit id", giving one field two names and forcing the reader to keep a glossary.

4. **Circular comparison** compares a variable to the type or table it holds rows from: "`claims` is a narrower view of `AdjudicatedClaim`" reads as X is a view of X. Say which rows it holds and what filtered them out.

5. **Load-bearing connective** hides a claim in a small word: "also" asserts additive behavior, "usually" asserts a frequency, "still" asserts persistence. Verify each against the code or drop it, since a wrong connective hides a factual error inside a sentence that scans as true.

6. **Symptom without mechanism** states an outcome and stops: "the rows are usually missing here". Name the cause: which query, which filter, which writer.

7. **Prose narrating a branch** describes an n-way condition in paragraphs. Write one bullet per arm, in the code's order, so the reader can lay the comment against the predicate. Reserve paragraphs for a single idea.

8. **Volatile measurement** embeds row counts, percentages, or dates that age into lies. State the durable property; the numbers belong in the PR or the ticket.

## Status

Report one of:

- `Done: updated added comments in <files>.`
- `No changes: added comments already follow the comment guidance.`
- `Skipped: target branch must be non-main.`
- `Error: <reason>.`
