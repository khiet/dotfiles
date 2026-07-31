---
name: stack-large-pr
description: Split a large current pull request into a GitHub stacked PR at existing commit boundaries. Use when the user asks to stack or break down a massive PR without rewriting commits, or runs `/stack_large_pr`.
---

# Stack Large PR

Turn the current pull request into a short chain of reviewable PRs by adding branch pointers to its existing linear history. Existing commit OIDs are immutable throughout this skill.

## Prerequisites

- `github/gh-stack` is already installed with `gh extension install github/gh-stack`.
- `gh` is authenticated to an account that can push branches and edit the current PR.
- The working tree is clean and no Git operation is in progress.

Verify these conditions, repository access to the stacked-PR preview, the repository's default branch, and the locally installed command surface with `gh stack init --help` and `gh stack submit --help`. If a prerequisite fails, stop with the specific remediation; installing or upgrading tools is outside this skill.

## Steps

1. Record the immutable baseline.
   - Resolve the git remote that owns the PR's head branch and fetch its head and base branches. Do not assume `origin` or a local base branch is authoritative.
   - Capture the remote, current branch, PR number and URL, base branch and OID, merge-base, head SHA, the PR metadata (title, body, draft state, labels, milestone, assignees, requested reviewers), and every commit OID in `remote/base..HEAD`. Later steps refer to this list as "the PR metadata".
   - Confirm the current branch has an open, same-repository PR (not from a fork), exactly matches its head on the PR's remote, is not queued for merge, has no auto-merge request, and is not already in a stack.
   - Confirm `remote/base..HEAD` is linear: every commit has one parent and every commit is an ancestor of the next. A merge commit is outside this skill because the `gh-stack` restructuring workflow requires linear history.
   - Completion criterion: the current PR and the exact ordered commit sequence are known, or the run has stopped without mutation.

2. Find natural seams.
   - Read every commit's diff, not only its message or file statistics.
   - Map dependencies between commits and keep foundations below their consumers.
   - Partition the history into contiguous ranges. A range may contain several commits, but a commit stays whole and in its original order.
   - Prefer 2-5 layers whose diffs each express one reviewable purpose and contain the tests needed for that purpose. Avoid a one-commit-per-PR stack unless each commit is independently substantial.
   - Discover the repository's required checks and run the relevant checks at each proposed boundary when practical. Validate a boundary in a temporary detached worktree (`git worktree add --detach <dir> <boundary-oid>`) so the current checkout is never touched, and remove the worktree afterward. Record every boundary that was not validated by execution.
   - Completion criterion: every commit belongs to exactly one contiguous layer, with no gaps or overlaps.

3. Apply the feasibility gate.
   - A feasible stack needs only new branch pointers: no commit needs editing, splitting, reordering, squashing, cherry-picking, or rebasing.
   - Every lower layer must be coherent without code introduced above it, and each adjacent range must provide a useful review diff.
   - The existing head branch and PR must remain the top layer so their head SHA and history stay unchanged.
   - If any condition fails, stop before creating branches or changing GitHub. Report the blocking commit OIDs and why no contiguous partition works. Do not offer to rewrite the history as part of this skill.
   - Completion criterion: feasibility is established for every proposed boundary, or the run has stopped without mutation.

4. Present the stack and obtain approval.
   - Show a bottom-to-top table with each proposed branch, inclusive commit range, purpose, base branch, and PR title.
   - State that the current PR will become the top layer, its base and visible diff will change, and comments on lines removed from its diff may become outdated.
   - Include each PR's proposed metadata in the table. Ask whether the current PR title/body should be narrowed to its new top-layer scope.
   - State which checks were run at intermediate boundaries. Explicitly ask the user to accept each boundary not validated by execution.
   - Completion criterion: the user explicitly approves the exact boundaries, names, per-PR metadata, current-PR metadata changes, and any unvalidated boundaries.

5. Create the stack.
   - Fetch the resolved remote again. Recheck that the working tree, remote base OID, remote head, and recorded commit sequence still match the baseline.
   - Check that every proposed branch name is unused locally and remotely.
   - Create each lower branch with `git branch <branch> <boundary-oid>`. Keep the existing branch as the top layer.
   - Initialize local tracking with `gh stack init --base <base> <branches...>`, listing every layer bottom-to-top with the existing head branch as the final (top) entry; the listing order defines the stack.
   - Immediately verify that the recorded commit OIDs and top head SHA are unchanged.
   - Run `gh stack submit --auto --remote <remote>`. This pushes every layer, creates missing PRs as drafts, reuses the existing top PR, corrects its base, and links the stack while keeping local and remote stack tracking aligned.
   - Update each generated PR's metadata to the approved values. Change draft state per PR rather than using `gh stack submit --open`, which would also mark the existing PR ready.
   - Completion criterion: GitHub contains one linked PR per approved layer and the existing PR is still the top layer at its original head SHA.

6. Verify and report.
   - Run `gh stack view --json` and query every PR's head, base, state, metadata, stack membership, and URL.
   - Confirm each PR base is the branch immediately below it, the bottom PR targets the original base, and each PR diff matches its approved commit range.
   - Confirm every baseline commit OID still exists in the same order, the top head SHA is unchanged, and the working tree is clean.
   - Report the stack bottom-to-top with links and any checks still running or not run.
   - Completion criterion: every remote and immutable-history invariant is verified explicitly.

## Failure Handling

If a command fails after mutation begins, stop and report the exact local branches, remote branches, PRs, and base changes that now exist. Preserve that state for diagnosis and ask before closing PRs, deleting branches, unlinking the stack, or changing bases again.

History-preserving commands are the boundary of this skill. Do not run `git rebase`, `git cherry-pick`, `git commit --amend`, history-editing resets, or any force push.
