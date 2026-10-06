---
name: pr-walkthrough-html
description: Use when the user wants a deeper HTML walkthrough of a PR after reading its body. For findings-focused reviews, use code-review.
---

# PR Walkthrough

Produce one self-contained HTML walkthrough that zooms in on a PR body written with the `pr` skill. The reader has just read that body, so the walkthrough treats each of its statements as a claim, checks it against the code, and explains the mechanism behind it. Every statement about behavior carries a locator.

Read both shared files before step 1; evidence is recorded as locators from the start:

- [`../_shared/walkthrough/page.md`](../_shared/walkthrough/page.md): verification statuses, narrative, opening, locators, code excerpts, writing style, length, theme, format, and checks.
- [`../_shared/walkthrough/change.md`](../_shared/walkthrough/change.md): the evidence a change needs and the Scope check.

## 1. Gather evidence

Fetch the PR for the current branch, or the one the user names: `gh pr view [<number>] --json body,headRefName,baseRefOid,headRefOid`. Continue once the body has all three `pr` headings (`## Summary`, `## Evidence`, `## Merge Danger`); otherwise stop and report that no PR exists or which headings are missing.

Collect claims:

- **Summary**: each structural claim its view makes, such as a new call, a moved file, or a new branch in control flow; in a diff view, each added and each removed line, a removed line and its replacement counting as one.
- **Evidence**: each before/after, and each behavior a cited test or output is said to show.
- **Merge Danger**: the stated Door and the stated Blast Radius, each a claim of its own, and each checkable sentence under them.
- **Commit messages**: secondary claims.

Gather the rest per **Change evidence** in `change.md`, with `baseRefOid` as base and `headRefOid` as head. Apply **Verification** in `page.md` to all of it, starting with the tests the PR's Evidence cites.

Done when the completion criterion under **Change evidence** holds and every test the PR's Evidence cites has a status.

## 2. Choose the narrative

Build the narrative per **Narrative** in `page.md`, from a representative input that the Summary's view touches, with its old and new outcomes.

Done when the example's old and new outcomes follow from its starting state, and every behavioral change sits in a causal step or is named as omitted scope.

## 3. Write the walkthrough

Open the page per **Opening** in `page.md`. The answer is the verdict sentence: does the code do what the PR body claims? Name the largest divergence, if any.

Then three sections that mirror the PR body, followed by the Scope check. Take the form of each visual from the views under `### Summary` in [`../pr/SKILL.md`](../pr/SKILL.md).

- **Summary: how it works.** Zoom in on the PR's Summary view: trace the representative input through the old and new paths and show what the view leaves out. If the view shows `save -> invalidate cache`, name the cache entry, why invalidation happens there, and what the next read observes.
- **Evidence: why the outcomes follow.** For each before/after in the PR body: the causal step that makes the new outcome follow, what the cited test asserts, where that falls short of what the body says it shows, a mock that stands in for the code under claim included, and its status. Then the rest of the test delta and what remains unverified.
- **Merge Danger: how it could fail.** State whether the Door and Blast Radius hold, citing the code that decides it, or what the diff was searched for when the claim is an absence; for example, a two-way door claimed over a migration that drops a column. Then the concrete failure modes: each precondition the new path adds, and what a caller who misses it observes. Then the affected consumers and what rollback entails.
- **Scope check**, per `change.md`, with the PR body and commits as its sources. A claim the PR body itself marks as pending has no row; list it under Evidence as "Not checked".

When the change has a surprising behavior or invites a misconception, add an understanding check following [`../_shared/walkthrough/questions.md`](../_shared/walkthrough/questions.md).

Write under **Locators**, **Code excerpts**, **Writing style**, **Length**, **Theme**, and **Format** in `page.md`. Within that length, spend the words on mechanism and on what the PR body leaves out; a claim that simply holds needs only its Scope row.

Done when each mirrored section zooms in on its PR counterpart, the verdict sentence agrees with the Scope check, every carried row appears in its section above the `<details>`, and the reading path fits its length.

## 4. Save and check

Write to `$HOME/Desktop/<headRefName>_<unix_timestamp>.html`, with `/` replaced by `-`. Then run **Checks** in `page.md`.

Done when the completion criteria under **Checks** hold.
