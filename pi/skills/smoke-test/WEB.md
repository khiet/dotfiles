# Web driver (Playwright MCP)

Mechanics for the `playwright` driver. The workflow in [`SKILL.md`](SKILL.md) decides when each section runs and sets the caps.

## Launch

1. Probe the documented URL first: `curl -sI <url>`. Any HTTP response means the app is found running; record it and skip to readiness.
2. Otherwise run the recipe's script in the background with stdout and stderr to a log file in the scratch dir, and record its pid. A backgrounded command shares the shell's process group, so the pid is the handle the stop step walks.
3. Read the local URL from the log (dev servers print it); fall back to the documented URL when the log has none within the readiness cap.
4. Readiness: poll the base URL every 2 s until it answers below 500, within the readiness cap.
5. `docker compose up`: record the service names it started that `docker compose ps` did not already list as running.

## Route derivation

- File-based routers: a file under `pages/`, `app/`, `routes/`, or `src/routes/` maps to its path segment; `index` and `page` files map to the directory; bracketed segments are parameters.
- Config routers: search for `path:` entries or `<Route path=` elements that import the changed component.
- Anything else: grep for importers of the changed file and walk up until a route file is hit. A file with no route within three hops is `Not covered: needs data` with the chain noted.
- A documented login: `browser_navigate` to the login route, `browser_fill_form` with the documented credentials, and submit. This spends the interaction budget for every row that needs it.

## Drive

Per row:

1. `browser_navigate` to the route.
2. Wait by observable kind. Text: `browser_wait_for` with `text`. Control, test id, or style-only: `browser_wait_for` with `time` 2, since the tool has no network-idle mode.
3. Confirm by observable kind. Text or control: `browser_find` with the text or role. Test id: `browser_evaluate` with `() => document.querySelector('[data-testid="<id>"]') !== null`, because the accessibility snapshot carries no test ids. Style-only: `browser_snapshot` returns a tree.
4. `browser_console_messages` with `level` `error`. The default window is since the last navigation, so this is the row's own output; the startup set was read the same way after the root load.
5. `browser_take_screenshot` with `filename` set to the smoke name under `.playwright-mcp/`.

## Stop

- `pkill -P <pid>; kill <pid>` on the recorded pid, then `lsof -i :<port>` to confirm the port is free.
- `docker compose stop <services>` for the services this run started, so services already running stay up.
- `browser_close`.
- A found-running app is left untouched.
