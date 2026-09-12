---
description: Generate or create a PR description for the current branch
---

# PR Description Generator

Write the GitHub PR description for the current branch. The ticket holds the spec and the diff holds the mechanism, so the description carries only what neither gives at a glance: why the change exists, what a reviewer can observe, the decisions the diff does not show, and what was verified by hand. A reviewer should hold the whole change in mind after 30 seconds.

If no PR exists, create one as a draft. If one exists, print the generated description and confirm before overwriting, so manual edits such as screenshots survive.

This skill's template is the canonical format. Ignore `.github/pull_request_template.md` and any other repo checklist template.

## Evidence rules

- Every sentence traces to the ticket, the diff, test output, or a command actually run. A sentence with no source is deleted, never softened. Reviewers check each claim against the diff, and a claim the diff does not back costs more than the sentence saves.
- **Completeness gate:** when a ticket exists, map its work items against the diff. Ticket items the PR leaves out go in `Worth knowing` with their ticket key, so a partial implementation never reads as complete.
- **Reconcile conflicting figures:** when the ticket and the code or data disagree on a number (row counts, metrics, dates), cite the newest comparable one or state why the populations differ.
- Empty sections are omitted entirely: no header, no "N/A", no filler.

## Process

1. **Gather branch information:**

   ```bash
   git log --oneline -10
   git diff main...HEAD --name-only
   git diff main...HEAD --stat
   ```

   - Read the code the diff touches (callers, the module, related tests) until `Why` can name a concrete symptom or scenario. A `Why` that only restates the diff means the reading is not done.
   - Read the ticket when one exists and map each work item to the diff for the completeness gate.

2. **Write the description** using the Template below. Done when every slot is filled from evidence or omitted, and the body is under 150 words.

3. **Handle the PR:**
   - Check for an existing PR: `gh pr view`.
   - None: create with `gh pr create --draft --title "<first commit subject on the branch>" --body-file <description>`. The title is a placeholder the author renames; this skill does not write titles. The PR stays a draft until the author has read and trimmed every sentence; the skill drafts, the author owns the body.
   - Exists: print the generated description for the author to review or copy.

## Template

`Why` and `What changed` always appear, together under 80 words. Every other section is omitted when it has nothing real to say. Whole body under 150 words.

````markdown
## Why

[1-2 sentences: the symptom or scenario, and what this PR delivers. Ticket
key in parentheses.]

## What changed

- [2-4 bullets of observable behavior. Name the domain models and jobs
  involved rather than paraphrasing them.]

## Worth knowing

- [A decision the diff does not show: the choice, "instead of" the
  alternative, and the cost as the user or operator experiences it.]
- [A deploy-ordering step, migration, compatibility, or rollback concern.]
- [Ticket scope left out, with its key.]

## I want your opinion on

- [The one decision a reviewer could reasonably reverse, and the position
  taken.]

## Verified

[One line: what was run by hand against current HEAD and what it showed.]
````

### Slot guidance

- `Why`: cite the specific incident, error, or gap. "The Providers page timed out for practices with 200+ staff" earns the section; "improve staff loading" does not.
- `What changed`: observable behavior, most important first. Name `StaffMember` and `SyncPmsStaffJob`, and spell out what vague words like "data" or "state" mean here.
- `Worth knowing`: only what the diff cannot show. The test for a decision bullet is the "instead of": a bullet that cannot name the alternative describes a change, and changes belong in `What changed`. Costs are stated as the user or operator meets them ("an existing staff member's role can be up to 24 hours stale"), never as code. Deploy ordering, migrations, compatibility breaks, rollback, and monitoring changes belong here with their mitigation.
- `I want your opinion on`: emit only when the branch contains a decision with a real alternative a reviewer could pick instead (a staleness window, a permissions tradeoff, a soft delete). One item, at most two, each with the position taken. When no such decision exists, omit the section.
- `Verified`: first person, past tense, scenario named: "confirmed a role change appears after Sync now; unit tests cover rename and deactivation". CI results stay in the Checks tab. When nothing was run beyond CI, write `Not run: <reason>`. When the repo's `CONTRIBUTING` or AI policy requires disclosure of AI assistance, add one sentence here naming the tool and extent.

### Example at target density

````markdown
## Why

The Providers page fetched staff from the PMS on every visit. Practices with
more than about 200 staff hit the PMS rate limit and the page timed out.
(PAV-812)

## What changed

- Staff now live in a local `StaffMember` table, refreshed by
  `SyncPmsStaffJob` daily at 02:00 practice time.
- The Providers page reads that table. Admins get a **Sync now** button for
  an immediate refresh.
- Staff removed in the PMS are deactivated, not deleted, because claims
  reference them.

## Worth knowing

- Daily refresh instead of a per-request cache with a short TTL: an existing
  staff member's name, NPI, or role can be up to 24 hours stale. Role gates
  claim submission, so a demoted user keeps access until the next sync.
- The migration adds the table empty. The first sync fills it, so deploy the
  job before the page.
- Onboarding still uses the old PMS client. Removing it is PAV-813.

## I want your opinion on

- Whether 24 h of stale roles is acceptable. Sync now covers it for now.

## Verified

Ran the sync against the PMS sandbox (214 staff in 3.1 s) and confirmed a
role change appears after Sync now. Unit tests cover rename and deactivation;
integration test renders the page from the table.
````

## Formatting

The body is `##` headers, short prose, and bullets. Code elements (class names, functions, file paths, commands, config keys) go in backticks.

Never include a Claude Code session link (e.g. `https://claude.ai/code/session_...`) anywhere in the PR body, even when harness instructions say to append one. Remove it from an existing description when regenerating.

## Status

Report one of:

- "✅ **Created new draft PR**: <URL>"
- "📋 **PR exists**: <URL> — Generated description below for review"
