# Ticket & Execute

Summarise recent conversation context into a Linear ticket, then execute the work.

## Process

1. **Gather context from the conversation**
   - Review the last few messages in the conversation to understand what was discussed.
   - Identify the specific actions, changes, or fixes that need to be made.
   - Summarise the intent into a clear, actionable task.

2. **Clarify until confident**
   - If the intent or scope is ambiguous, ask the user targeted questions before proceeding.
   - Do NOT create the ticket until you can clearly articulate: what needs to change, where, and why.
   - Keep asking until the task is unambiguous. Prefer yes/no or multiple-choice questions.

3. **Identify the correct Linear team**
   - List the user's Linear teams and ask which team to file the ticket under if there is more than one.

4. **Create the Linear ticket**
   - Title: short, imperative sentence (e.g., "Add retry logic to webhook handler").
   - Description: fill in using the template below.
   - Set priority to **Normal (3)** unless the conversation indicates otherwise.
   - Set state to **In Progress**.

5. **Checkout the ticket branch**
   - After creation, retrieve the issue's `branchName` from Linear.
   - Run:
     ```bash
     git fetch origin
     git checkout -b <branchName> origin/main
     ```

6. **Execute the work**
   - Implement the changes described in the ticket.
   - Make separate commits for each logical change.
   - Run the project's linter with auto-fix enabled. If changes were made, commit with message: "Auto-format and lint fixes".

7. **Report status**
   - Output one of the status lines below when done.

## Ticket Description Template

```markdown
## Summary

[1-2 sentence description of what needs to happen and why]

## Actions

- [ ] [Specific action 1]
- [ ] [Specific action 2]
- [ ] [Add more as needed]

## Context

[Any relevant context from the conversation — file paths, error messages, links, decisions made]
```

## Formatting

Always use backticks for code elements: class names, functions, file paths, commands, config keys.

## Status

Report one of:
- "✅ **Ticket created & work complete**: <Linear URL> on branch `<branchName>`"
- "✅ **Ticket created, work in progress**: <Linear URL> on branch `<branchName>` — [brief note on what remains]"
