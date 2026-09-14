---
name: smoke-test
description: Smoke-test the UI a branch changed by booting the real app and loading each changed route or screen. Use after implementation when the diff touches UI files, or when asked to smoke test a branch.
---

# Smoke Test

Drive the real app and confirm the UI this branch changed still renders. This skill runs unattended: it discovers how to start the app from what the repo already states, starts it, loads each changed route or screen, and stops what it started. Failures come back as findings for the caller to sort.

The optional argument is a list of routes or screens. It replaces the list step 2 derives from the diff and bypasses the UI gate in step 1; the driver choice and the caps still apply.

Web launch and stop mechanics are shared with other skills in [`../_shared/app-launch.md`](../_shared/app-launch.md). Driver-specific mechanics live in [`WEB.md`](WEB.md) (Playwright MCP) and [`IOS.md`](IOS.md) (ios-simulator MCP). Step 1 picks one driver; read only that file.

## Workflow

1. Scope the branch and pick the driver.
   - Base is `main` unless one is supplied; record it. Changed paths are `git diff --name-only $(git merge-base <base> HEAD)` plus `git ls-files --others --exclude-standard`, so uncommitted work counts.
   - Mark each changed path UI or not. UI: components, screens, pages, routes, layouts, templates, styles, storyboards, xibs, SwiftUI views. Not UI: tests, docs, config, pure logic.
   - No UI paths and no argument list: report `Skipped: no UI changes` and stop.
   - Web signal: per `app-launch.md` `Web signal`.
   - Xcode signal: an `*.xcworkspace` or `*.xcodeproj`. A `Package.swift` on its own is a library and is not a signal.
   - Web signals only: `playwright`. Xcode signals only: `ios-simulator`. Neither: report `Skipped: no driver` and stop.
   - The chosen driver's MCP tools must be listed in this session: `app-launch.md` `Availability` for playwright, `get_booted_sim_id` for ios-simulator. Missing: report `Skipped: no driver (server unavailable)` and stop.
   - Both present (React Native, Expo, Capacitor): `ios-simulator` when every changed UI path is Swift, storyboard, or xib; otherwise `playwright` when the repo states a web launch recipe, else `ios-simulator`.
   - One driver per run. UI paths on the other surface go under `Not covered: other surface`.
   - Completion criterion: every changed path is marked UI or not, and one driver or the skip is recorded with its reason.

2. Derive routes or screens and the observable.
   - Map each changed UI file to the route or screen that renders it, following the derivation rules in the driver file. An argument list replaces this mapping.
   - The observable, in order of preference: new or changed literal text; the rendered text, test id, or accessibility identifier of a new component; a new control. For a style-only change, the check is that the route renders and the screenshot lands.
   - Route parameters take values the repo states (fixtures, seeds, README, stories). Otherwise use the route without parameters, or record `Not covered: needs data`.
   - Apply Caps. Rank rows by changed lines and move the overflow to `Not covered: over route cap`.
   - Completion criterion: a table of route, reach steps, and expected observable, within caps, where every changed UI file maps to a row or a `Not covered` reason.

3. Discover the launch recipe.
   - Web: per `app-launch.md` `Recipe`. iOS: the same document order, with `xcodebuild -list` schemes as the manifest step; iOS always builds HEAD, so a found-running app does not apply.
   - Nothing found: report `Skipped: no launch recipe` and stop. Never ask mid-run.
   - Completion criterion: the recipe is recorded as start command, readiness probe, stop command, and a found-running flag, or the skip is recorded.

4. Start the app and wait for readiness.
   - Web: per `app-launch.md` `Launch`. iOS: per `IOS.md` `Launch`, within the readiness and build caps.
   - Load the root once and record error-level console output as the startup set.
   - Readiness missed: record a finding with location `launch` and the last 30 log lines, then go to step 6.
   - Completion criterion: readiness passed and the app address plus the startup set are recorded, or the launch finding is recorded.

5. Drive each row.
   - Per the driver file's `Drive` section: reach the route, confirm the observable, collect the error-level console output that appeared during this row, and take one screenshot.
   - Console rule: an error-level message or uncaught exception during the row's own window fails the row. Warnings and third-party network noise do not. An error from the startup set is reported once as a finding with location `launch`; the caller decides whether it predates the branch, since this run never builds the base.
   - Crash rule: the app is still in the foreground after the row's steps.
   - Screenshot name: `smoke-<branch-slug>-<route-slug>[-<state>].png`, written to the driver's screenshot dir.
   - A row that exceeds the interaction cap stops and lands in `Not covered: over step cap`.
   - Completion criterion: every row has a verdict (passed, failed with a finding, or not covered with a reason), a screenshot path where one was taken, and a console and crash result.

6. Stop what this run started.
   - Web: per `app-launch.md` `Stop`. iOS: per `IOS.md` `Stop`. A found-running app stays up.
   - Screenshots stay where they were written for `/pr_screenshots`.
   - Completion criterion: every process this run started is gone, and everything found running is still running.

7. Report using the Status labels.

## Caps

- Routes or screens per run: 5.
- Interaction steps per route beyond navigation, including a documented login: 3.
- Readiness: web per `app-launch.md`, 60 s iOS after install. Build: 10 min.

## Findings

One finding per failed route, in the shape `wrap_up` sorts: a location in the diff (the changed file and hunk the route traces to, or `launch`) and a claim (the expected observable or clean console, and what was seen instead: a missing element, the console error text, or a crash), plus the screenshot path.

## Status

- `Launch`: driver, recipe used, and whether the app was found running or started and stopped.
- `Passed`: routes with the observable present and a clean console, each with its screenshot path.
- `Failed`: findings.
- `Not covered`: files or routes left out, each with its reason: over route cap, over step cap, needs data, other surface.
- `Skipped`: the gate that stopped the run: `no UI changes`, `no driver`, `no driver (server unavailable)`, `no launch recipe`.
