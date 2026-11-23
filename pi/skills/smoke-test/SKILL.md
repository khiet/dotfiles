---
name: smoke-test
description: Smoke-test the UI a branch changed by booting the real app (web, or iOS simulator for Expo and React Native) and reaching the screens it touched. Use after implementation when the diff touches UI files, or when asked to smoke test a branch.
---

# Smoke Test

Drive the real app and confirm the UI this branch changed still renders. A repo is one platform: web, driven with the Playwright MCP, or iOS, driven on the simulator with the `ios-simulator` MCP. The run is unattended; failures come back as findings for the caller to sort.

Launch and stop mechanics are per platform: [`../_shared/app-launch.md`](../_shared/app-launch.md) for web and [`../_shared/app-launch-ios.md`](../_shared/app-launch-ios.md) for iOS; "the launch file" below means the platform's one. File-to-route mapping is shared in [`../_shared/route-derivation.md`](../_shared/route-derivation.md). This file holds what is specific to smoke-testing a diff.

## Workflow

1. Scope the branch and gate.
   - Base is `main` unless one is supplied; record it. Changed paths are `git diff --name-only $(git merge-base <base> HEAD)` plus `git ls-files --others --exclude-standard`, so uncommitted work counts.
   - Mark each changed path UI or not. UI: components, pages, screens, routes, layouts, templates, styles. Not UI: tests, docs, config, pure logic.
   - No UI paths: report `Skipped: no UI changes` and stop.
   - Platform: `app-launch-ios.md` `Mobile signal` first, then `app-launch.md` `Web signal`. Neither: report `Skipped: no app signal` and stop.
   - Driver: the launch file's `Availability`. Missing: report `Skipped: no driver (server unavailable)` and stop. iOS with no booted simulator: report `Skipped: no booted simulator` and stop.
   - iOS app: `app-launch-ios.md` `App`. Not installed: report `Skipped: app not installed on simulator` and stop.
   - Recipe: the launch file's `Recipe`. None: report `Skipped: no launch recipe` and stop.
   - Completion criterion: the platform is recorded, every changed path is marked UI or not, and the recipe is recorded as start command, readiness probe, stop command, and a found-running flag, or the run has stopped with its `Skipped` label.

2. Derive routes and the observable.
   - Map each changed UI file to its route per `route-derivation.md`. A route miss is `Not covered: no route` with the chain; a parameter miss is `Not covered: needs data`.
   - The observable, in order of preference: new or changed literal text; the rendered text or test id of a new component; a new control. For a style-only change, the check is that the route renders and the screenshot lands.
   - Reach steps are the interactions between the route and the observable. Web: open a modal, expand a row, the documented login. iOS: the tap path from `route-derivation.md` `Tap path (iOS)`, then any taps on the screen itself, plus the documented login when the app lands on a login screen. Within the interaction cap. A row that needs more is `Not covered: over step cap`. A row behind a login with no documented credentials is `Not covered: needs login`.
   - Apply Caps. Rank rows by changed lines and move the overflow to `Not covered: over route cap`.
   - Completion criterion: a table of route, reach steps, and expected observable, within caps, where every changed UI file maps to a row or a `Not covered` reason.

3. Start the app and wait for readiness per the launch file's `Launch`.
   - Web: load the root once and record error-level console output as the startup set. iOS: the startup set is the Metro errors logged before the first row.
   - Readiness missed: record a finding with location `launch` and the last 30 log lines, then go to step 5.
   - Completion criterion: readiness passed and the app address (web) or simulator udid and bundle id (iOS) plus the startup set are recorded, or the launch finding is recorded.

4. Drive each row per the platform's Drive section.
   - Error rule: an error during the row's own window fails the row. Web: an error-level console message or uncaught exception. iOS: the launch file's `Error signals`. Warnings and third-party network noise do not. An error from the startup set is reported once as a finding with location `launch`; the caller decides whether it predates the branch, since this run never builds the base.
   - Screenshot name: `smoke-<branch-slug>-<route-slug>[-<state>].png` under `.playwright-mcp/` (web) or `.ios-simulator-mcp/` (iOS), as an absolute path.
   - Completion criterion: every row has a verdict (passed, failed with a finding, or not covered with a reason), a screenshot path where one was taken, and an error-check result.

5. Stop what this run started per the launch file's `Stop`. Whatever was found running stays up.
   - Screenshots stay where they were written for `/pr_screenshots`.
   - Completion criterion: the recorded process group is gone and its port free, and everything found running is still running.

6. Report using the Status labels.

## Drive (web)

Per row:

1. `browser_navigate` to the route.
2. Perform the row's reach steps in order. A step whose target is missing fails the row with a finding naming the step.
3. Wait by observable kind. Text: `browser_wait_for` with `text`. Control, test id, or style-only: `browser_wait_for` with `time` 2, since the tool has no network-idle mode.
4. Confirm by observable kind. Text or control: `browser_find` with the text or role. Test id: `browser_evaluate` with `() => document.querySelector('[data-testid="<id>"]') !== null`, because the accessibility snapshot carries no test ids. Style-only: `browser_snapshot` returns a tree.
5. `browser_console_messages` with `level` `error`, scoped to this row's navigation (the tool's default window); the startup set was read the same way after the root load.
6. `browser_take_screenshot` with `filename` set to the smoke name.

## Drive (iOS)

Per row:

1. Relaunch per `app-launch-ios.md` `Relaunch`.
2. Perform the row's reach steps in order per `Tap`. A label that is not on screen within the poll fails the row with a finding naming the step, as a tester would report a missing button.
3. Wait: poll `ui_find_element` for the observable every 1 s, within 10 s. Style-only: wait 2 s.
4. Confirm by observable kind. Text, control, or test id: `ui_find_element` with the text, label, or test id (React Native exposes `testID` as the unique id it searches). Style-only: `ui_describe_all` returns the app's screen.
5. Check `Error signals`: the Metro log since the row began, and `ui_describe_all` for a red screen or error LogBox.
6. `screenshot` with `output_path` set to the smoke name's absolute path under the repo's `.ios-simulator-mcp/`; a relative path lands in the MCP's own output dir instead.

## Caps

- Routes per run: 5.
- Interaction steps per route beyond navigation, including a documented login: 3 on web, 6 on iOS, since every screen there is reached by taps.
- Readiness: per the launch file.

## Findings

One finding per failed route, in the shape `wrap_up` sorts: a location in the diff (the changed file and hunk the route traces to, or `launch`) and a claim (the expected observable or clean error check, and what was seen instead: a missing element, a failed reach step, or the error text), plus the screenshot path.

## Status

- `Launch`: platform, recipe used, and whether the app was found running or started and stopped. iOS with a found-running Metro: note that the Metro error signal was unobserved.
- `Passed`: routes with the observable present and a clean error check, each with its absolute screenshot path. With the Metro signal unobserved, clean means the screen signal only, and the line says so.
- `Failed`: findings.
- `Not covered`: files or routes left out, each with its reason: over route cap, over step cap, needs data, needs login, no route.
- `Skipped`: the gate that stopped the run: `no UI changes`, `no app signal`, `no driver (server unavailable)`, `no booted simulator`, `app not installed on simulator`, `no launch recipe`.
