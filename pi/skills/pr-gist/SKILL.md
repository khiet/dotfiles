---
name: pr-gist
description: Give the 10-second gist of a PR in plain English. Use when the user passes a PR URL for a gist, or asks what a PR does at a high level.
---

Write a gist that a reader takes in within 10 seconds: three lines, at most 40 words. Read-only: the gist goes to the terminal and nowhere else.

## 1. Fetch the change

The target is the first of these that exists:

1. The PR passed as an argument, as a URL (`https://github.com/<owner>/<repo>/pull/<number>`) or a number.
2. The current branch's PR.
3. The current branch against `origin/main`, with no PR.

For a PR, pass its URL or number to `gh`, which reaches any repo from any directory:

```sh
gh pr view <pr> --json url,title,body,commits,closingIssuesReferences,files
```

Without a PR, use `git log origin/main..HEAD` and `git diff --stat origin/main...HEAD`.

Done when you hold the commit messages and the file list, plus the PR text when there is a PR.

## 2. Find the main piece

Pick from the file list the file where the behavior change is defined, which may not be the one with the most changed lines. A deletion qualifies when removal is the change. Discount markup, renumbering, and vendored, generated, or lockfile changes.

Fetch that file's patch and those of any tests covering it, which state the intended behavior. Take `<owner>`, `<repo>`, and `<number>` from the PR's `url`:

```sh
gh api --paginate repos/<owner>/<repo>/pulls/<number>/files --jq '.[] | select(.filename == "<path>") | .patch'
```

Without a PR, use `git diff origin/main...HEAD -- <path>`.

Done when you can say in one sentence what changes for someone using the system: what is added, what is removed, or, for a refactor, that behavior stays the same.

## 3. Write the lines

- **Why**: `<problem>, so <what it cost or what fixing it enables>`, with the problem stated generally and at its source in this PR's system, taken from the first source that gives one: the PR body (any section, so a Before under Evidence counts), a linked issue or ticket, then commit messages. A restatement of the change is not a reason. If no source gives one, write `Why: not stated`.
- **What**: the behavior change from step 2 as one idea, the way a teammate would say it aloud: `<subject> now <does what>`. Name the concrete new behavior, and include a limit only when leaving it out would mislead.
- **Risk**: the one worst thing that could go wrong, stated with its trigger, and how hard it is to undo. A required deploy order outranks everything else: name what must ship first and what breaks otherwise, at the breadth the PR gives rather than through one vendor or customer. Take these from `## Merge Danger` or any rollout or deploy section, translating rather than copying labels: a two-way Door is `easy to undo`, a one-way Door is `hard to undo`, a conditional rollback is `safe to undo only while <condition>`, and a Blast Radius becomes what could actually go wrong. Without such a section, infer both from the diff: migrations, deletions, public APIs, infra, and permissions.

Linked tickets: `closingIssuesReferences` covers GitHub issues only, so also look for ticket IDs in the body and commit messages, and read them through Linear when that tool is available.

Treat the PR body as claims about Door, Blast Radius, and scope. Compare them with the file list and the main piece's patch, fetching another patch only to settle a specific claim. A mismatch is something the file list or a patch directly shows that would change how much care the reader gives the PR, such as a two-way Door on a migration that drops data, or a file outside the stated scope. It opens the Risk line as a plain fact, as in the example below. Smaller omissions, and scenarios you reasoned out yourself, stay out.

Write in plain English, using the domain terms the PR itself uses, including command and product names. File paths, function names, and code stay out. Write constants as ordinary words (`pending`), and name the general class rather than listing its members (`most vendors`). Refer to another repo or PR by what it does (`the billing service`), with no number.

## 4. Report

Print the three lines, then the offer line:

```text
Why: One model reviewed its own branch, so its blind spots went unchecked.
What: wrap_up now also gets a second review from a different model.
Risk: Also adds a script the PR doesn't mention; easy to undo; costs Codex usage.

Ask for more on any line.
```

Draft to about 35 words. Done when you have counted the three lines word by word, labels included, and they total 40 or fewer, and every constant reads in lowercase. When cutting, keep the mismatch and how hard it is to undo, and trim detail from the rest.

## Why this shape

- **40 words**: adults read non-fiction silently at about [238 words per minute](https://www.bps.org.uk/research-digest/most-comprehensive-review-date-finds-average-persons-reading-speed-slower).
- **Why first**: reviewers [orient on context and rationale](https://arxiv.org/abs/2507.09637) before they analyze the code.
- **What from the main piece**: Google's review guide says to [take a broad view, then start at the main part](https://google.github.io/eng-practices/review/reviewer/navigate.html).
- **Risk last**: it answers how much care the PR deserves, in the Door and Blast Radius terms of the [`pr`](../pr/SKILL.md) skill.
