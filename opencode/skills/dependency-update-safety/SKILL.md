---
name: dependency-update-safety
description: Shared methodology for safely reviewing dependency-update PRs (Dependabot/Renovate) and planning security-alert remediation - ecosystem detection, version categorization, codebase-usage analysis, and breaking-change risk signals.
metadata:
  audience: software-engineers
  focus: dependency-hygiene-and-safety
---

## Scope

Reviewing dependency-update PRs (Dependabot, Renovate) and planning security-alert
remediation. This skill holds the building blocks shared by the `/merge_dependabot_prs`,
`/merge_renovate_prs`, and `/plan_dependabot_alerts` commands. Each command layers its own
specifics on top: Dependabot = changelog breaking-change review; Renovate = OTA/native-risk
skips; plan = read-only remediation planning.

## Ecosystem Detection

Inspect the repository root to determine the package ecosystem(s) in use. A repo may contain
more than one (e.g. a Rails API with a JS frontend); handle each ecosystem's PRs accordingly.

| Manifest / lockfile | Ecosystem |
|---|---|
| `Gemfile` / `Gemfile.lock` | Ruby (Bundler) |
| `package.json` + `yarn.lock` / `package-lock.json` / `pnpm-lock.yaml` | Node (npm/yarn/pnpm) |
| `requirements.txt` / `poetry.lock` / `Pipfile.lock` | Python |
| `go.mod` / `go.sum` | Go |
| `Cargo.toml` / `Cargo.lock` | Rust |
| `composer.json` / `composer.lock` | PHP |

## Version Categorization

Extract the version change from each PR title (common formats: "Bump [package] from [old] to
[new]", "Update [package] requirement from [old] to [new]", "Update dependency [package] to
v[new]"). Categorize each update:

- **Patch**: x.y.z -> x.y.z+1 (only z changes) - usually safest.
- **Minor**: x.y.z -> x.y+1.z (y changes, z may change) - requires release-note/usage review.
- **Major**: x.y.z -> x+1.y.z (x changes) - manual review by default.

## Codebase-Usage Analysis

To judge whether an update is safe, find where the dependency is used, then cross-reference
against changelog deprecations/removals. Search locations by ecosystem:

- **Ruby**: `app/`, `lib/`, `config/`, `spec/`, `test/` - `require`, `include`, class/module usage, initializer config.
- **JavaScript/TypeScript**: `src/`, `app/`, `lib/`, `components/`, `pages/`, `test/`, `__tests__/` - `import`/`require`, component usage, config files.
- **Python**: `src/`, `app/`, `lib/`, `tests/` - `import` / `from ... import`, config usage.
- **Go**: `*.go` files - `import` statements referencing the module.
- **Rust**: `src/` - `use` statements referencing the crate.
- **PHP**: `src/`, `app/`, `tests/` - `use` statements, composer autoloading.

Also check package-specific configuration files and initializers in every ecosystem.

## Breaking-Change Risk Signals

Review the PR body/diff, advisory, changelog, release notes, and migration guides. Treat the
update as risky (skip / flag for manual review) when any of these appear and the codebase
depends on the affected behavior:

- Breaking changes, removed or renamed APIs
- Deprecated APIs that the repo uses
- Changed defaults or runtime behavior
- Required migrations
- Build/toolchain changes
- Native module changes (can require a native rebuild even for a patch)

If the changelog/release notes cannot be found or reviewed, err on the side of caution and
flag the update rather than calling it safe.

## General Decision Rule

- **Safe to merge**: the change is within the requested version filter and the changelog is
  additive (new features, fixes) with no removed/changed APIs the codebase relies on.
- **Skip and flag**: any risk signal above is present, or confidence cannot be established.
- Major updates always require manual review.
