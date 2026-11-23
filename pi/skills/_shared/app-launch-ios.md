# App launch (iOS)

Shared mechanics for skills that run the project's Expo or React Native app on the iOS simulator and drive it with the `ios-simulator` MCP. The calling skill decides when each section runs and what a miss means; this file only says how. Every fact here comes from the repo, its documents, the simulator, or the running process, never from the user.

The run reuses the app already installed on a simulator, booting that simulator in Device Hub when it is not running. It never builds the native app, since a build takes minutes and changes the simulator's state.

## Mobile signal

`expo` or `react-native` in `package.json` dependencies, or an `ios/` dir at the root. Record the file that gave the signal. Checked before the web signal: the Expo template ships `react-native-web` and a `web` script, which would otherwise read as a web app.

## Availability

The `ios-simulator` MCP tools must be listed in this session; `list_apps` is the probe. A missing tool means the driver is unavailable.

## App

- Bundle id: `expo.ios.bundleIdentifier` in `app.json` (top-level `ios.bundleIdentifier` in `app.config.*`, or in an `app.json` without the `expo` key), else `PRODUCT_BUNDLE_IDENTIFIER` in `ios/*.xcodeproj/project.pbxproj`.
- Expo Go project (no `ios/` dir and no `expo-dev-client` dependency): the bundle id is `host.exp.Exponent`.

## Simulator

Pick the device by the app, since an install belongs to one device. Check in order and stop at the first hit:

1. A booted device (`xcrun simctl list devices booted`) whose `list_apps` includes the bundle id. That counts as found running.
2. A shut-down available device with the app on disk: an `Info.plist` under `<dataPath>/Containers/Bundle/Application/*/*.app/` whose `CFBundleIdentifier` is the bundle id (`dataPath` from `xcrun simctl list devices available -j`; `simctl listapps` refuses a shut-down device). With several, take the one whose `.app` is newest, which is the freshest build.

No hit is `app not installed on any simulator`. Record the udid and pass it on every MCP call.

## Recipe

Metro serves the JS bundle. Check in order and stop at the first hit:

1. Metro already answering: `curl -s localhost:8081/status` returns `packager-status:running`. That counts as found running.
2. A Metro or start command in `CLAUDE.md`, `AGENTS.md`, or `README`.
3. The project's `start` script in `package.json`.
4. `npx expo start` for an Expo project, `npx react-native start` otherwise.

Credentials come only from those same documents: literal values, or env variable names the documents give with the file that holds them (for example `$SMOKE_EMAIL` in `.env.local`). Read only the file a document names.

Record the recipe as start command, readiness probe, stop command, and a found-running flag.

## Launch

1. A shut-down device from `Simulator`: record whether Device Hub was running (`pgrep -x DeviceHub`), then `xcrun simctl boot <udid>`, `open -b com.apple.dt.Devices` so the device shows in Device Hub, and `xcrun simctl bootstatus <udid>` to wait for the boot. Device Hub replaces Simulator.app in current Xcode, so the MCP's `open_simulator` is not used. A boot counts against the readiness cap.
2. Create `.ios-simulator-mcp/` at the repo root (`mkdir -p`); the MCP does not create a screenshot's parent dir. When `.gitignore` does not cover it, add it to `.git/info/exclude`. That file is per clone and never committed.
3. A found-running Metro is used as is. Its log is out of reach, so the Metro error signal is unobserved for the run: record that for the caller's report, and error checks rest on the screen signal alone.
4. Otherwise run the recipe's start command in the background with job control on (`set -m`), stdout and stderr to a log file in the scratch dir, and record its pid so the process group can be stopped later.
5. Record whether the app was already running (`xcrun simctl spawn <udid> launchctl list | grep <bundle-id>`), then `launch_app` with `terminate_running` true.
6. Readiness: Metro reports `packager-status:running` and `ui_describe_all` shows the app's own first screen. Poll every 2 s, within 180 s, since a cold first bundle is slow. Each poll that shows the Expo dev launcher or Expo Go home instead: tap the entry for the Metro URL, then keep polling. This is connection, not navigation, so it does not count against the interaction cap.

## Relaunch

Before each row: `launch_app` with `terminate_running` true, then readiness as in Launch step 6, connection taps included. Every row starts cold from the app's first screen, the way a tester opens the app.

## Tap

Find the element with `ui_find_element`: search by its accessibility label, or its visible text, with `matchMode` `exact` first and then `substring`. Poll every 1 s, within 10 s, since the screen may still be transitioning or loading. Tap the center of its frame with `ui_tap`. Text entry: tap the field, then `ui_type`. A documented login is the login screen's fields and submit, done this way; the calling skill counts it against its interaction cap.

## Error signals

- Metro: error-level lines in the log written during the row's window. Lines from before the first row are the startup set.
- Screen: `ui_describe_all` showing a red screen or an error LogBox ("Render Error", "Uncaught Error", "Syntax Error", an "Error" banner from LogBox). A yellow warning LogBox is not an error.

## Stop

The calling skill runs this on every exit after Launch has run, including a skip.

- `kill -- -<pid>` on the recorded Metro process group; done when `pgrep -g <pid>` returns nothing and `lsof -i :8081` shows the port free.
- `terminate_app` when this run launched the app and it was not running before.
- `xcrun simctl shutdown <udid>` when this run booted the device, and quit Device Hub (`osascript -e 'quit app id "com.apple.dt.Devices"'`) when this run opened it.
- A device that was already booted stays booted. A found-running Metro, and an app that was running before the run, are left running.
