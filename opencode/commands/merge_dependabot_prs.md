---
description: Merge open Dependabot PRs filtered by version update type (patch or minor)
agent: pr-merger
---

# Merge Dependabot PRs

Automatically merge Dependabot pull requests based on version update type.

## Usage

```
/merge_dependabot_prs [TYPE]
```

Where `TYPE` can be:
- `patch` (default): Only merge patch version updates (x.y.z → x.y.z+1)
- `minor`: Merge both minor (x.y.z → x.y+1.z) and patch version updates

## Arguments

- `$ARGUMENTS` - Update type filter. Defaults to "patch" if not provided.

## Command Implementation

You are tasked with merging Dependabot pull requests based on the specified update type filter.

### Steps to Execute:

1. **Detect project ecosystem**
   - Inspect the repository root to determine the package ecosystem(s) in use:
     - `Gemfile` / `Gemfile.lock` → Ruby on Rails (Bundler)
     - `package.json` / `yarn.lock` / `package-lock.json` → React / React Native (Expo) (npm/yarn)
   - A repo may contain both (e.g., a Rails API with a JS frontend). Handle each ecosystem's PRs accordingly
   - This determines how to interpret PR titles and where to search for dependency usage

2. **List all open Dependabot PRs**
   - Use `gh pr list --state open --author app/dependabot` to get all open Dependabot PRs

3. **Analyze version changes for each PR**
   - Extract version changes from PR titles (common formats: "Bump [package] from [old] to [new]", "Update [package] requirement from [old] to [new]")
   - Categorize updates as:
     - **Patch**: x.y.z → x.y.z+1 (only z component changes)
     - **Minor**: x.y.z → x.y+1.z (y component changes, z may change)
     - **Major**: x.y.z → x+1.y.z (x component changes)

4. **Filter PRs based on the argument**
   - If argument is "patch" (or no argument): Only include patch updates
   - If argument is "minor": Include both minor and patch updates
   - Never include major updates (these require manual review)

5. **For minor updates: Perform breaking change review** *(skip this step for patch updates)*

   Before merging each minor version PR, perform the following safety analysis:

   #### 5a. Review the PR diff
   - Use `gh pr diff [PR_NUMBER]` to inspect the actual code changes
   - Focus on changes to the lockfile and any modified source files

   #### 5b. Check the package's CHANGELOG for breaking changes
   - Use `gh pr view [PR_NUMBER] --json body` to read the PR body — Dependabot often includes a changelog excerpt and release notes
   - Look for any mentions of: breaking changes, deprecations, removed methods/functions/components, renamed APIs, changed defaults, changed behaviour, or removed features

   #### 5c. Search the codebase for usage of the package
   - Determine where dependencies are typically used based on the detected ecosystem:
     - **Ruby**: `app/`, `lib/`, `config/`, `spec/`, `test/` — look for `require`, `include`, class/module usage, initializer config
     - **JavaScript/TypeScript**: `src/`, `lib/`, `pages/`, `components/`, `app/`, `test/`, `__tests__/` — look for `import`/`require` statements, component usage, config files
     - **Python**: `src/`, `lib/`, `app/`, `tests/` — look for `import`/`from ... import` statements, config usage
     - **Go**: `*.go` files — look for `import` statements referencing the module
     - **Rust**: `src/` — look for `use` statements referencing the crate
     - **PHP**: `src/`, `app/`, `tests/` — look for `use` statements, `composer` autoloading
     - For any ecosystem, also check configuration files (e.g., `config/`, dotfiles, `.*rc` files) for package-specific settings
   - Cross-reference any CHANGELOG deprecations or removals against actual usage in the codebase

   #### 5d. Make a merge/skip decision
   - **Safe to merge**: The CHANGELOG contains only additive changes (new features, bug fixes, performance improvements) and no removed/changed APIs that the codebase depends on
   - **Skip and flag for manual review** if ANY of the following are true:
     - The CHANGELOG mentions breaking changes, removed APIs, or changed behaviour
     - The project has configuration that references deprecated options from the package
     - The codebase uses APIs/functions/components that are documented as deprecated or removed in the new version
     - The CHANGELOG could not be found or reviewed (err on the side of caution)

6. **Merge eligible PRs**
   - Merge all patch PRs directly: `gh pr merge [PR_NUMBER] --squash --delete-branch`
   - Merge minor PRs only if they passed the breaking change review in step 5
   - Handle any merge conflicts or failures gracefully
   - Report which PRs were successfully merged and which failed

7. **Provide summary**
   - List successfully merged PRs
   - List any PRs that failed to merge (with reasons if available)
   - List any PRs that were skipped due to version type filtering
   - List any minor PRs that were skipped due to potential breaking changes (with details of what was flagged)

### Safety Considerations:

- Patch updates are assumed safe and merged directly
- Minor updates require a breaking change review before merging (see step 5)
- Major version updates always require manual review
- Security patches should be prioritised
- If a PR fails to merge due to conflicts, report it but continue with others
- When in doubt about a minor update, skip it and flag for manual review

### Example Output:

```
Detected ecosystem: Ruby (Bundler)

Successfully merged 8 Dependabot PRs:
- phonelib 0.10.10 → 0.10.11 (patch)
- redis 5.4.0 → 5.4.1 (patch)
- pagy 9.3.0 → 9.4.0 (minor — reviewed, no breaking changes)
- [etc...]

Failed to merge:
- flipper-ui 1.3.4 → 1.3.5 (not mergeable — conflicts)

Skipped (minor — potential breaking changes):
- sidekiq 7.2.0 → 7.3.0 (CHANGELOG mentions removed `Sidekiq::Worker` alias; codebase uses it in app/workers/)

Skipped (requires manual review):
- stripe 13.5.0 → 15.3.0 (major update)
- thor 1.3.2 → 1.4.0 (minor update, only merging patch)
```
