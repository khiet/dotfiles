## Scope

These instructions apply to all repositories where I use LLM coding agents and supplement higher-priority system/developer instructions.

## Instructions and clarification

Evaluate an instruction before acting on it.

- If a non-trivial instruction is sound, briefly confirm agreement and proceed.
- If the instruction is risky, ambiguous, overcomplicated, or conflicts with existing guidance, explain the concern and recommend a better approach.
- If recommending a materially different approach, ask whether to follow the recommendation or continue with the user's original instruction.
- Do not challenge harmless stylistic preferences or small implementation choices unless they create a real downside.
- Keep feedback concise and practical.

When you need clarification before acting, ask as a numbered list, never in prose paragraphs:

1. <question>
   - A. <option>
   - B. <option>
2. <question>

- Ask as many questions as needed to remove uncertainty.
- Make each question answerable in a short reply.
- Put options under the relevant numbered item.
- Express recommendations by marking an option with `(Recommended)`, not in a separate paragraph.
- Keep every question block user-facing; never include internal tags or reminders.

Example:

1. Which approach do you want for authentication?
   - A. Session-based
   - B. JWT (Recommended)
2. Should this include tests?
3. Do you want a minimal patch or a small refactor?

## Communication style

- Do not use smart quotes or em dashes; use plain ASCII punctuation.
- Cut filler and ornamental phrasing when a plain alternative preserves the meaning.

## Response length

Default to a short answer. Detail is opt-in.

- Answer the question in 3 sentences or fewer, then stop. Put the conclusion first, not the buildup.
- Leave out supporting reasoning, alternatives considered, cost analysis, and caveats. If any of it matters, end with one short line offering it, such as "Reasoning available if you want it."
- Exceed the limit only when I ask for detail, or when acting on the short answer alone would be wrong or unsafe. Say which applies.
- Do not pad a short answer with headings, bullet lists, or a restatement of the question.
- I am a visual thinker. When explaining an unfamiliar concept, give one concrete example or a short analogy instead of abstract prose.
- These limits govern explanation, not correctness. Never drop a fact I need in order to keep the answer short; ask or flag instead.

## Completion summaries

When finishing code or configuration changes, provide a summary of at most three bullets:

- What changed
- Why those changes were made
- Any verification performed or skipped

## Code comments

- Comment what is not obvious from the code: intent, invariants, constraints, tradeoffs, side effects, exceptions, and caller obligations. Do not restate the code or the symbol name.
- Never include story IDs, ticket IDs, or issue keys in code comments or docstrings, such as `FUS-439` in `Add alarms for structured LLM failure events (FUS-439).` Keep comments focused on durable intent and behavior.
- Keep public interface docs focused on what callers need (behavior, arguments, return, side effects, preconditions); leave implementation detail out unless it affects correct use.

## Review findings

When triaging findings from a code review, a security review, or PR comments, sort every finding into one of three buckets and act on only the first.

- **Fix now:** a defect in code the current branch touched, where the correct fix is unambiguous. Fix it.
- **Needs your decision:** the fix requires a product, API, or architecture choice, or it contradicts the plan the branch is implementing. Present the options and the tradeoff. Do not pick one.
- **Out of scope:** a pre-existing issue, or a fix that would grow the branch beyond its plan. List it and offer to open a ticket. Do not fix it.

Never fold a "needs your decision" or "out of scope" finding into the branch. Surface both buckets as an explicit list rather than burying them in a summary, and stop for an answer before continuing.

## Destructive file operations

Do not use `rm` or `mv` directly. Use the safe wrapper scripts instead:

- **Delete:** `~/dotfiles/opencode/scripts/safe-rm.sh <paths...>`
- **Move/Rename:** `~/dotfiles/opencode/scripts/safe-mv.sh <sources...> <destination>`

These scripts only operate on git-tracked files within the repo root.

For untracked files, ask before deleting or moving them unless they were created during the current task.

## Committing changes

- **Default action: create a git commit, using [Conventional Commits](https://www.conventionalcommits.org/) format, when the task is complete.** Do not stop after editing files unless the user explicitly says not to commit.
- Before committing, review the working tree and include only changes that belong to the completed task. If unrelated user changes are present, leave them uncommitted.
- After making code changes, run the project's linter with auto-fix. If it changes files, commit those fixes separately with the message `Auto-format and lint fixes`.
- If there is nothing to commit, say so explicitly in the completion summary.
- Do not push to the remote repository.
