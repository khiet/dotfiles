---
name: pr-walkthrough-html
description: Use when the user wants an HTML walkthrough or explanation of a PR or a branch's diff. For findings-focused reviews, use code-review.
---

# PR Walkthrough

Produce one self-contained HTML walkthrough that zooms in on a PR body written with the `pr` skill, writing that body first when the PR has none. The page treats each of the body's statements as a claim, checks it against the code, and explains the mechanism behind it. Every statement about behavior carries a locator.

Read both rule files before step 1; evidence is recorded as locators from the start:

- [`page.md`](page.md): verification statuses, narrative, opening, locators, code excerpts, writing style, length, theme, format, and checks.
- [`change.md`](change.md): the evidence a change needs and the Scope check.

## 1. Gather evidence

Settle the change: the PR the user names, else the PR for the current branch, else the current branch. For a PR, fetch `gh pr view [<number>] --json body,headRefName,baseRefOid,headRefOid` and take `baseRefOid` as base and `headRefOid` as head. With no PR, base is `origin/main` and head is `HEAD`, and the head branch name stands in for `headRefName`.

Use the PR body as is when it has all three `pr` headings (`## Summary`, `## Evidence`, `## Merge Danger`); its **provenance** is `author`. Otherwise write a body with the [`pr`](../pr/SKILL.md) skill from the merge-base diff of base and head; its provenance is `generated`. Its Evidence carries the status of each test it cites, per **Verification** in `page.md`. The body stays local: on the page, and in step 4's Markdown file.

Collect claims from the body:

- **Summary**: each structural claim its view makes, such as a new call, a moved file, or a new branch in control flow; in a diff view, each added and each removed line, a removed line and its replacement counting as one.
- **Evidence**: each before/after, and each behavior a cited test or output is said to show.
- **Merge Danger**: the stated Door and the stated Blast Radius, each a claim of its own, and each checkable sentence under them.
- **Commit messages**, and a PR body without the `pr` headings: secondary claims.

Gather the rest per **Change evidence** in `change.md`, with the base and head settled above. Apply **Verification** in `page.md` to all of it, starting with the tests the body's Evidence cites.

Done when the body has all three `pr` headings, the completion criterion under **Change evidence** holds, and every test the body's Evidence cites has a status.

## 2. Choose the narrative

Build the narrative per **Narrative** in `page.md`, from a representative input that the Summary's view touches, with its old and new outcomes.

Done when the example's old and new outcomes follow from its starting state, and every behavioral change sits in a causal step or is named as omitted scope.

## 3. Write the walkthrough

Open the page per **Opening** in `page.md`. The answer is the verdict sentence. With an `author` body: does the code do what the PR body claims? With a `generated` body: what the change does, and which of the body's claims lack executed evidence. Name the largest divergence, if any, and state the provenance in the same sentence.

Then a closed `<details>` titled "PR body (author)" or "PR body (generated)" holding the body rendered as HTML, three sections that mirror it, and the Scope check. Take the form of each visual from the views under `### Summary` in [`../pr/SKILL.md`](../pr/SKILL.md).

- **Summary: how it works.** Zoom in on the PR's Summary view: trace the representative input through the old and new paths and show what the view leaves out. If the view shows `save -> invalidate cache`, name the cache entry, why invalidation happens there, and what the next read observes.
- **Evidence: why the outcomes follow.** For each before/after in the PR body: the causal step that makes the new outcome follow, what the cited test asserts, where that falls short of what the body says it shows, a mock that stands in for the code under claim included, and its status. Then the rest of the test delta and what remains unverified.
- **Merge Danger: how it could fail.** State whether the Door and Blast Radius hold, citing the code that decides it, or what the diff was searched for when the claim is an absence; for example, a two-way door claimed over a migration that drops a column. Then the concrete failure modes: each precondition the new path adds, and what a caller who misses it observes. Then the affected consumers and what rollback entails.
- **Scope check**, per `change.md`, with the PR body and commits as its sources. A claim the PR body itself marks as pending has no row; list it under Evidence as "Not checked".

When the change has a surprising behavior or invites a misconception, add an understanding check following [`questions.md`](questions.md).

Write under **Locators**, **Code excerpts**, **Writing style**, **Length**, **Theme**, and **Format** in `page.md`. Within that length, spend the words on mechanism and on what the PR body leaves out; a claim that simply holds needs only its Scope row.

Done when each mirrored section zooms in on its PR counterpart, the verdict sentence agrees with the Scope check, every carried row appears in its section above the `<details>`, and the reading path fits its length.

## 4. Save and check

Write to `$HOME/Desktop/<headRefName>_<unix_timestamp>.html`, with `/` replaced by `-`. With a `generated` body, also write its Markdown, ready for `gh pr create --body-file`, to the same path with `.md` in place of `.html`. Then run **Checks** in `page.md`.

Done when the completion criteria under **Checks** hold.
