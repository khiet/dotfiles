---
description: Plan safe remediation for open GitHub Dependabot security alerts
model: openai/gpt-5.5
---

# Plan Dependabot Alerts

Inspect open GitHub Dependabot security alerts and produce a safe remediation plan.

This command operates in Plan mode only. Do not edit files, create branches, commit, push, merge PRs, or run dependency update commands. Only inspect the repository, GitHub alerts, package metadata, changelogs, and existing code usage.

## Usage

```bash
/plan_dependabot_alerts [optional repo]
```

Examples:

```bash
/plan_dependabot_alerts
/plan_dependabot_alerts khiet/dotfiles
```

## Arguments

- `$ARGUMENTS` - Optional GitHub repository in `owner/repo` format. If omitted, infer the repo from the current git remote.

## Command Implementation

You are tasked with creating a safe remediation plan for open Dependabot security alerts.

### Steps to Execute

1. **Identify the repository**
   - If `$ARGUMENTS` includes `owner/repo`, use that repository.
   - Otherwise, infer the GitHub repository from `git remote -v`.
   - Confirm the Dependabot alerts URL: `https://github.com/<owner>/<repo>/security/dependabot`.

2. **List open Dependabot security alerts**
   - Use GitHub CLI/API:
     ```bash
     gh api "repos/<owner>/<repo>/dependabot/alerts?state=open" --paginate
     ```
   - If API access is unavailable, explain the permission issue and provide the exact GitHub URL for manual review.
   - Capture for each alert:
     - Alert number
     - Dependency name
     - Ecosystem/package manager
     - Manifest path
     - Severity
     - GHSA/CVE
     - Vulnerable requirement
     - Patched versions
     - Current alert state
     - Any existing Dependabot PR URL

3. **Detect project ecosystem**
   - Inspect repository files to determine package ecosystems:
     - `Gemfile` / `Gemfile.lock` -> Ruby / Bundler
     - `package.json` plus `yarn.lock`, `package-lock.json`, or `pnpm-lock.yaml` -> Node/npm/yarn/pnpm
     - `requirements.txt`, `poetry.lock`, or `Pipfile.lock` -> Python
     - `go.mod` / `go.sum` -> Go
     - `Cargo.toml` / `Cargo.lock` -> Rust
     - `composer.json` / `composer.lock` -> PHP
   - A repository may contain multiple ecosystems. Group alerts by ecosystem and manifest path.

4. **Check existing remediation PRs**
   - Look for open Dependabot PRs:
     ```bash
     gh pr list --state open --author app/dependabot --json number,title,url,headRefName,baseRefName,mergeable,statusCheckRollup
     ```
   - Match PRs to alerts by dependency name, manifest path, and target version.
   - Prefer existing PRs when they cleanly address alerts and pass safety checks.

5. **Determine the safe fixed version**
   - For each alert, identify the minimum patched version from the advisory.
   - Compare the required update type:
     - Patch: usually safest
     - Minor: requires release-note and usage review
     - Major: requires manual review unless the codebase clearly has no affected usage and tests are strong
   - If multiple alerts affect the same dependency, choose the lowest version that fixes all relevant alerts unless a higher version is clearly safer or already used by an existing PR.

6. **Perform breaking-change safety review**
   - Review Dependabot PR bodies, advisories, changelogs, release notes, and package migration guides.
   - Search the codebase for usage of each affected package:
     - Ruby: `app/`, `lib/`, `config/`, `spec/`, `test/`
     - JavaScript/TypeScript: `src/`, `app/`, `lib/`, `components/`, `pages/`, `test/`, `__tests__/`
     - Python: `src/`, `app/`, `tests/`
     - Go: `*.go`
     - Rust: `src/`
     - PHP: `src/`, `app/`, `tests/`
   - Also check package-specific configuration files and initializers.
   - Flag risk if release notes mention:
     - Breaking changes
     - Removed APIs
     - Deprecated APIs used by the repo
     - Changed defaults
     - Runtime behavior changes
     - Build/toolchain changes
     - Required migrations

7. **Assess whether alerts can be addressed together**
   - Prefer a single remediation branch/PR when:
     - Updates are patch or low-risk minor updates
     - Updates are in the same ecosystem or lockfile
     - No dependency updates conflict with each other
     - Existing tests/build commands are available
     - The combined change remains reviewable
   - Recommend separate branches/PRs when:
     - Any update is major
     - Any update affects framework/runtime/build tooling
     - Multiple ecosystems are involved with unrelated risk profiles
     - The lockfile resolution is likely complex
     - One alert requires code changes or migration work
     - Combining updates would make rollback difficult

8. **Plan implementation steps**
   - Propose the branch name, for example `security/dependabot-alerts`.
   - List exact dependency update commands to run later, grouped by ecosystem.
   - List expected files that would change.
   - List tests/checks to run after changes:
     - Existing test suite
     - Linter/typechecker
     - Build
     - Security/audit command if available
   - Do not run these commands in Plan mode.

9. **Produce final remediation plan**
   - Include:
     - Alerts found
     - Recommended safe updates
     - Whether they can be handled in one branch/PR
     - Alerts requiring manual review
     - Breaking-change risks discovered
     - Exact future implementation commands
     - Verification plan
     - Open questions or blockers

### Safety Rules

- Do not edit files or create branches in this command.
- Do not run package manager update/install commands in this command.
- Do not merge PRs in this command.
- Do not assume a patch is safe if it affects native dependencies, runtimes, build tools, framework internals, or configuration-sensitive packages.
- Major updates require manual review by default.
- If changelogs or release notes cannot be reviewed, flag the update instead of calling it safe.
- If GitHub API access is unavailable, stop after explaining the access issue and provide manual next steps.
- Prefer one branch/PR only when the combined dependency update is low risk and easily reversible.

### Output Format

````md
## Dependabot Alert Plan

Repository: `<owner>/<repo>`
Alerts URL: `https://github.com/<owner>/<repo>/security/dependabot`

## Alerts Found

| Severity | Package | Ecosystem | Manifest | Patched Version | Existing PR | Recommendation |
| --- | --- | --- | --- | --- | --- | --- |

## Recommended Strategy

[State whether to use one branch/PR or split the work, with concise reasoning.]

## Safe To Address Together

- `[package]`: `[current/vulnerable]` -> `[patched]` because `[reason]`

## Needs Manual Review

- `[package]`: `[reason]`

## Proposed Implementation

Branch: `security/dependabot-alerts`

Commands to run later:

```bash
[commands]
```

Expected files to change:

- `[file]`

## Verification Plan

```bash
[test/lint/build commands]
```

## Open Questions

- `[question or none]`
````
