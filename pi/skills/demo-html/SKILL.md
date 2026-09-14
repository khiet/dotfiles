---
name: demo-html
description: Build a shareable single-file HTML demo of a feature, matched to the live product, and publish it as an Artifact (or a Desktop file without the tool) for the team to agree on the UI/UX.
disable-model-invocation: true
---

# Demo HTML

One self-contained, interactive HTML page that shows a feature inside the product's own look, so the team can play with it and agree on the UI/UX without a dev environment. Fidelity is the whole point: a reviewer never has to ask "is this here because it's a demo?"

The argument is the feature: free text, an issue reference, or the URL of a demo this skill published earlier, meaning revise that one; extra words after a URL are the revision instructions. Empty: print `Usage: <feature description | issue-ref | artifact-url> [instructions]` and stop.

The run is unattended. A gate that fails ends the run with its `Skipped` label: before Launch has run, straight to Report; from Launch on, through Stop and then Report. Nothing is published on a skipped run. The rules for the page are in [`DEMO.md`](DEMO.md), read from step 5. Launch mechanics are the shared [`../_shared/app-launch.md`](../_shared/app-launch.md) and file-to-route mapping the shared [`../_shared/route-derivation.md`](../_shared/route-derivation.md).

## Workflow

1. Resolve the feature.
   - A bare number, `#N`, or a github.com issue URL is a GitHub issue in the current repository: `gh issue view`. A Linear key such as `ABC-123` or a linear.app URL is a Linear issue: the Linear tools. Title and body are the description.
   - An artifact URL is a revision: read the page with the Artifact tool and take its `demo-brief` block as the starting description, with the instructions appended. The baseline is captured again, since the product may have moved.
   - Completion criterion: the description is recorded with every entity, screen, label, state, action, and user role it names, and the mode is new or revision.

2. Gate.
   - Web app: `app-launch.md` `Web signal`. None: `Skipped: not a web app`.
   - Driver: `app-launch.md` `Availability`. Missing: `Skipped: no driver (server unavailable)`.
   - Recipe: `app-launch.md` `Recipe`. None: `Skipped: no launch recipe`.
   - Delivery: the Artifact tool when it is listed, else a Desktop file; record which. Not a gate.
   - Completion criterion: each gate is recorded as passed, or the run has stopped with its label.

3. Derive the baseline routes.
   - Grep the entities and labels from step 1 across route files and components; map hits to routes per `route-derivation.md` and rank by hit count. A parameter miss is `Not covered: needs data`.
   - The shell: the root route's nav and header, plus the list and detail pages the derived routes sit under. Nothing derived: the first two nav links.
   - Derived routes fill what the route cap leaves after the shell; the rest are `Not covered: over route cap`.
   - A screen the description says the feature adds has no baseline: list it under `Not covered: new screen`, outside the table, and build it in step 6 from the shell and the description.
   - Viewport 1440 wide. Add 390 wide only when the description names mobile.
   - Completion criterion: a table of route, reach steps, parameter source, and role (shell or derived) within the cap, plus the `Not covered` rows.

4. Capture the baseline.
   - Launch per `app-launch.md` `Launch`. Readiness missed: `Skipped: launch failed`.
   - A login the app demands without documented credentials: `Skipped: no credentials`.
   - Per row: `browser_navigate`, the row's reach steps, `browser_wait_for` with `time` 2, `browser_snapshot` kept as the row's live snapshot, `browser_take_screenshot` to `.playwright-mcp/demo-<slug>-<route-slug>.png`.
   - Once, on the shell: `browser_evaluate` reading `getComputedStyle` for body, nav, a heading, a table header, a primary button, and a link: font family, sizes, weights, colors, background, border radius. This is the style probe.
   - A row that fails to render or exceeds the cap: `Skipped: baseline incomplete (<route>)`.
   - Completion criterion: every row has a screenshot and a live snapshot, the style probe is recorded, and the product vocabulary (nav labels, headings, column headings, button labels, empty-state text) is listed from the snapshots.

5. Gather tokens and data per `DEMO.md` `Sources`.
   - "Viewing as" needs as many fixture users as the feature has roles, at least two when the feature involves more than one user. Fewer: `Skipped: not enough fixture users`.
   - Completion criterion: a token table with the source of each value, a provenance table with one row per mock entity, the term mappings from the description's words to the product's, and the user list.

6. Build the page per `DEMO.md`. Write it to the scratch dir as `demo-<slug>.html`.
   - Completion criterion: a complete HTML document with the `demo-brief` block present and current, every action the description names working end to end, and `Reset` restoring the initial state.

7. Check the page against the baseline.
   - `browser_navigate` to `file://<path>` at the baseline viewport. For each baseline row, put the demo in the matching state and `browser_take_screenshot` to `.playwright-mcp/demo-<slug>-<route-slug>-demo.png`.
   - Side by side per row: same nav and header, same headings and column headings, same density, same fonts and colors. A difference is fixed in the page, or recorded as a fidelity gap when the source of truth is missing (font not loadable, token not found).
   - Label audit per `DEMO.md` `Label audit`, in every screen, scenario, and "Viewing as" user. An unbucketed string is a defect: fix and audit again.
   - External resources: the only one is the product's font link, if any.
   - Completion criterion: every row compared with differences fixed or recorded, the audit reports zero unbucketed strings in every state, and the resource check passes.

8. Stop per `app-launch.md` `Stop`.
   - Completion criterion: the recorded process group is gone and its port free, and everything found running is still running.

9. Publish. Only a page that passed step 7 reaches this step.
   - Artifact tool: load `artifact-design` because the tool requires it. Publish a copy with the `<!DOCTYPE>`, `<html>`, `<head>`, and `<body>` tags removed and `<title>` and `<style>` left at the top, since the host wraps the page in its own skeleton. Pass `favicon` `🧪` on a new demo, `url` on a revision, and a one-sentence `description`. `DEMO.md` governs the page; product look wins over `artifact-design` wherever they differ.
   - Desktop: copy the complete file to `$HOME/Desktop/<unix_timestamp>_demo_<slug>.html`.
   - Completion criterion: the URL or path is recorded.

10. Report using the Status labels.

## Caps

- Routes per run, shell included: 5.
- Interaction steps per route beyond navigation, including a documented login: 3.
- Readiness: per `app-launch.md`.

## Status

- `Demo`: artifact URL or Desktop path, and new or revision.
- `Baseline`: recipe used, found running or started and stopped, and the screenshot pairs per route.
- `Provenance`: the table from step 5, one row per entity: entity, source file or live snapshot.
- `New`: every string in the new bucket, since these are the proposals the team is agreeing on.
- `Terms`: each description word replaced by a product term.
- `Not covered`: needs data, over route cap, new screen.
- `Fidelity gaps`: fonts, tokens, or side-by-side differences left in place, each with its reason.
- `Skipped`: the gate that stopped the run: `not a web app`, `no driver (server unavailable)`, `no launch recipe`, `launch failed`, `no credentials`, `baseline incomplete (<route>)`, `not enough fixture users`.
