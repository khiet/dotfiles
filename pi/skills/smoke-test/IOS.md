# iOS driver (ios-simulator MCP)

Mechanics for the `ios-simulator` driver. The workflow in [`SKILL.md`](SKILL.md) decides when each section runs and sets the caps.

## Launch

1. Scheme: the one the docs name, else the scheme named after the project, else the first scheme from `xcodebuild -list -json` whose `xcodebuild -showBuildSettings -scheme <scheme>` reports `PRODUCT_TYPE = com.apple.product-type.application`.
2. Simulator: `get_booted_sim_id`. When none is booted, `open_simulator`, poll `get_booted_sim_id` every 5 s until it returns a udid within the readiness cap, and record that this run booted it. Every later tool call passes that udid.
3. Build: `xcodebuild build -scheme <scheme> -destination 'platform=iOS Simulator,id=<udid>' -derivedDataPath <scratch dir>`, within the build cap.
4. Locate the built `.app` under the derived data products dir and read the bundle id with `plutil -extract CFBundleIdentifier raw <app>/Info.plist`.
5. `install_app`, then `launch_app` with `terminate_running` true, recording the launch timestamp.
6. Readiness: `ui_describe_all` shows a literal from the app's root view (its first `Text`, tab title, or navigation title) within the readiness cap. The tree alone is not readiness, since it also describes the home screen.

## Screen derivation

- SwiftUI: follow `NavigationLink`, `TabView`, and `.sheet` from the root view to the changed view; UIKit: follow push and present calls.
- React Native and Expo: follow the navigator config (`createStackNavigator`, `createBottomTabNavigator`, or `expo-router` files under `app/`) from the root to the changed component.
- The observable is a `Text` literal, an `accessibilityIdentifier`, or a React Native `testID`, which surfaces as the accessibility identifier.
- A screen more taps from the root than the interaction cap allows is `Not covered: over step cap`.

## Drive

Per row:

1. Start at the root: `launch_app` with `terminate_running` true, and record the row's start timestamp.
2. Reach the screen with `ui_find_element` and `ui_tap` per reach step.
3. `ui_describe_all` to confirm the observable is present.
4. Crash check: the app is still the foreground process, and no new `~/Library/Logs/DiagnosticReports/<App>*.ips` file appeared since the row started.
5. Error lines: `xcrun simctl spawn <udid> log show --predicate 'process == "<App>"' --start '<row start timestamp>'`, error level only. The startup set is the same command from the launch timestamp to the first row's start.
6. `screenshot` with `output_path` set to the smoke name under `.ios-simulator-mcp/`.

## Stop

- `terminate_app` with the bundle id. This run launched it, so it owns the process.
- `xcrun simctl shutdown <udid>` only when this run booted the simulator.
