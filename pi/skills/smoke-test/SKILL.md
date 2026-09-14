---
name: smoke-test
description: Smoke-test the UI a branch changed by booting the real web app and loading each changed route. Use after implementation when the diff touches UI files, or when asked to smoke test a branch.
---

# Smoke Test

Drive the real web app with the Playwright MCP and confirm the UI this branch changed still renders. This skill runs unattended: it discovers how to start the app from what the repo already states, starts it, loads each changed route, and stops what it started. Failures come back as findings for the caller to sort.

Launch and stop mechanics are shared with other skills in [`../_shared/app-launch.md`](../_shared/app-launch.md); this file holds what is specific to smoke-testing a diff.

## Workflow

1. Scope the branch and gate.
   - Base is `main` unless one is supplied; record it. Changed paths are `git diff --name-only $(git merge-base <base> HEAD)` plus `git ls-files --others --exclude-standard`, so uncommitted work counts.
   - Mark each changed path UI or not. UI: components, pages, routes, layouts, templates, styles. Not UI: tests, docs, config, pure logic.
   - No UI paths: report `Skipped: no UI changes` and stop.
   - Web app: `app-launch.md` `Web signal`. None: report `Skipped: not a web app` and stop.
   - Driver: `app-launch.md` `Availability`. Missing: report `Skipped: no driver (server unavailable)` and stop.
   - Completion criterion: every changed path is marked UI or not, and each gate is recorded as passed or the run has stopped with its label.

2. Derive routes and the observable.
   - Map each changed UI file to the route that renders it, per Route derivation.
   - The observable, in order of preference: new or changed literal text; the rendered text or test id of a new component; a new control. For a style-only change, the check is that the route renders and the screenshot lands.
   - Route parameters take values the repo states (fixtures, seeds, README, stories). Otherwise use the route without parameters, or record `Not covered: needs data`.
   - Apply Caps. Rank rows by changed lines and move the overflow to `Not covered: over route cap`.
   - Completion criterion: a table of route, reach steps, and expected observable, within caps, where every changed UI file maps to a row or a `Not covered` reason.

3. Discover the launch recipe per `app-launch.md` `Recipe`.
   - Nothing found: report `Skipped: no launch recipe` and stop. Never ask mid-run.
   - Completion criterion: the recipe is recorded as start command, readiness probe, stop command, and a found-running flag, or the skip is recorded.

4. Start the app and wait for readiness per `app-launch.md` `Launch`.
   - Load the root once and record error-level console output as the startup set.
   - Readiness missed: record a finding with location `launch` and the last 30 log lines, then go to step 6.
   - Completion criterion: readiness passed and the app address plus the startup set are recorded, or the launch finding is recorded.

5. Drive each row per Drive.
   - Console rule: an error-level message or uncaught exception during the row's own window fails the row. Warnings and third-party network noise do not. An error from the startup set is reported once as a finding with location `launch`; the caller decides whether it predates the branch, since this run never builds the base.
   - Screenshot name: `smoke-<branch-slug>-<route-slug>[-<state>].png` under `.playwright-mcp/`.
   - A row that exceeds the interaction cap stops and lands in `Not covered: over step cap`.
   - Completion criterion: every row has a verdict (passed, failed with a finding, or not covered with a reason), a screenshot path where one was taken, and a console result.

6. Stop what this run started per `app-launch.md` `Stop`. A found-running app stays up.
   - Screenshots stay where they were written for `/pr_screenshots`.
   - Completion criterion: every process this run started is gone, and everything found running is still running.

7. Report using the Status labels.

## Route derivation

- File-based routers: a file under `pages/`, `app/`, `routes/`, or `src/routes/` maps to its path segment; `index` and `page` files map to the directory; bracketed segments are parameters.
- Config routers: search for `path:` entries or `<Route path=` elements that import the changed component.
- Anything else: grep for importers of the changed file and walk up until a route file is hit. A file with no route within three hops is `Not covered: needs data` with the chain noted.
- A documented login, per `app-launch.md` `Recipe`, spends the interaction budget for every row that needs it.

## Drive

Per row:

1. `browser_navigate` to the route.
2. Wait by observable kind. Text: `browser_wait_for` with `text`. Control, test id, or style-only: `browser_wait_for` with `time` 2, since the tool has no network-idle mode.
3. Confirm by observable kind. Text or control: `browser_find` with the text or role. Test id: `browser_evaluate` with `() => document.querySelector('[data-testid="<id>"]') !== null`, because the accessibility snapshot carries no test ids. Style-only: `browser_snapshot` returns a tree.
4. `browser_console_messages` with `level` `error`. The default window is since the last navigation, so this is the row's own output; the startup set was read the same way after the root load.
5. `browser_take_screenshot` with `filename` set to the smoke name.

## Caps

- Routes per run: 5.
- Interaction steps per route beyond navigation, including a documented login: 3.
- Readiness: per `app-launch.md`.

## Findings

One finding per failed route, in the shape `wrap_up` sorts: a location in the diff (the changed file and hunk the route traces to, or `launch`) and a claim (the expected observable or clean console, and what was seen instead: a missing element or the console error text), plus the screenshot path.

## Status

- `Launch`: recipe used, and whether the app was found running or started and stopped.
- `Passed`: routes with the observable present and a clean console, each with its screenshot path.
- `Failed`: findings.
- `Not covered`: files or routes left out, each with its reason: over route cap, over step cap, needs data.
- `Skipped`: the gate that stopped the run: `no UI changes`, `not a web app`, `no driver (server unavailable)`, `no launch recipe`.
