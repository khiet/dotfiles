---
name: smoke-test
description: Smoke-test the UI a branch changed by booting the real app and loading each changed route or screen. Use after implementation when the diff touches UI files, or when asked to smoke test a branch.
---

# Smoke Test

Drive the real app and confirm the UI this branch changed still renders. This skill runs unattended: it discovers how to start the app from what the repo already states, starts it, loads each changed route or screen, and stops what it started. Failures come back as findings for the caller to sort.

The optional argument is a list of routes or screens. It replaces the list step 2 derives from the diff; the caps still apply.

Driver mechanics live in [`WEB.md`](WEB.md) (Playwright MCP) and [`IOS.md`](IOS.md) (ios-simulator MCP). Step 1 picks one; read only that file.

## Workflow

1. Scope the branch and pick the driver.
   - `git diff main...HEAD --name-only`, or against the supplied base ref when one is given.
   - Mark each changed path UI or not. UI: components, screens, pages, routes, layouts, templates, styles, storyboards, xibs, SwiftUI views. Not UI: tests, docs, config, pure logic.
   - No UI paths: report `Skipped: no UI changes` and stop.
   - Web signal: a `package.json` with a `dev`, `start`, `serve`, or `preview` script, a framework config file (`next.config.*`, `vite.config.*`, `nuxt.config.*`, `svelte.config.*`, `astro.config.*`, `angular.json`, `remix.config.*`), an `index.html` at the root or under `public/`, `src/`, or `app/`, or a `docker compose` service that publishes a port.
   - Xcode signal: an `*.xcworkspace` or `*.xcodeproj`. A `Package.swift` on its own is a library and is not a signal.
   - Web signals only: `playwright`. Xcode signals only: `ios-simulator`. Neither: report `Skipped: no driver` and stop.
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
   - Check in order and stop at the first hit: (a) an app already answering at the documented URL (web only; iOS always builds HEAD); (b) a dev command or URL in `CLAUDE.md`, `AGENTS.md`, or `README`; (c) the project manifest: `package.json` scripts `dev`, `start`, `serve`, `preview`, or `xcodebuild -list` schemes; (d) `docker compose` with a published port; (e) a `Makefile`, `Procfile`, or `justfile` target named `dev`, `start`, or `run`.
   - Credentials come only from those same documents. A documented login counts against the interaction cap.
   - Nothing found: report `Skipped: no launch recipe` and stop. Never ask mid-run.
   - Completion criterion: the recipe is recorded as start command, readiness probe, stop command, and a found-running flag, or the skip is recorded.

4. Start the app and wait for readiness.
   - When `.gitignore` does not cover them, add `.playwright-mcp/` and `.ios-simulator-mcp/` to `.git/info/exclude`. That file is per clone and never committed, so the tree stays clean for the caller's commits without adding a project file.
   - Start and probe readiness per the driver file's `Launch` section, within the readiness and build caps. A found-running app is used as is.
   - Load the root once and record error-level console output as the baseline.
   - Readiness missed: record a finding with location `launch` and the last 30 log lines, then go to step 6.
   - Completion criterion: readiness passed and the app address plus the baseline are recorded, or the launch finding is recorded.

5. Drive each row.
   - Per the driver file's `Drive` section: reach the route, confirm the observable, collect error-level console output diffed against the baseline, and take one screenshot.
   - Console rule: an error-level message or uncaught exception during load fails the row. Warnings and third-party network noise do not. A baseline error is reported once as `Not covered: pre-existing console error`.
   - Crash rule: the app is still in the foreground after the row's steps.
   - Screenshot name: `smoke-<branch-slug>-<route-slug>[-<state>].png`, written to the driver's screenshot dir.
   - A row that exceeds the interaction cap stops and lands in `Not covered: over step cap`.
   - Completion criterion: every row has a verdict (passed, failed with a finding, or not covered with a reason), a screenshot path where one was taken, and a console and crash result.

6. Stop what this run started.
   - Per the driver file's `Stop` section. A found-running app stays up.
   - Screenshots stay where they were written for `/pr_screenshots`.
   - Completion criterion: every process this run started is gone, and everything found running is still running.

7. Report using the Status labels.

## Caps

- Routes or screens per run: 5.
- Interaction steps per route beyond navigation, including a documented login: 3.
- Readiness: 120 s web, 60 s iOS after install. Build: 10 min.

## Findings

One finding per failed route, in the shape `wrap_up` sorts: a location in the diff (the changed file and hunk the route traces to, or `launch`) and a claim (the expected observable or clean console, and what was seen instead: a missing element, the console error text, or a crash), plus the screenshot path.

## Status

- `Launch`: driver, recipe used, and whether the app was found running or started and stopped.
- `Passed`: routes with the observable present and a clean console, each with its screenshot path.
- `Failed`: findings.
- `Not covered`: files or routes left out, each with its reason: over route cap, over step cap, needs data, other surface, pre-existing console error.
- `Skipped`: the gate that stopped the run: `no UI changes`, `no driver`, `no launch recipe`.

Close every run with `Residual risks`: what this run could still be wrong about, such as an observable inferred from a component name, a route guessed from router config, a running server that may serve another worktree, or console noise judged pre-existing.

## Boundaries

- Deep journeys, seeded data, and acceptance criteria belong to `story-acceptance`, which grills the user first.
- Getting screenshots into the PR belongs to `/pr_screenshots`; this skill leaves them in the dirs that command scans.
- The caller owns every fix and commit.
