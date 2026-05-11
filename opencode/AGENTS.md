## Scope

These instructions apply to all repositories where I use LLM coding agents and supplement higher-priority system/developer instructions.

## Instruction feedback

When the user gives an instruction, evaluate it before acting.

- If a non-trivial instruction is sound, briefly confirm agreement and proceed.
- If the instruction is risky, ambiguous, overcomplicated, or conflicts with existing guidance, explain the concern and recommend a better approach.
- If recommending a materially different approach, ask whether to follow the recommendation or continue with the user's original instruction.
- When clarification is needed, use the format in "Clarification before implementation."
- Do not challenge harmless stylistic preferences or small implementation choices unless they create a real downside.
- Keep feedback concise and practical.

## Clarification before implementation

When you need clarification before acting:

- Ask concise clarifying questions as a numbered list.
- Ask as many questions as needed to remove uncertainty.
- Make each question answerable in a short reply.
- If there are options, present them under the relevant numbered item.
- Do not ask for clarification in prose paragraphs.
- Express recommendations by marking an option with `(Recommended)`, not in a separate paragraph.
- Keep every question block user-facing; never include internal tags or reminders.

Required format:

1. <question>
   - A. <option>
   - B. <option>
2. <question>

Example:

1. Which approach do you want for authentication?
   - A. Session-based
   - B. JWT
2. Should this include tests?
3. Do you want a minimal patch or a small refactor?

## Destructive file operations

Do not use `rm` or `mv` directly. Use the safe wrapper scripts instead:

- **Delete:** `./opencode/scripts/safe-rm.sh <paths...>`
- **Move/Rename:** `./opencode/scripts/safe-mv.sh <sources...> <destination>`

These scripts only operate on git-tracked files within the repo root.

For untracked files, ask before deleting or moving them unless they were created during the current task.

## Completion summaries

When finishing code or configuration changes, provide a concise summary that includes:

- What changed
- Why those changes were made
- Any verification performed or skipped

## Committing changes

- **Default action: create a git commit when the task is complete.** Do not stop after editing files unless the user explicitly says not to commit.
- Before committing, review the working tree and include only changes that belong to the completed task.
- If unrelated user changes are present, leave them uncommitted and commit only the task-specific files.
- If there is nothing to commit, say so explicitly in the completion summary.
- For large tasks, group changes into logical commits that each capture a coherent change.
- Follow the [Conventional Commits](https://www.conventionalcommits.org/) format (e.g., `feat:`, `fix:`, `refactor:`, `docs:`, `chore:`).
- Do not push to the remote repository.
