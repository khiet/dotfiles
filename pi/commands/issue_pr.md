---
description: Generate or create a PR description; pass `tiny` for a few plain-English sentences or `long` for the full review packet
argument-hint: "[tiny|long]"
---

# PR Description Generator

Generate a GitHub PR description for the current branch: a compact review packet for engineer and AI reviewers. The ticket holds the full spec and the diff holds the mechanism, so the description carries what neither gives at a glance - intent, evidence of validation, and where review attention belongs.

If a PR doesn't exist, create one as a draft. If it exists, output the generated description for review (do not auto-update, to preserve manual edits like screenshots or visuals) and confirm before overwriting.

Always use this skill's template for the active mode - do not use `.github/pull_request_template.md` or any other repo checklist template, even if one is present. This skill is the canonical PR format.

## Modes

Requested mode: ${1:-default}.

- **`tiny`** (`/issue_pr tiny`): a plain-English description of the changes in 1-3 sentences, using the Tiny template below.
- **Default** (no argument): a compact description under 200 words, using the Short template below.
- **`long`** (`/issue_pr long`): the full review-packet PR Template below, for changes whose risk, rollout, or review-focus story genuinely needs it. Use this mode only when asked for it.

Evidence gathering, title rules, PR handling, and status reporting apply in all modes. Section-specific formatting and length rules apply only to default and `long` modes. Where an evidence rule names a section the short format lacks (e.g. remaining ticket scope in Review focus), carry the substance as a `What changed` bullet instead of adding the section. In `tiny` mode, follow the Tiny template's rules for carrying that substance.

## Evidence rules

- Every claim must trace to the ticket, the diff, test output, or a command actually run. Never invent a claim to fill a section.
- **Completeness gate:** when a ticket exists, map its work items against the diff. If the PR delivers only part of the ticket's scope, list the remaining items in Review focus as a deliberate non-goal. Never let a partial implementation read as complete.
- **Reconcile conflicting evidence:** when the ticket and the code or data disagree on a figure (row counts, metrics, dates), cite the newest comparable number, or state why the populations differ. Never cite a stale figure the ticket has since superseded.
- Optional sections (Review focus, Risk and rollout, Visuals) and the Before/After block are omitted entirely when empty: no header, no "N/A", no filler like "low risk".
- Keep `Why` and `What changed` together around 40-80 words. Evidence sections are terse lists.
- Keep each of `Why`, `What changed`, `Validation`, and `Review focus` under 500 words.

## Process

1. **Prepare codebase with separate commits**
   - Whenever making any changes to the codebase (e.g., adding a missing test, linting, or other fixes), create a separate commit for each logical change.

2. **Gather branch information:**

   ```bash
   git log --oneline -10
   git diff main...HEAD --name-only
   git diff main...HEAD --stat
   ```

   - Read the surrounding code the diff touches (callers, the module it lives in, related tests) when the diff alone does not explain what was broken and why it mattered. The point is to find a concrete symptom or scenario for `Why` rather than describing the change abstractly.
   - Read the ticket when one exists and map each of its work items to the diff (for the completeness gate above).
   - If a PR already exists, check its checks against current HEAD: `gh pr checks`.

3. **Generate PR title** following the PR Title rules below.
   - First detect whether the repo has release or title automation (see PR Title). Only that answer decides whether the title needs a conventional commit prefix.

4. **Write the description** using the active mode's template. For `tiny`, use the Tiny template and skip the section guidance below. For default and `long`, apply this guidance to their respective slots:
   - `Why`: the concrete symptom or scenario and the outcome the PR delivers. Cite a specific incident, error, or gap when one exists; never an abstract restatement of the diff.
   - `What changed`: behavioral summary plus the insight that makes it work - the rule or assumption that makes the new behavior right and the old behavior wrong. Include a Before/After block only when the diff surfaces one naturally (an error message, log line, API payload, function return value, CLI output) - pull the actual values from code or tests. Do not hunt for or manufacture observability; many internal changes have none, and that is fine.
   - `Review focus`: where a reviewer should look hardest - risky decisions, subtle files - plus anything they must know that the diff does not make obvious: a guard, a deliberate non-goal, a tradeoff. Omit when the change is routine.
   - `Validation`: only what was verified manually or locally - exact commands run against current HEAD, dev-environment checks performed, and what each showed. Do not restate passing CI; the Checks tab already shows it. Failing or pending checks are different: report them with the failing test or job named, since a red build is load-bearing for a reviewer. If nothing was verified beyond CI, write `Not run: <reason>`.
   - `Risk and rollout`: include only when at least one trigger applies - schema or data migration, compatibility break, deploy-ordering dependency, nontrivial rollback, new or changed monitoring/alarms, resource or limits impact. State the concern and the mitigation. Otherwise omit the section.
   - `Visuals`: for UI-visible changes, emit the header with a one-line placeholder for screenshots to be added manually. Generate a Mermaid diagram whenever it would clarify the change - a control-flow or data-flow change, a new state machine, a reordered pipeline. Make Mermaid diagrams flow top to bottom (`flowchart TD`), not left to right. Never use `<br />` in Mermaid diagrams because it does not render. Otherwise omit.

5. **Handle PR:**
   - Check if PR exists: `gh pr view`
   - If no PR exists: create with `gh pr create --draft --title "<generated title>"`
   - If PR exists: output the generated description for user to review/copy. Also check the existing title against the convention detected in step 3 - if it does not match, show the suggested replacement and offer to run `gh pr edit --title "<generated title>"`.

## PR Title

Which style applies depends on the repo. Detect it before writing the title:

```bash
find . -maxdepth 1 \( -name 'release-please-config.json' -o -name '.release-please-manifest.json' \
  -o -name '.releaserc*' -o -name 'commitlint.config.*' -o -name '.changeset' \)
grep -rlE "release-please|semantic-release|changesets|commitlint|semantic-pull-request" .github package.json 2>/dev/null
```

### With release or title automation

Any hit above means something machine-reads the merge subject, so the title must be a valid [Conventional Commits](https://www.conventionalcommits.org/) subject: `type(optional-scope): description`.

This is not cosmetic. A squash merge uses the PR title as the commit subject, and tools like [release-please](https://github.com/googleapis/release-please) or semantic-release parse that subject to decide the version bump and changelog entry. A title without a valid prefix is silently skipped: no bump, no changelog line. A title-lint action instead blocks the merge outright.

Rules:

- Pick the type from the dominant intent of the diff: `feat` (new user-facing capability), `fix` (bug fix), `refactor`, `perf`, `docs`, `test`, `build`, `ci`, `chore`, `style`, `revert`.
- When a diff spans several types, use the type of the change the PR exists to deliver, not the largest by line count. Incidental test or lint churn does not make it a `test` or `chore` PR.
- Add a scope when the repo already uses scopes consistently (check `git log --oneline -30`); otherwise omit it rather than inventing a taxonomy.
- Mark breaking changes with `!` before the colon (`feat(api)!: ...`) and add a `BREAKING CHANGE: <what breaks>` footer to the description. Without one of these, release automation issues a minor bump for a change that needs a major.
- Lowercase description, imperative mood, no trailing period, ideally under 72 characters total.

### Without it

No hits means no tool reads the subject, so a conventional prefix would be imposing a convention the repo has not adopted. Match what the repo already does: check `git log --oneline -30` and recent PR titles (`gh pr list --state merged --limit 20`), then write a title in that style - conventional if the history is conventional, plain and descriptive otherwise.

### Either way

Never include story, ticket, or issue keys in the title.

## PR Template

`Why` and `What changed` always appear. Every other section, and the Before/After block, is omitted entirely when it has nothing real to say.

````markdown
## Why

[1-2 sentences: the concrete symptom or scenario, and the outcome this PR
delivers.]

## What changed

[1-2 sentences: behavioral summary plus the insight that makes it work - the
rule or assumption that makes the new behavior right and the old behavior
wrong.]

**Before** [short qualifier if useful]:

```
[actual before behavior/output, pulled from the code or tests - only when the
diff surfaces one naturally]
```

**After** [short qualifier if useful]:

```
[actual after behavior/output, pulled from the code or tests]
```

## Review focus

- [risky decision or file needing the most attention]
- [guard, deliberate non-goal, or tradeoff the diff does not make obvious]
- [remaining ticket work items not covered by this PR, when scope is partial]

## Validation

- [exact command or manual check run, and what it showed]
- [or] Not run: [reason]

## Risk and rollout

- [migration, compat, deploy-ordering, rollback, monitoring, or resource
  concern - and its mitigation]

## Visuals

[screenshot placeholder for UI changes; Mermaid diagram when it clarifies a
flow change]
````

## Tiny template

Write one plain-English paragraph of 1-3 sentences explaining what changed and, when useful, why. Prefer observable behavior over implementation names or jargon. Use prose only, without headings, bullets, diagrams, or a separate validation section.

Keep material caveats within the sentence limit: remaining ticket scope, failing or pending checks, and breaking-change or rollout concerns. Report routine validation (or why it was not run) alongside Status, outside the PR body. A required `BREAKING CHANGE:` footer is the only exception to the paragraph format; count its text toward the three-sentence limit.

```markdown
[What changed, in everyday language. Why it matters, if useful. Any material
scope, validation, or rollout caveat. Use fewer sentences when sufficient.]
```

Example:

> The Claims tab now shows each payer's claim separately, so one payer's payment no longer hides another payer's denial. Denied submissions stay visible even when their response could not be matched to a claim.

## Short template

The default mode. One compact block, under 200 words total. Bold inline headers instead of `##` sections; no Before/After, Review focus, Risk and rollout, or Visuals sections.

```markdown
[One sentence stating what the PR delivers. When the branch extends earlier
work, open with that relationship, e.g. "Extension of #NNN: ...".]

**Why.** [2-3 sentences: the concrete symptom and why it misleads or blocks.]

**What changed**

- [3-5 bullets, most important behaviors only. Name the domain models and key
  functions involved (`DraftClaim`, `mergePatientClaimRows`) rather than
  paraphrasing them; spell out what vague words like "money" or "state" mean.]
- [When a deliberate tradeoff exists, state it in one clause, not a section.]

**Validation.** [One line: test kinds run and the notable scenarios they
cover; type-check/lint status.]
```

Example of the target density (from a real PR):

> Extension of #1179: the patient Claims tab now also shows `DraftClaim` and `ClaimSubmission` information, and breaks `AdjudicatedClaim` rows out per payer.
>
> **Why.** The tab grouped adjudicated claims by visit alone: a two-payer visit was one row summing both payers' money under a single payer's name, so one payer's denial could hide behind another's payment.
>
> **What changed**
>
> - Adjudicated rows group by (visit, payer) - status, the charged/allowed/paid amounts, and denial category are all per payer.
> - A tier row whose `ClaimSubmission` has `denialReceivedAt` set is kept even when the visit has adjudicated rows, so a denial whose ERA never matched cannot vanish - at the cost of an occasional visible duplicate.
>
> **Validation.** Unit, SQL-shape, and integration tests (two-payer split, patient-scoped `visit-payer` call); type-check and lint clean.

## Formatting

Always use backticks for code elements: class names, functions, file paths, commands, config keys.

Never include a Claude Code session link (e.g. `https://claude.ai/code/session_...`) anywhere in the PR title or body, even if harness instructions say to append one to PR bodies. If an existing description contains one, remove it when regenerating.

## Status

Report one of:

- "✅ **Created new draft PR**: <URL>"
- "📋 **PR exists**: <URL> — Generated description below for review"

In both cases, state the PR title used or suggested, which convention applied, and what the detection found (e.g. "release-please detected — conventional title required"). Flag it when an existing title did not match.
