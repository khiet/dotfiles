# App launch (iOS)

Shared mechanics for skills that run the project's Expo or React Native app on the iOS simulator and drive it with the `ios-simulator` MCP. The calling skill decides when each section runs and what a miss means; this file only says how. Every fact here comes from the repo, its documents, the simulator, or the running process, never from the user.

The run reuses what is already on the machine: a booted simulator and an installed app. It never builds the native app, since a build takes minutes and changes the simulator's state.

## Mobile signal

`expo` or `react-native` in `package.json` dependencies, or an `ios/` dir at the root. Record the file that gave the signal. Checked before the web signal: the Expo template ships `react-native-web` and a `web` script, which would otherwise read as a web app.

## Availability

The `ios-simulator` MCP tools must be listed in this session; `get_booted_sim_id` is the probe. A missing tool means the driver is unavailable. No booted simulator is its own miss: `no booted simulator`. With several booted, use the one `get_booted_sim_id` returns and pass its udid on every call.

## App

- Bundle id: `ios.bundleIdentifier` in `app.json` or `app.config.*`, else `PRODUCT_BUNDLE_IDENTIFIER` in `ios/*.xcodeproj/project.pbxproj`.
- Expo Go project (no `ios/` dir and no `expo-dev-client` dependency): the bundle id is `host.exp.Exponent`.
- `list_apps` on the booted simulator must include the bundle id; a miss is `app not installed on simulator`.

## Recipe

Metro serves the JS bundle. Check in order and stop at the first hit:

1. Metro already answering: `curl -s localhost:8081/status` returns `packager-status:running`. That counts as found running.
2. A Metro or start command in `CLAUDE.md`, `AGENTS.md`, or `README`.
3. The project's `start` script in `package.json`.
4. `npx expo start` for an Expo project, `npx react-native start` otherwise.

Credentials come only from those same documents: literal values, or env variable names the documents give with the file that holds them (for example `$SMOKE_EMAIL` in `.env.local`). Read only the file a document names.

Record the recipe as start command, readiness probe, stop command, and a found-running flag.

## Launch

1. When `.gitignore` does not cover it, add `.ios-simulator-mcp/` to `.git/info/exclude`. That file is per clone and never committed.
2. A found-running Metro is used as is. Its log is out of reach, so the Metro error signal is unavailable for the run; record that for the caller's report.
3. Otherwise run the recipe's start command in the background with job control on (`set -m`), stdout and stderr to a log file in the scratch dir, and record its pid so the process group can be stopped later.
4. Record whether the app was already running (`xcrun simctl spawn <udid> launchctl list | grep <bundle-id>`), then `launch_app` with `terminate_running` true.
5. Connect to Metro when the app opens on the Expo dev launcher or Expo Go home: tap the entry for the Metro URL. This is connection, not navigation, so it does not count against the interaction cap.
6. Readiness: Metro reports `packager-status:running` and `ui_describe_all` shows the app's own first screen rather than a launcher or a loading bundle. Poll every 2 s, within 180 s, since a cold first bundle is slow.

## Relaunch

Before each row: `launch_app` with `terminate_running` true, then wait for readiness as in Launch step 6. Every row starts cold from the app's first screen, the way a tester opens the app.

## Tap

Find the element with `ui_find_element`: search by its accessibility label, or its visible text, with `matchMode` `exact` first and then `substring`. Tap the center of its frame with `ui_tap`. Text entry: tap the field, then `ui_type`. A documented login is the login screen's fields and submit, done this way; the calling skill counts it against its interaction cap.

## Error signals

- Metro: error-level lines in the log written during the row's window. Lines from before the first row are the startup set.
- Screen: `ui_describe_all` showing a red screen or an error LogBox ("Render Error", "Uncaught Error", "Syntax Error", an "Error" banner from LogBox). A yellow warning LogBox is not an error.

## Stop

The calling skill runs this on every exit after Launch has run, including a skip.

- `kill -- -<pid>` on the recorded Metro process group; done when `pgrep -g <pid>` returns nothing and `lsof -i :8081` shows the port free.
- `terminate_app` when this run launched the app and it was not running before.
- The simulator stays booted. A found-running Metro, and an app that was running before the run, are left untouched.
