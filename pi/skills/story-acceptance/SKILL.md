---
name: story-acceptance
description: Write a BDD-style acceptance document for a finished story, grouped into user journeys, for a Playwright agent to execute and report back on.
disable-model-invocation: true
---

# Story Acceptance

Turn a finished story into one acceptance document that a Playwright agent can execute end to end and report back on. The document lives outside the repository and stays out of every commit.

The invocation arguments carry the run's extra context: a mock design the UI must match, an environment to use, areas to leave out. Treat them as requirements and fold them into the document.

## Workflow

1. Scope the story.
   - Resolve the issue ID from the arguments; with none given, infer it from the branch name and confirm it with the user before continuing.
   - Fetch the issue and every sub-issue, and copy out the acceptance criteria verbatim.

2. Scope the shipped code.
   - Diff the branch against the main branch, and read every changed file that affects what a user can see or do.
   - Completion criterion: every user-visible change in the diff is named.

3. Reconcile the two into a numbered feature list.
   - The list is the union of the criteria from step 1 and the changes from step 2.
   - Mark each entry as covered by both, a criterion with no code, or code with no criterion. Carry the last two into step 4 as questions.
   - Completion criterion: every acceptance criterion and every user-visible change is either a numbered feature or explicitly out of scope.

4. Grill the user.
   - Ask for everything the runner needs and the document cannot invent: the URL or environment to test against, the test account, how to seed or reset data, areas to leave out, and the mismatches from step 3.
   - Ask as a numbered list with lettered options, and wait for the answers.
   - Skip only the questions the arguments already answer.

5. Group the features into journeys.
   - A journey is one persona pursuing one goal; an example inside it is a single continuous session through the product.
   - Pack each example with as many features as a real user would hit in that one sitting, and prefer a few dense journeys over many thin ones.
   - Completion criterion: a coverage map placing every numbered feature in at least one example.

6. Write the document to `$HOME/Desktop/<unix_timestamp>_<story-id>_acceptance.md`, following [`DOCUMENT.md`](DOCUMENT.md).
   - Put the step 4 answers and the invocation arguments into the document's Context section, where the runner reads them.

7. Report the file path, a coverage summary, and any feature left out with the reason.

## Boundaries

- Produce the document only. Playwright code, test files, and repository changes belong to other skills.
- Keep the document on the Desktop, outside the repository, and out of every commit.
