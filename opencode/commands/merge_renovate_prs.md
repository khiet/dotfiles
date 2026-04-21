---
description: Merge open Renovate PRs filtered by version update type (patch or minor)
model: openai/gpt-5.4
---

# Merge Renovate PRs

Automatically merge Renovate pull requests based on version update type.

## Usage

```
/merge_renovate_prs [TYPE]
```

Where `TYPE` can be:
- `patch` (default): Only merge patch version updates (x.y.z -> x.y.z+1)
- `minor`: Merge both minor (x.y.z -> x.y+1.z) and patch version updates

## Arguments

- `$ARGUMENTS` - Update type filter. Defaults to "patch" if not provided.

## Command Implementation

You are tasked with merging Renovate pull requests based on the specified update type filter.

### Steps to Execute:

1. **Detect project ecosystem**
   - Inspect the repository root to determine the package ecosystem(s) in use:
     - `Gemfile` / `Gemfile.lock` -> Ruby on Rails (Bundler)
     - `package.json` / `yarn.lock` / `package-lock.json` -> React / React Native (Expo) (npm/yarn)
   - A repo may contain both (e.g., a Rails API with a JS frontend). Handle each ecosystem's PRs accordingly
   - This determines how to interpret PR titles and identify likely OTA-safe versus native-affecting dependencies

2. **List all open Renovate PRs**
   - Use `gh pr list --state open --author app/renovate` to get all open Renovate PRs

3. **Analyze version changes for each PR**
   - Extract version changes from PR titles (common formats: "Bump [package] from [old] to [new]", "Update dependency [package] to v[new]")
   - Categorize updates as:
     - **Patch**: x.y.z -> x.y.z+1 (only z component changes)
     - **Minor**: x.y.z -> x.y+1.z (y component changes, z may change)
     - **Major**: x.y.z -> x+1.y.z (x component changes)

4. **Filter PRs based on the argument**
   - If argument is "patch" (or no argument): Only include patch updates
   - If argument is "minor": Include both minor and patch updates
   - Never include major updates (these require manual review)

5. **Check OTA safety for each candidate PR**

   Before merging any eligible patch or minor PR, perform the following OTA safety review:

   #### 5a. Inspect the PR contents
   - Use `gh pr diff [PR_NUMBER]` to inspect the actual code changes
   - Focus on dependency manifest files, lockfiles, build configuration, and any modified native or infrastructure files
   - If the PR changes anything beyond the dependency update in a way that suggests native or build impact, skip it for manual review

   #### 5b. Identify native-risk packages
   - **Always skip** the following packages at **any** version level (patch, minor, or major):
     - `react-native`
     - `react-native-*` (any package starting with `react-native-`)
     - `expo`
     - `@react-native/*`
     - `@sentry/react-native`
     - `mixpanel-react-native`
   - Also skip PRs involving:
     - Native module dependency updates
     - Build tool updates
     - Build or runtime configuration changes
   - Native dependencies can require a native rebuild even for patch releases, so version type does not make these safe

   #### 5c. Make an OTA-safe merge/skip decision
   - **Safe to merge**: The update is within the requested version filter and the PR only changes OTA-safe dependencies without native/build implications
   - **Skip and flag for manual review** if any of the following are true:
     - The package matches a known native-risk package or namespace
     - The diff includes native module changes, build tool changes, or configuration changes
     - OTA safety cannot be determined confidently from the PR title/body/diff
   - When a PR is skipped due to OTA safety, add the `Not OTA-safe` label:
     - `gh pr edit [PR_NUMBER] --add-label "Not OTA-safe"`

6. **Merge eligible PRs**
   - Use `gh pr merge [PR_NUMBER] --squash --delete-branch` for each eligible PR
   - Handle any merge conflicts or failures gracefully
   - Report which PRs were successfully merged and which failed

7. **Provide summary**
   - List successfully merged PRs
   - List any PRs that failed to merge (with reasons if available)
   - List any PRs that were skipped due to version type filtering
   - List any PRs that were skipped due to OTA safety concerns

### Safety Considerations:

- Patch updates are not automatically safe if they touch native dependencies
- Minor updates may be merged only when they are within the requested filter and OTA-safe
- Major version updates always require manual review
- `react-native`, `react-native-*`, `expo`, `@react-native/*`, `@sentry/react-native`, and `mixpanel-react-native` should always be treated as not OTA-safe
- Build tool and configuration changes should always be treated as not OTA-safe
- If a PR fails to merge due to conflicts, report it but continue with others
- When in doubt about OTA safety, skip it, label it `Not OTA-safe`, and flag it for manual review

### Example Output:

```
Detected ecosystem: React Native / Expo (npm/yarn)

Successfully merged 8 Renovate PRs:
- foobar 0.10.10 -> 0.10.11 (patch)
- bazqux 1.4.2 -> 1.5.0 (minor)
- [etc...]

Failed to merge:
- barbaz 2.3.4 -> 2.3.5 (patch - conflicts)

Skipped (requires manual review):
- major-lib 3.9.0 -> 4.0.0 (major update)
- cautious-lib 1.2.3 -> 1.3.0 (minor update, only merging patch)

Skipped (OTA safety):
- react-native 0.72.1 -> 0.72.2 (patch - react-native updates require native build)
- react-native-reanimated 3.17.4 -> 3.19.0 (minor - react-native-* packages require native build)
- @sentry/react-native 5.31.0 -> 5.32.0 (patch - native SDK update)
```
