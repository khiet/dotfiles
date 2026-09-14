---
name: smoke-test
description: Smoke-test the UI a branch changed by booting the real web app and loading the routes it touched. Use after implementation when the diff touches UI files, or when asked to smoke test a branch.
---

# Smoke Test

Drive the real web app with the Playwright MCP and confirm the UI this branch changed still renders. The run is unattended; failures come back as findings for the caller to sort.

Launch and stop mechanics are shared in [`../_shared/app-launch.md`](../_shared/app-launch.md) and file-to-route mapping in [`../_shared/route-derivation.md`](../_shared/route-derivation.md); this file holds what is specific to smoke-testing a diff.

## Workflow

1. Scope the branch and gate.
   - Base is `main` unless one is supplied; record it. Changed paths are `git diff --name-only $(git merge-base <base> HEAD)` plus `git ls-files --others --exclude-standard`, so uncommitted work counts.
   - Mark each changed path UI or not. UI: components, pages, routes, layouts, templates, styles. Not UI: tests, docs, config, pure logic.
   - No UI paths: report `Skipped: no UI changes` and stop.
   - Web app: `app-launch.md` `Web signal`. None: report `Skipped: not a web app` and stop.
   - Driver: `app-launch.md` `Availability`. Missing: report `Skipped: no driver (server unavailable)` and stop.
   - Recipe: `app-launch.md` `Recipe`. None: report `Skipped: no launch recipe` and stop.
   - Completion criterion: every changed path is marked UI or not, and the recipe is recorded as start command, readiness probe, stop command, and a found-running flag, or the run has stopped with its `Skipped` label.

2. Derive routes and the observable.
   - Map each changed UI file to its route per `route-derivation.md`. A route miss is `Not covered: no route` with the chain; a parameter miss is `Not covered: needs data`.
   - The observable, in order of preference: new or changed literal text; the rendered text or test id of a new component; a new control. For a style-only change, the check is that the route renders and the screenshot lands.
   - Reach steps are the interactions between the route and the observable (open a modal, expand a row, the documented login), within the interaction cap. A row that needs more is `Not covered: over step cap`.
   - Apply Caps. Rank rows by changed lines and move the overflow to `Not covered: over route cap`.
   - Completion criterion: a table of route, reach steps, and expected observable, within caps, where every changed UI file maps to a row or a `Not covered` reason.

3. Start the app and wait for readiness per `app-launch.md` `Launch`.
   - Load the root once and record error-level console output as the startup set.
   - Readiness missed: record a finding with location `launch` and the last 30 log lines, then go to step 5.
   - Completion criterion: readiness passed and the app address plus the startup set are recorded, or the launch finding is recorded.

4. Drive each row per Drive.
   - Console rule: an error-level message or uncaught exception during the row's own window fails the row. Warnings and third-party network noise do not. An error from the startup set is reported once as a finding with location `launch`; the caller decides whether it predates the branch, since this run never builds the base.
   - Screenshot name: `smoke-<branch-slug>-<route-slug>[-<state>].png` under `.playwright-mcp/`.
   - Completion criterion: every row has a verdict (passed, failed with a finding, or not covered with a reason), a screenshot path where one was taken, and a console result.

5. Stop what this run started per `app-launch.md` `Stop`. A found-running app stays up.
   - Screenshots stay where they were written for `/pr_screenshots`.
   - Completion criterion: the recorded process group is gone and its port free, and everything found running is still running.

6. Report using the Status labels.

## Drive

Per row:

1. `browser_navigate` to the route.
2. Perform the row's reach steps in order. A step whose target is missing fails the row with a finding naming the step.
3. Wait by observable kind. Text: `browser_wait_for` with `text`. Control, test id, or style-only: `browser_wait_for` with `time` 2, since the tool has no network-idle mode.
4. Confirm by observable kind. Text or control: `browser_find` with the text or role. Test id: `browser_evaluate` with `() => document.querySelector('[data-testid="<id>"]') !== null`, because the accessibility snapshot carries no test ids. Style-only: `browser_snapshot` returns a tree.
5. `browser_console_messages` with `level` `error`, scoped to this row's navigation (the tool's default window); the startup set was read the same way after the root load.
6. `browser_take_screenshot` with `filename` set to the smoke name.

## Caps

- Routes per run: 5.
- Interaction steps per route beyond navigation, including a documented login: 3.
- Readiness: per `app-launch.md`.

## Findings

One finding per failed route, in the shape `wrap_up` sorts: a location in the diff (the changed file and hunk the route traces to, or `launch`) and a claim (the expected observable or clean console, and what was seen instead: a missing element, a failed reach step, or the console error text), plus the screenshot path.

## Status

- `Launch`: recipe used, and whether the app was found running or started and stopped.
- `Passed`: routes with the observable present and a clean console, each with its screenshot path.
- `Failed`: findings.
- `Not covered`: files or routes left out, each with its reason: over route cap, over step cap, needs data, no route.
- `Skipped`: the gate that stopped the run: `no UI changes`, `not a web app`, `no driver (server unavailable)`, `no launch recipe`.
