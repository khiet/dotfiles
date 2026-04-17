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

## Committing changes

- Create a git commit only after all changes for a task are complete.
- For large tasks, group changes into logical commits that each capture a coherent change.
- Follow the [Conventional Commits](https://www.conventionalcommits.org/) format (e.g., `feat:`, `fix:`, `refactor:`, `docs:`, `chore:`).
- Do not push to the remote repository.
