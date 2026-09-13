# iOS driver (ios-simulator MCP)

Mechanics for the `ios-simulator` driver. The workflow in [`SKILL.md`](SKILL.md) decides when each section runs and sets the caps.

## Launch

1. Scheme: the one the docs name, else the first app scheme from `xcodebuild -list -json`.
2. Simulator: `get_booted_sim_id`; when none is booted, `open_simulator` and record that this run booted it.
3. Build: `xcodebuild build -scheme <scheme> -destination 'platform=iOS Simulator,id=<udid>' -derivedDataPath <scratch dir>`, within the build cap.
4. Locate the built `.app` under the derived data products dir and read the bundle id with `plutil -extract CFBundleIdentifier raw <app>/Info.plist`.
5. `install_app`, then `launch_app`.
6. Readiness: `ui_describe_all` returns the root screen within the readiness cap.

## Screen derivation

- SwiftUI: follow `NavigationLink`, `TabView`, and `.sheet` from the root view to the changed view; UIKit: follow push and present calls.
- The observable is a `Text` literal or an `accessibilityIdentifier` in the changed view.
- A screen more taps from the root than the interaction cap allows is `Not covered: over step cap`.

## Drive

Per row:

1. Reach the screen with `ui_find_element` and `ui_tap` per reach step.
2. `ui_describe_all` to confirm the observable is present.
3. Crash check: the app is still the foreground process, and no new `~/Library/Logs/DiagnosticReports/<App>*.ips` file appeared since launch.
4. Error lines: `xcrun simctl spawn <udid> log show --predicate 'process == "<App>"' --last <seconds since launch>s`, error level only, diffed against the baseline.
5. `screenshot` with `output_path` set to the smoke name under `.ios-simulator-mcp/`.

## Stop

- `terminate_app` with the bundle id.
- `xcrun simctl shutdown <udid>` only when this run booted the simulator.
