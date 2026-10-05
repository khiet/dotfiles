---
name: explain-code-html
description: Use when the user wants an HTML explanation of a code change (commit range, branch, or PR) or of how part of a codebase works. To check a PR against its pr-skill body, use pr-walkthrough-html; for findings-focused reviews, use code-review.
---

# Explain Code

Produce one self-contained HTML walkthrough of a subject: a **change**, or a **topic** in the current code. The page lets an engineer understand the subject and check the explanation: every statement about behavior carries a locator, and what was executed is kept apart from what was read or inferred.

Read the shared files before step 1; evidence is recorded as locators from the start:

- [`../_shared/walkthrough/page.md`](../_shared/walkthrough/page.md), for every subject: verification statuses, narrative, opening, locators, code excerpts, writing style, length, theme, format, checks, and narration.
- [`../_shared/walkthrough/change.md`](../_shared/walkthrough/change.md), for a change: the evidence a change needs and the Scope check.

## 1. Gather evidence

Settle the subject from the request:

- **Change**: a commit range, a branch, or a PR. Base and head are the two ends the user names; for a PR, its `baseRefOid` and `headRefOid` from `gh pr view <number> --json title,body,headRefName,baseRefOid,headRefOid`; with neither named, `origin/main` and `HEAD`.
- **Topic**: a question about how something works, such as "how does the gmail integration work", in the repository the user names. The subject is the code at `HEAD`; there is no diff.

For a change, collect claims from the PR or issue description and the commit messages, then gather the rest per **Change evidence** in `change.md`.

For a topic, find every entry point: routes, jobs, webhooks, scheduled tasks, UI actions. Search by call graph as well as by name: list the callers of each module the topic owns and walk every caller chain up to the entry point that starts it, including entry points that belong to other features. Follow each to its effects: writes, outbound calls, emitted events. Record the state the topic owns, meaning what its code creates or is the main writer of, such as tables with their child tables, caches, cookies, and configuration keys, with every reader and writer of each, inside the topic's modules and outside them, found by searching the repository for its accessor, its relation fields on other models, or its key name. A configuration key's writers are every place that sets its value, CI workflows, deployment configuration, and test setup included. Read the tests on those paths, at every layer from route to adapter, found by searching the tests for imports of each module on the path, shared helpers included. Search every document in the repo for the topic's terms, read each one found in full, treat each statement about the topic as a claim, and check it against the code; statements that fail the same way share one record that names each of them.

For both, apply **Verification** in `page.md`.

Done for a change when the completion criterion under **Change evidence** holds. Done for a topic when every caller chain of the topic's modules ends at an entry point that is followed to its effects or listed as not followed, every piece of owned state has its readers and writers listed, and every document statement that disagrees with the code is recorded.

## 2. Choose the narrative

Build the narrative per **Narrative** in `page.md`. Give the representative input its old and new outcomes for a change, its current outcome for a topic.

Done when the example's outcomes follow from its starting state, and every behavioral change or entry point sits in a causal step, is folded as a repeat, or is named as omitted scope.

## 3. Write the walkthrough

Open the page per **Opening** in `page.md`. For a change, the answer is what behavior changes and why, with intent marked as inferred when no claim states it. For a topic, it is what the code does in reply to the question, naming the commit the page describes.

Then these sections, in order:

- **Before / after**, for a change: the representative input with its old and new outcome, each linked to the responsible code and to a covering test when one exists.
- **The pieces**, for a topic: the entry points, the owned state, and the external services, in one table or diagram, plus the fold that **Length** in `page.md` allows, each with its locator and its role in one line; a piece of owned state's row also names its readers and writers, and child tables written only with their parent share its row. An entry point outside the causal steps says whether it repeats a traced step, was followed on its own, or was not followed, and the fold and omitted scope that close **How it works** refer to those labels instead of repeating the list.
- **How it works**: the causal steps, laid out per **Narrative**.
- **Scope check**, for a change: per `change.md`, with the description and commits as its sources.
- **Check before trusting**: the failure modes, each a precondition the path relies on and what is observed when it does not hold; the test delta for a change, or for a topic the test that covers each causal step, each with its status, and the steps no test covers; document statements that disagree with the code, each with a locator for the statement and one for the code; and what remains unverified.

When the subject has a surprising behavior or invites a misconception, add an understanding check following [`../_shared/walkthrough/questions.md`](../_shared/walkthrough/questions.md).

Write under **Locators**, **Code excerpts**, **Writing style**, **Length**, **Theme**, and **Format** in `page.md`.

Done when the opening answer agrees with the sections under it, every entry point, piece of owned state, and document disagreement recorded in step 1 appears on the page, a change's carried rows appear outside the `<details>`, and the reading path fits **Length** in `page.md`.

## 4. Save, check, and narrate

Write to `$HOME/Desktop/<name>_<unix_timestamp>.html`, where `<name>` is the head branch of a change, or the topic in a few kebab-case words, with `/` replaced by `-`. Then run **Checks** in `page.md`, then **Narration**.

Done when the completion criteria under **Checks** and **Narration** hold.
