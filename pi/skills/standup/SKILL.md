---
name: standup
description: Write a one-minute standup update from yesterday's PRs in the named repos, one plain-English line per PR
disable-model-invocation: true
---

# Standup

Turn the previous working day's pull requests into a standup update the whole team can read in a minute, non-engineers included. The reader learns what changed for them, never how the code changed.

A repo is a bare name (`purrjump`, `fuse-analytics`) or `owner/name`. With no argument, use the repo of the current directory.

## Steps

1. Fix the window.
   - Run `date` for today's local date and weekday. The window is the previous working day, midnight to midnight local time: Monday reports Friday, every other weekday reports yesterday. On a weekend, report Friday.
   - Completion criterion: a start and end timestamp are written down before any PR is fetched.

2. Resolve every repo to `owner/name`.
   - A bare name resolves from the local checkout's origin when `~/<name>` is a git repo; otherwise search GitHub with `gh search repos <name> --owner <login> --owner <org>` across `gh api user --jq .login` and `gh api user/orgs --jq '.[].login'`.
   - Ask, as a numbered list, only when a name resolves to more than one repo or to none.
   - Completion criterion: each argument maps to exactly one `owner/name`.

3. Collect candidate PRs, then keep only PRs touched in the window.
   - List candidates with `gh pr list --repo <owner/name> --author @me --state all --search "updated:>=<window start date>" --json number,title,url,state,isDraft,mergedAt,createdAt,body`.
   - A PR is in the window when it was created, merged, or received a commit inside it. Check commits with `gh pr view <number> --repo <owner/name> --json commits --jq '.commits[].authoredDate'`; a PR whose only window activity was a comment or a bot push falls out of the standup.
   - Completion criterion: every candidate has been kept or dropped by the rule above, with none dropped on title alone.

4. Write one line per PR.
   - Read the title, body and `gh pr view <number> --repo <owner/name> --json additions,deletions,files` before writing, and carry the outcome across, not the mechanism. Files, modules, refactors and class names stay out of the line.
   - Prefix by status: merged is `Done:`, open is `In review:`, draft is `In progress:`.
   - One sentence, 20 words at most, in plain English, followed by the PR number as a link.
   - Example: the merged PR `refactor(render): carve the world scene out of the play screen` becomes `Done: separated the game's drawing code from the play screen so visual changes are safer to make ([#80](url))`.
   - Completion criterion: every kept PR has one line, and a non-engineer could say what each line delivers.

5. Assemble the standup.
   - One section per repo, headed `<name> - <weekday> <day> <month>`, with lines ordered Done, In review, In progress.
   - A repo with no kept PRs gets the single line `Nothing to report.`
   - Print the standup as the whole reply, ready to paste into chat; skip preamble, headings beyond the repo sections, and files on disk.
   - Completion criterion: the reply reads aloud in under a minute.
